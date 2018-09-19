import Foundation
import CoreLocation

public class HDKFacade: NSObject {
    private let requestExecutor: HDKRequestExecutor
    private let api: HDKResourceFactory

    public init(config: HDKConfig) {
        self.api = HDKResourceFactory(appHostName: config.appHostName, lang: config.lang)
        self.requestExecutor = HDKRequestExecutor()
    }

    public init(api: HDKResourceFactory, requestExecutor: HDKRequestExecutor) {
        self.api = api
        self.requestExecutor = requestExecutor
        super.init()
    }

    @discardableResult
    public func loadCurrencies(completion: @escaping (HDKCurrencyInfo?, Error?) -> Void) -> Cancellable? {
        return requestExecutor.load(resource: api.currencies(), completion: completion)
    }

    @discardableResult
    public func loadTopCities(limit: Int, completion: @escaping ([HDKCity]?, Error?) -> Void) -> Cancellable? {
        return requestExecutor.load(resource: api.topCities(limit: limit), completion: completion)
    }

    @discardableResult
    public func loadReviews(hotelId: String, limit: Int, completion: @escaping (HDKReviewsResponse?, Error?) -> Void) -> Cancellable? {
        return requestExecutor.load(resource: api.reviews(hotelId: hotelId, limit: limit), completion: completion)
    }

    @discardableResult
    public func loadHotels(citiesIds: [String], priceless: Bool, apartments: Bool, completion: @escaping (HDKLocationListResponse?, Error?) -> Void) -> Cancellable? {
        return requestExecutor.load(resource: api.hotels(citiesIds: citiesIds, priceless: priceless, apartments: apartments), completion: completion)
    }

    @discardableResult
    public func loadHotelDetails(hotelId: String, completion: @escaping (HDKHotel?, Error?) -> Void) -> Cancellable? {
        return requestExecutor.load(resource: api.hotelDetails(hotelId: hotelId), completion: completion)
    }

    @discardableResult
    public func loadDeeplinkInfo(url: String, completion: @escaping (HDKDeeplinkInfo?, Error?) -> Void) -> Cancellable? {
        return requestExecutor.load(resource: api.deeplinkInfo(url: url), completion: completion)
    }

    @discardableResult
    public func loadMinPrice(city: HDKCity, currency: HDKCurrency, adults: Int, completion: @escaping (HDKMinPriceInfo?, Error?) -> Void) -> Cancellable? {
        return requestExecutor.load(resource: api.minPrice(city: city, currency: currency, adults: adults), completion: completion)
    }

    @discardableResult
    public func loadAutocomplete(text: String, limit: Int, completion: @escaping (HDKAutocompleteResponse?, Error?) -> Void) -> Cancellable? {
        return requestExecutor.load(resource: api.autocomplete(text: text, limit: limit), completion: completion)
    }

    @discardableResult
    public func loadNearbyCities(location: CLLocation, completion: @escaping ([HDKCity]?, Error?) -> Void) -> Cancellable? {
        return requestExecutor.load(resource: api.nearbyCities(location: location), completion: completion)
    }

    // MARK: - RoomsLoader

    public func roomsLoader() -> HDKRoomsLoader {
        return HDKRoomsLoader(requestExecutor: requestExecutor, api: api)
    }

}
