import CoreLocation
import Alamofire

private enum HDKHttpMethod {
    case get
    case post
    case put
    case delete

    func toAlamofireHttpMethod() -> HTTPMethod {
        switch self {
        case .get: return .get
        case .post: return .post
        case .put: return .put
        case .delete: return .delete
        }
    }
}

open class HDKResourceFactory: NSObject {

    private let appHostName: String
    private let lang: String
    private let amplitudeId: String?

    public init(appHostName: String, lang: String, amplitudeId: String? = nil) {
        self.appHostName = appHostName
        self.lang = lang
        self.amplitudeId = amplitudeId
    }

    private func dateParamToString(date: Date) -> String {
        return HDKDateUtil.sharedServerDateFormatter.string(from: date)
    }

    private func makeRequest(url: String, method: HDKHttpMethod, params: [String: Any]?) throws -> URLRequest {

        let preparedParams = prepareParams(origParams: params)

        var request: URLRequest = try URLRequest(url: url, method: method.toAlamofireHttpMethod())
        switch method {
        case .get:
            request = try URLEncoding.default.encode(request, with: preparedParams)
        case .post:
            request = try JSONEncoding.default.encode(request, with: preparedParams)
        case .put:
            request = try JSONEncoding.default.encode(request, with: preparedParams)
        case .delete:
            request = try JSONEncoding.default.encode(request, with: preparedParams)
        }

        return prepareRequest(origRequest: request)
    }

    open func prepareRequest(origRequest: URLRequest) -> URLRequest {
        var request = origRequest
        request.setValue(HDKClientDeviceInfo.metaHeader(withAmplitudeDeviceId: amplitudeId, host: appHostName), forHTTPHeaderField: "Client-Device-Info")
        request.setValue("application/x-protobuf", forHTTPHeaderField: "Accept")
        return request
    }

    open func prepareParams(origParams: [String: Any]?) -> [String: Any]? {
        return origParams
    }

    private func makeUrl(path: String) -> String {
        return "https://api.hotellook.com/" + path
    }

    public func hotels(citiesIds: [String], priceless: Bool, apartments: Bool) -> HDKResource<HDKLocationListResponse> {

        let citiesIdsInt: [Int] = citiesIds.compactMap { Int($0) }

        let url = makeUrl(path: "location/info")
        let params: [String: Any] = [
            "locations_ids": citiesIdsInt,
            "locale": lang,
            "use_trustyou_rating": true,
            "hide_without_minprice": priceless,
            "hide_pois_without_name": true,
            "rentals": apartments,
            "fields": "locations,pois,districts,hotels,trustyou,hotels_known_guests,hotels_amenities,hotels_room_photos"
        ]

        let req: () throws -> URLRequest = {
            return try self.makeRequest(url: url, method: .get, params: params)
        }

        let resource = HDKResource<HDKLocationListResponse>(request: req, parse: { data in
            let proto = try PBLocationInfoResponse(serializedData: data)
            return HDKLocationListResponse(proto: proto)
        })

        return resource
    }

    public func hotelDetails(hotelId: String) -> HDKResource<HDKHotel> {
        let urlString = makeUrl(path: "hotel/info")
        let params: [String: Any] = [
            "use_trustyou_rating": true,
            "hotels_ids": [Int(hotelId)],
            "hide_pois_without_name": true,
            "locale": lang,
            "fields": "hotels,trustyou,districts,pois,locations"
        ]
        let req = { try self.makeRequest(url: urlString, method: .get, params: params) }
        let resource = HDKResource<HDKHotel>(request: req, parse: { data in
            let proto = try PBHotelInfoResponse(serializedData: data)
            let response = HDKHotelInfoResponse(proto: proto)
            guard let hotel = response.hotels.first else {
                throw HDKError.parsingError
            }
            return hotel
        })
        return resource
    }

