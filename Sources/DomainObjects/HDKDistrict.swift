@objcMembers
public final class HDKDistrict: NSObject, NSCoding, NSCopying {
    public let name: String
    public let districtId: String

    internal init(proto: PBDistrict, districtId: String) {
        name = proto.name
        self.districtId = districtId
    }

    public init?(coder aDecoder: NSCoder) {

        guard let name = aDecoder.decodeObject(forKey: "name") as? String,
              let districtId = aDecoder.decodeObject(forKey: "districtId") as? String else { return nil }

        self.name = name
        self.districtId = districtId

        super.init()
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(districtId, forKey: "districtId")
    }

    public func copy(with zone: NSZone? = nil) -> Any {
        let archived = NSKeyedArchiver.archivedData(withRootObject: self)
        return NSKeyedUnarchiver.unarchiveObject(with: archived)!
    }
}
