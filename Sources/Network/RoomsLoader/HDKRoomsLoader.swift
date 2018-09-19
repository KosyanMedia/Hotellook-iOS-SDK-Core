import Foundation

@objc public enum HDKRoomSearchStage: Int {
    case beforeSearch
    case gatesReceived
    case someResultsReceived
    case allResultsReceived
}

@objc public protocol HDKSearchLoaderDelegate: NSObjectProtocol {
    func searchStarted(withGates gates: [HDKGate], searchId: String?)
    func searchLoaderDidReceiveData(fromGateIds gateIds: [String])
    func searchLoaderFailed(withError error: Error)
    func searchLoaderFinished(withRooms rooms: [String: [HDKRoom]], searchId: String?)
    func searchLoaderCancelled()
}

public class HDKRoomsLoader: NSObject {
    private let kMaxSearchDuration: TimeInterval = 90

    public weak var delegate: HDKSearchLoaderDelegate?
    public private(set) var stage: HDKRoomSearchStage = .beforeSearch

    private var startSearchTask: Cancellable?
    private var searchResultsTask: Cancellable?

    private var searchCreateResponse: HDKSearchCreateResponse?

    public private(set) var badges: [String: HDKBadge] = [:]
    public private(set) var hotelsBadges: [String: [String]] = [:]
    public private(set) var hotelsRank: [String: Int] = [:]

    public var resultsTTL: Int {
        return searchCreateResponse?.resultsTTL ?? 0
    }

    public var resultsTTLByGate: [String: Int] {
        return searchCreateResponse?.resultsTTLByGate ?? [:]
    }

    public var abGroup: String? {
        return searchCreateResponse?.abGroup
    }

    public var gatesNamesMap: [String: String] {
        return searchCreateResponse?.gatesNamesMap ?? [:]
    }

    public var gatesSortOrder: [String] {
        return searchCreateResponse?.gatesSortOrder ?? []
    }

    public var roomTypes: [String: HDKRoomType] {
        return searchCreateResponse?.roomTypes ?? [:]
    }

    private var gatesIds: [String] {
        return searchCreateResponse?.gatesIds ?? []
    }

    private var searchId: String? {
        return searchCreateResponse?.searchId
    }

    private var hotelIdToRooms: [String: [HDKRoom]] = [:]
    private var searchStartTime: Date?

    private var resultsLimit: Int = 0
    private var loadedGates: Set<String> = Set()

    private let requestExecutor: HDKRequestExecutor
    private let api: HDKResourceFactory
    private let roomsParser = HDKRoomsParser()

    public init(requestExecutor: HDKRequestExecutor, api: HDKResourceFactory) {
        self.requestExecutor = requestExecutor
        self.api = api
    }

    public func cancel() {
        startSearchTask?.cancel()
        startSearchTask = nil

        searchResultsTask?.cancel()
        searchResultsTask = nil
    }

    // MARK: - Start search

    public func startSearchForCity(with searchInfo: HDKSearchInfo,
                                   marker: String?,
                                   marketing: HDKMarketingParams?) {
        stage = .beforeSearch

        let resource = api.startCityRoomsSearch(searchInfo: searchInfo,
                                                marker: marker,
                                                marketing: marketing)

        startSearchTask = requestExecutor.load(resource: resource) { [weak self] (response: HDKSearchCreateResponse?, error: Error?) in
            guard let `self` = self else { return }
            self.startSearchTask = nil

            if let err = error {
                self.processError(err)
                return
            }

            self.processSearchStarted(with: response!)
        }
    }

    public func startSearchForHotel(with searchInfo: HDKSearchInfo,
                                    marker: String?,
                                    marketing: HDKMarketingParams?,
                                    hotelId: String) {
        stage = .beforeSearch

        let resource = api.startHotelRoomsSearch(hotelId: hotelId,
                                                 searchInfo: searchInfo,
                                                 marker: marker,
                                                 marketing: marketing)

        startSearchTask = requestExecutor.load(resource: resource) { [weak self] (response: HDKSearchCreateResponse?, error: Error?) in
            guard let `self` = self else { return }
            self.startSearchTask = nil

            if let err = error {
                self.processError(err)
                return
            }

            self.processSearchStarted(with: response!)
        }
    }

