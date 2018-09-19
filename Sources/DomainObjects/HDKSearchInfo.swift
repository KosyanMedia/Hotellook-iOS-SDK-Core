open class HDKSearchInfo: NSObject, NSCoding, NSCopying {
    open var kidAgesArray: [Int]
    open var checkInDate: Date?
    open var checkOutDate: Date?
    open var city: HDKCity?
    open var locationPoint: HDKSearchLocationPoint?
    open var hotel: HDKHotel?
    open var airport: HDKAirport?

    open var currency: HDKCurrency
    open var allowEnglishOTA: Bool
    open var token: String
    open var adultsCount: Int

    public var kidsCount: Int {
        return kidAgesArray.count
    }

    public init(currency: HDKCurrency, allowEnglishOTA: Bool, token: String, adultsCount: Int) {
        self.currency = currency
        self.allowEnglishOTA = allowEnglishOTA
        self.token = token
        self.adultsCount = adultsCount
        self.kidAgesArray = []

        super.init()
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(kidAgesArray, forKey: "kidAgesArray")
        aCoder.encode(checkInDate, forKey: "checkInDate")
        aCoder.encode(checkOutDate, forKey: "checkOutDate")
        aCoder.encode(city, forKey: "city")
        aCoder.encode(locationPoint, forKey: "locationPoint")
        aCoder.encode(hotel, forKey: "hotel")
        aCoder.encode(currency, forKey: "currency")
        aCoder.encode(token, forKey: "token")
        aCoder.encode(airport, forKey: "airport")
        aCoder.encode(adultsCount, forKey: "adultsCount")
        aCoder.encode(allowEnglishOTA, forKey: "allowEnglishOTA")
    }

    public required init?(coder aDecoder: NSCoder) {
        guard let kidAgesArray = aDecoder.decodeObject(forKey: "kidAgesArray") as? [Int],
            let currency = aDecoder.decodeObject(forKey: "currency") as? HDKCurrency,
            let token = aDecoder.decodeObject(forKey: "token") as? String
        else { return nil }

        adultsCount = aDecoder.decodeInteger(forKey: "adultsCount")
        allowEnglishOTA = aDecoder.decodeBool(forKey: "allowEnglishOTA")
        self.kidAgesArray = kidAgesArray
        self.currency = currency
        self.token = token

        locationPoint = aDecoder.decodeObject(forKey: "locationPoint") as? HDKSearchLocationPoint
        checkInDate = aDecoder.decodeObject(forKey: "checkInDate") as? Date
        checkOutDate = aDecoder.decodeObject(forKey: "checkOutDate") as? Date
        city = aDecoder.decodeObject(forKey: "city") as? HDKCity
        hotel = aDecoder.decodeObject(forKey: "hotel") as? HDKHotel
        airport = aDecoder.decodeObject(forKey: "airport") as? HDKAirport
    }

    public func copy(with zone: NSZone? = nil) -> Any {
        let archived = NSKeyedArchiver.archivedData(withRootObject: self)
        return NSKeyedUnarchiver.unarchiveObject(with: archived)!
    }

    // swiftlint:disable:next cyclomatic_complexity
    open override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? HDKSearchInfo else {
            return false
        }

        if city != other.city {
            return false
        }

        if hotel != other.hotel {
            return false
        }

        if locationPoint != other.locationPoint {
            return false
        }

        if airport != other.airport {
            return false
        }

        if checkInDate != other.checkInDate {
            return false
        }

        if checkOutDate != other.checkOutDate {
            return false
        }

        if kidAgesArray != other.kidAgesArray {
            return false
        }

        if currency != other.currency {
            return false
        }

        if adultsCount != other.adultsCount {
            return false
        }

        if allowEnglishOTA != other.allowEnglishOTA {
            return false
        }

        if token != other.token {
            return false
        }

        return true
    }

    open override var hash: Int {
        return currency.hashValue ^ adultsCount.hashValue
    }
}
