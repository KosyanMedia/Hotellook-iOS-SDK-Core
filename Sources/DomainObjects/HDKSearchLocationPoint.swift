import CoreLocation

open class HDKSearchLocationPoint: NSObject, NSCoding {
    public let title: String
    open var location: CLLocation
    open var nearbyCities: [HDKCity] = []
    open var city: HDKCity?

    public init(location: CLLocation, title: String) {
        self.location = location
        self.title = title
    }

    public required init?(coder aDecoder: NSCoder) {
        guard let title = aDecoder.decodeObject(forKey: "title") as? String,
            let location = aDecoder.decodeObject(forKey: "location") as? CLLocation
        else { return nil }

        self.title = title
        self.location = location
        nearbyCities = aDecoder.decodeObject(forKey: "nearbyCities") as? [HDKCity] ?? []
        city = aDecoder.decodeObject(forKey: "city") as? HDKCity
    }

    open func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(location, forKey: "location")
        aCoder.encode(nearbyCities, forKey: "nearbyCities")
        aCoder.encode(city, forKey: "city")
    }

    override open func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? HDKSearchLocationPoint else {
            return false
        }

        let locationEpsilon = 250.0
        return location.distance(from: other.location) < locationEpsilon
    }

    override open var hash: Int {
        return Int(round(location.coordinate.latitude)) ^ Int(round(location.coordinate.longitude))
    }
}
