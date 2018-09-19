@objcMembers
public final class HDKAmenityShort: NSObject, NSCoding {
    public let amenityId: String
    public let slug: String
    public let name: String
    public let category: String

    public init(amenityId: String) {
        self.amenityId = amenityId
        slug = ""
        name = ""
        category = ""
    }

    internal init(proto: PBAmenity, amenityId: String) {
        self.amenityId = amenityId
        slug = proto.slug
        name = proto.name
        category = proto.category
    }

    public init?(coder aDecoder: NSCoder) {
        guard let amenityId = aDecoder.decodeObject(forKey: "amenityId") as? String,
            let slug = aDecoder.decodeObject(forKey: "slug") as? String,
            let name = aDecoder.decodeObject(forKey: "name") as? String,
            let category = aDecoder.decodeObject(forKey: "category") as? String
        else {
            return nil
        }

        self.amenityId = amenityId
        self.slug = slug
        self.name = name
        self.category = category
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(amenityId, forKey: "amenityId")
        aCoder.encode(slug, forKey: "slug")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(category, forKey: "category")
    }
}