    public func currencies() -> HDKResource<HDKCurrencyInfo> {
        let urlString = makeUrl(path: "currency/info")
        let params = [
            "locale": lang,
            "fields": "meta"
        ]
        let req = { try self.makeRequest(url: urlString, method: .get, params: params) }

        let resource = HDKResource<HDKCurrencyInfo>(request: req, parse: { data in
            let proto = try PBCurrencyInfoResponse(serializedData: data)
            return HDKCurrencyInfo(proto: proto)
        })
        return resource
    }

    public func minPrice(city: HDKCity, currency: HDKCurrency, adults: Int) -> HDKResource<HDKMinPriceInfo> {
        let urlString = makeUrl(path: "minprice/calendar")
        let params: [String: Any] = [
            "currency": currency.code,
            "adults": adults,
            "location_id": city.cityId,
            "price_groups": 3,
            "fields": "dates"
        ]
        let req = { try self.makeRequest(url: urlString, method: .get, params: params) }
        let resource = HDKResource<HDKMinPriceInfo>(request: req, parse: { data in
            let proto = try PBMinpriceCalendarResponse(serializedData: data)
            return HDKMinPriceInfo(city: city, currency: currency, adults: adults, proto: proto)
        })
        return resource
    }

    public func topCities(limit: Int) -> HDKResource<[HDKCity]> {
        let urlString = makeUrl(path: "location/top")
        let params: [String: Any] = [
            "locale": lang,
            "limit": limit,
            "fields": "locations"
        ]
        let req = { try self.makeRequest(url: urlString, method: .get, params: params) }

        let resource = HDKResource<[HDKCity]>(request: req, parse: { data in
            let proto = try PBLocationTopResponse(serializedData: data)
            return proto.locations.map { HDKCity(proto: $0) }
        })
        return resource
    }

    public func autocomplete(text: String, limit: Int) -> HDKResource<HDKAutocompleteResponse> {
        let urlString = makeUrl(path: "complete/search")
        let params: [String: Any] = [
            "term": text,
            "locale": lang,
            "limit": limit,
            "fields": "hotels,cities,airports,locations"
        ]

        let req = { try self.makeRequest(url: urlString, method: .get, params: params) }
        let resource = HDKResource<HDKAutocompleteResponse>(request: req, parse: { data in
            let proto = try PBCompleteResponse(serializedData: data)
            return HDKAutocompleteResponse(proto: proto)
        })
        return resource
    }

    public func nearbyCities(location: CLLocation) -> HDKResource<[HDKCity]> {
        let urlString = makeUrl(path: "location/info")
        let params: [String: Any] = [
            "locale": lang,
            "lat": location.coordinate.latitude,
            "lon": location.coordinate.longitude,
            "fields": "locations"
        ]

        let req = { try self.makeRequest(url: urlString, method: .get, params: params) }
        let resource = HDKResource<[HDKCity]>(request: req, parse: { data in
            let proto = try PBLocationInfoResponse(serializedData: data)
            return proto.locations.map { cityId, pblocation in
                HDKCity(proto: pblocation)
            }
        })
        return resource
    }

    public func deeplinkInfo(url: String) -> HDKResource<HDKDeeplinkInfo> {
        let req = { try self.makeRequest(url: url, method: .get, params: nil) }
        let resource = HDKResource<HDKDeeplinkInfo>(request: req, parse: { data in
            let proto = try PBClickResponse(serializedData: data)
            return HDKDeeplinkInfo(proto: proto)
        })

        return resource
    }

    public func reviews(hotelId: String, limit: Int) -> HDKResource<HDKReviewsResponse> {
        let urlString = makeUrl(path: "review/hotel")
        let params: [String: Any] = [
            "id": hotelId,
            "locale": lang,
            "limit": limit,
            "fields": "reviews,gates"
        ]
        let req = { try self.makeRequest(url: urlString, method: .get, params: params) }
        let resource = HDKResource<HDKReviewsResponse>(request: req, parse: { data in
            let proto = try PBReviewHotelResponse(serializedData: data)
            return try HDKReviewsResponse(proto: proto)
        })

        return resource
    }

