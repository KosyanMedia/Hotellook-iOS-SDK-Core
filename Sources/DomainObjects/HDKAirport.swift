@objcMembers
public class HDKAirport: NSObject, NSCoding, NSCopying {
    public let name: String
    public let latitude: Double
    public let longitude: Double
    public let airportId: String
    public let latinName: String

    internal init(proto: PBAirport) {
        name = proto.name
        latinName = proto.latinName
        airportId = String(proto.id)
        latitude = Double(proto.coords.lat)
        longitude = Double(proto.coords.lon)
    }

    override public func isEqual(_ object: Any?) -> Bool {
        if let object = object as? HDKAirport {
            return object.airportId == self.airportId
        } else {
            return false
        }
    }

    override public var hash: Int {
        return airportId.hash
    }

    public func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(airportId, forKey: "airportId")
        coder.encode(latitude, forKey: "latitude")
        coder.encode(longitude, forKey: "longitude")
        coder.encode(latinName, forKey: "latinName")
    }

    public required init?(coder decoder: NSCoder) {
        guard let name = decoder.decodeObject(forKey: "name") as? String,
              let airportId = decoder.decodeObject(forKey: "airportId") as? String,
              let latinName = decoder.decodeObject(forKey: "latinName") as? String else { return nil }

        let latitude = decoder.decodeDouble(forKey: "latitude")
        let longitude = decoder.decodeDouble(forKey: "longitude")

        self.name = name
        self.airportId = airportId
        self.longitude = longitude
        self.latitude = latitude
        self.latinName = latinName
    }

    public func copy(with zone: NSZone? = nil) -> Any {
        let archived = NSKeyedArchiver.archivedData(withRootObject: self)
        return NSKeyedUnarchiver.unarchiveObject(with: archived)!
    }
}
