public final class HDKKnownGuestsRoom: NSObject, NSCoding {
    public let adults: Int
    public let children: Int

    internal init(proto: PBKnownGuests.Room) {
        adults = Int(proto.adults)
        children = Int(proto.children)
    }

    public init?(coder aDecoder: NSCoder) {
        adults = aDecoder.decodeInteger(forKey: "adults")
        children = aDecoder.decodeInteger(forKey: "children")
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(adults, forKey: "adults")
        aCoder.encode(adults, forKey: "children")
    }
}

public final class HDKKnownGuests: NSObject, NSCoding {
    public let rooms: [HDKKnownGuestsRoom]

    public override init() {
        rooms = []
    }

    internal init(proto: PBKnownGuests) {
        rooms = proto.rooms.map { HDKKnownGuestsRoom(proto: $0) }
    }

    public init?(coder aDecoder: NSCoder) {
        rooms = aDecoder.decodeObject(forKey: "rooms") as? [HDKKnownGuestsRoom] ?? []
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(rooms, forKey: "rooms")
    }
}
