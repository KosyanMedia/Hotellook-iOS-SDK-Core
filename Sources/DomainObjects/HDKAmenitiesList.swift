@objcMembers
public final class HDKAmenitiesList: NSObject, NSCoding {
    public let hotel: [HDKAmenity]
    public let room: [HDKAmenity]
    public let language: [HDKAmenity]

    internal init(proto: PBHotel.AmenitiesV2) {
        hotel = proto.categories["hotel"]?.values.map { HDKAmenity(proto: $0) } ?? []
        room = proto.categories["room"]?.values.map { HDKAmenity(proto: $0) } ?? []
        language = proto.categories["language"]?.values.map { HDKAmenity(proto: $0) } ?? []
    }

    public override init() {
        hotel = []
        room = []
        language = []
    }

    public init?(coder aDecoder: NSCoder) {
        hotel = aDecoder.decodeObject(forKey: "hotel") as? [HDKAmenity] ?? []
        room = aDecoder.decodeObject(forKey: "room") as? [HDKAmenity] ?? []
        language = aDecoder.decodeObject(forKey: "language") as? [HDKAmenity] ?? []
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(hotel, forKey: "hotel")
        aCoder.encode(room, forKey: "room")
        aCoder.encode(language, forKey: "language")
    }

}
