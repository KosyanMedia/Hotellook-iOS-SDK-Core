public final class HDKAmenity: NSObject, NSCoding {
    public let name: String
    public let slug: String
    public let price: String

    internal init(proto: PBHotel.AmenitiesV2.Value) {
        name = proto.name
        slug = proto.slug
        price = proto.price
    }

    public var isFree: Bool {
        return price == "free"
    }

    public var isPriceUnknown: Bool {
        return price == ""
    }

    public var isPaid: Bool {
        return !isFree && !isPriceUnknown
    }

    public init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: "name") as? String,
              let slug = aDecoder.decodeObject(forKey: "slug") as? String
        else { return nil }

        self.name = name
        self.slug = slug
        price = aDecoder.decodeObject(forKey: "price") as? String ?? ""
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(slug, forKey: "slug")
        aCoder.encode(price, forKey: "price")
    }
}