    // MARK: - Rooms search

    private func marketingParams(_ marketing: HDKMarketingParams) -> [String: Any] {
        var result: [String: Any] = [:]
        if let hls = marketing.hls {
            result["flags[utm]"] = hls
        }
        if let utm = marketing.utm {
            result["flags[utmDetail]"] = utm
        }
        return result
    }

    private func commonStartSearchParams(searchInfo: HDKSearchInfo, marker: String?, marketing: HDKMarketingParams?) -> [String: Any] {
        var params: [String: Any] = [
            "check_in": searchInfo.checkInDate.flatMap(dateParamToString) ?? "unknown",
            "check_out": searchInfo.checkOutDate.flatMap(dateParamToString) ?? "unknown",
            "locale": lang,
            "rooms": [
                ["adults": searchInfo.adultsCount, "children": searchInfo.kidAgesArray]
            ],
            "currency": searchInfo.currency.code,
            "host": appHostName,
            "mobile_token": HDKTokenManager.mobileToken(),
            "allow_en": searchInfo.allowEnglishOTA,
            "discounts": true,
            "result_chunk_size": 0
        ]

        if let unwrappedMarketing = marketing {
            params = params + marketingParams(unwrappedMarketing)
        }

        if let unwrappedMarker = marker, !unwrappedMarker.isEmpty {
            params["marker"] = unwrappedMarker
        }

        return params
    }

    private func startRoomsSearch(params: [String: Any]) -> HDKResource<HDKSearchCreateResponse> {
        let urlString = makeUrl(path: "search/create")

        let req = { try self.makeRequest(url: urlString, method: .post, params: params) }

        let resource = HDKResource<HDKSearchCreateResponse>(request: req, parse: { data in
            let proto = try PBSearchCreateResponse(serializedData: data)
            return HDKSearchCreateResponse(proto: proto)
        })

        return resource
    }

    internal func startCityRoomsSearch(searchInfo: HDKSearchInfo, marker: String?, marketing: HDKMarketingParams?) -> HDKResource<HDKSearchCreateResponse> {

        var locationParams: [String: [Int]] = [:]
        if let cityId = searchInfo.city?.cityId, let cityIdInt = Int(cityId) {
            locationParams["locations_ids"] = [cityIdInt]
        } else if let nearbyCities = searchInfo.locationPoint?.nearbyCities, nearbyCities.count > 0 {
            locationParams["locations_ids"] = nearbyCities.compactMap { Int($0.cityId) }
        }

        let params = locationParams + commonStartSearchParams(searchInfo: searchInfo, marker: marker, marketing: marketing)
        return startRoomsSearch(params: params)
    }

    internal func startHotelRoomsSearch(hotelId: String, searchInfo: HDKSearchInfo, marker: String?, marketing: HDKMarketingParams?) -> HDKResource<HDKSearchCreateResponse> {
        let locationParams: [String: Any] = [
            "hotels_ids": [Int(hotelId)]
        ]

        let params = locationParams + commonStartSearchParams(searchInfo: searchInfo, marker: marker, marketing: marketing)
        return startRoomsSearch(params: params)
    }

    internal func roomsSearchResults(searchId: String, loadedGatesIds: [String]) -> HDKResource<PBSearchResultResponse> {
        let urlString = makeUrl(path: "search/result")

        let params: [String: Any] = [
            "search_id": searchId,
            "received_gates_ids": loadedGatesIds.compactMap { Int($0) },
            "fields": "gates,stop,hotels,hotels_discounts,hotels_highlights,badges"
        ]

        let req = { try self.makeRequest(url: urlString, method: .get, params: params) }
        let resource = HDKResource<PBSearchResultResponse>(request: req, parse: { data in
            return try PBSearchResultResponse(serializedData: data)
        })

        return resource
    }
}
