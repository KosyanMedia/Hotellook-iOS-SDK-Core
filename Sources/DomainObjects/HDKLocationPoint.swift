import CoreLocation

@objcMembers
public final class HDKLocationPointCategory: NSObject {
    public static let kAirport = "airport"
    public static let kBeach = "beach"
    public static let kSkilift = "ski_lift"
    public static let kTrainStation = "train_station"
    public static let kMetroStation = "metro_station"
    public static let kSight = "sight"
    public static let kCityCenter = "cityCenter"
    public static let kUserLocation = "userLocation"
    public static let kCustomLocation = "customLocation"
}

@objcMembers
open class HDKLocationPoint: NSObject, NSCoding, NSCopying {

    public let name: String
    public let location: CLLocation
    public let category: String
    public var distanceToHotel: Float = 0
    public var pointId: String?

    open var actionCardDescription: String {
        return ""
    }

    internal init(proto: PBPoi, pointId: String) {
        self.pointId = pointId
        name = proto.name
        category = proto.category
        location = CLLocation(proto: proto.location)
    }

    public init(name: String, location: CLLocation) {
        self.name = name
        self.location = location
        self.category = ""
        super.init()
    }

    public init(name: String, location: CLLocation, category: String) {
        self.name = name
        self.location = location
        self.category = category
        super.init()
    }

    public init(name: String, location: CLLocation, pointId: String?, category: String) {
        self.name = name
        self.category = category
        self.pointId = pointId
        self.location = location
        super.init()
    }

    required public init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: "name") as? String,
            let location = aDecoder.decodeObject(forKey: "location") as? CLLocation
        else { return nil }

        self.name = name
        self.location = location
        category = aDecoder.decodeObject(forKey: "category") as? String ?? ""
        pointId = aDecoder.decodeObject(forKey: "pointId") as? String
        distanceToHotel = aDecoder.decodeFloat(forKey: "distanceToHotel")
    }

    open func encode(with aCoder: NSCoder) {
        aCoder.encode(pointId, forKey: "pointId")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(location, forKey: "location")
        aCoder.encode(category, forKey: "category")
        aCoder.encode(distanceToHotel, forKey: "distanceToHotel")
    }

    required public init(from other: Any) {
        guard let other = other as? HDKLocationPoint else {
            fatalError()
        }

        name = other.name
        location = other.location
        category = other.category
        distanceToHotel = other.distanceToHotel
        pointId = other.pointId
    }

    open func copy(with zone: NSZone? = nil) -> Any {
        return type(of: self).init(from: self)
    }

    override open func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? HDKLocationPoint else { return false }

        if pointId != other.pointId {
            return false
        }

        if name != other.name {
            return false
        }

        if location.distance(from: other.location) > 1 {
            return false
        }

        if category != other.category {
            return false
        }

        if distanceToHotel != other.distanceToHotel {
            return false
        }

        return true
    }

    override open var hash: Int {
        return name.hash
    }
}
