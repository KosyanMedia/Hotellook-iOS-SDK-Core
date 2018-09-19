public final class HDKRoomType: NSObject, NSCoding {
    public let name: String

    internal init(proto: PBRoomType) {
        name = proto.name
    }

    public init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
    }
}