    // MARK: - Polling

    private func doPollingResults() {
        let resource = api.roomsSearchResults(searchId: searchId ?? "", loadedGatesIds: Array(loadedGates))
        searchResultsTask = requestExecutor.load(resource: resource) { [weak self] (response: PBSearchResultResponse?, error: Error?) in
            guard let `self` = self else { return }
            self.searchResultsTask = nil

            if let err = error {
                self.processError(err)
                return
            }

            self.processResultsChunk(with: response!)
        }
    }

    // MARK: - Logic

    private func createGates(forGatesIds gatesIds: [String], namesMap: [String: String]) -> [HDKGate] {
        return gatesIds.map { HDKGate(gateId: $0, name: namesMap[$0] ?? "") }
    }

    // MARK: - Response parsing

    private func processError(_ error: Error) {
        DispatchQueue.main.async {
            if error._domain == NSURLErrorDomain && error._code == NSURLErrorCancelled {
                self.delegate?.searchLoaderCancelled()
            } else {
                self.delegate?.searchLoaderFailed(withError: error)
            }
        }
    }

    private func processSearchStarted(with response: HDKSearchCreateResponse) {

        searchCreateResponse = response

        loadedGates = Set()
        hotelIdToRooms = [:]
        resultsLimit = gatesIds.count
        searchStartTime = Date()
        stage = .gatesReceived

        let gates = createGates(forGatesIds: response.gatesToShowUser, namesMap: response.gatesNamesMap)
        delegate?.searchStarted(withGates: gates, searchId: searchId)

        doPollingResults()
    }

    private func processResultsChunk(with response: PBSearchResultResponse) {
        stage = .someResultsReceived

        roomsParser.collectRooms(forDataChunk: response, gatesNamesMap: gatesNamesMap, toDictionary: &hotelIdToRooms)
        tryParseBadges(from: response)

        let newGates: [String] = response.gates.hdk_map { gateId, gate in
            (String(gateId), gate)
        }.filter { gateId, gate in
            gate.received && !loadedGates.contains(gateId)
        }.map { gateId, gate in
            gateId
        }

        loadedGates.formUnion(newGates)

        DispatchQueue.main.async {
            self.delegate?.searchLoaderDidReceiveData(fromGateIds: newGates)
        }

        let searchDuration = Date().timeIntervalSince(searchStartTime!)
        let maxSearchDurationExceed = searchDuration > kMaxSearchDuration

        if response.stop {
            stage = .allResultsReceived
            DispatchQueue.main.async {
                self.delegate?.searchLoaderFinished(withRooms: self.hotelIdToRooms, searchId: self.searchId)
            }
        } else if maxSearchDurationExceed {
            DispatchQueue.main.async {
                let error = self.maxDurationError(searchDuration: searchDuration, maxSearchDuration: self.kMaxSearchDuration)
                self.delegate?.searchLoaderFailed(withError: error)
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.doPollingResults()
            }
        }
    }

    private func tryParseBadges(from response: PBSearchResultResponse) {
        guard response.hasBadges else { return }

        hotelsRank = response.badges.hotelsRank.hdk_map { hotelId, rank in (String(hotelId), Int(rank)) }
        badges = response.badges.badges.hdk_map { systemName, pbbadge in
            return (systemName, HDKBadge(proto: pbbadge, systemName: systemName))
        }
        hotelsBadges = response.badges.hotelsBadges.hdk_map { hotelId, pbbadges in
            return (String(hotelId), pbbadges.badges)
        }
    }

    private func maxDurationError(searchDuration: TimeInterval, maxSearchDuration: TimeInterval) -> Error {
        let userInfo: [String: Any] = [
            NSLocalizedDescriptionKey: String(format: "Max search duration exceed: duration %.1f, maxDuration: %.1f seconds", searchDuration, maxSearchDuration)
        ]
        return NSError(domain: HDKErrors.HDKErrorDomain, code: HDKErrorCode.searchMaxDurationExceed.rawValue, userInfo: userInfo)
    }
}
