@objc public enum HDKHighlightType: Int {
    case none = 0
    case mobile = 1
    case `private` = 2
    case discount = 3
}

public final class HDKRoom: NSObject, NSCoding, NSCopying {
    public let options: HDKRoomOptions
    public let internalTypeId: String
    public let price: Float
    public let priceUsd: Float
    public let roomId: String
    public let gate: HDKGate
    public let name: String
    public let hotelId: String
    public let deeplink: String?
    public var oldPrice: Float = 0
    public var discount: Int = 0
    public var highlightTypeString: String?
    public var localizedType: String?

    internal init(proto: PBSearchResultResponse.Proposal, hotelId: String, gatesNamesMap: [String: String]) {
        self.hotelId = hotelId
        internalTypeId = String(proto.internalTypeID)
        price = proto.price
        priceUsd = proto.priceUsd

        let gateId = String(proto.gateID)
        gate = HDKGate(gateId: gateId, name: gatesNamesMap[gateId])
        name = proto.name
        options = HDKRoomOptions(proto: proto.options)
        deeplink = proto.deeplink
        roomId = String(proto.roomID)
    }

    public init(roomId: String,
                gate: HDKGate,
                name: String,
                hotelId: String,
                internalTypeId: String,
                options: HDKRoomOptions,
                price: Float,
                priceUsd: Float,
                deeplink: String? = nil) {

        self.roomId = roomId
        self.gate = gate
        self.name = name
        self.hotelId = hotelId
        self.internalTypeId = internalTypeId
        self.options = options
        self.price = price
        self.priceUsd = priceUsd
        self.deeplink = deeplink

        super.init()
    }

    public init?(coder aDecoder: NSCoder) {
        guard let options = aDecoder.decodeObject(forKey: "options") as? HDKRoomOptions,
            let name = aDecoder.decodeObject(forKey: "description") as? String,
            let gateId = aDecoder.decodeObject(forKey: "partnerId") as? String,
            let gateName = aDecoder.decodeObject(forKey: "partnerName") as? String,
            let roomId = aDecoder.decodeObject(forKey: "roomId") as? String,
            let internalTypeId = aDecoder.decodeObject(forKey: "internalTypeId") as? String,
            let hotelId = aDecoder.decodeObject(forKey: "hotelId") as? String
        else { return nil }

        self.options = options
        self.name = name
        self.gate = HDKGate(gateId: gateId, name: gateName)
        self.roomId = roomId
        self.internalTypeId = internalTypeId
        self.hotelId = hotelId

        priceUsd = aDecoder.decodeFloat(forKey: "priceUsd")
        price = aDecoder.decodeFloat(forKey: "price")
        discount = aDecoder.decodeInteger(forKey: "discount")
        oldPrice = aDecoder.decodeFloat(forKey: "oldPrice")
        deeplink = aDecoder.decodeObject(forKey: "deeplink") as? String
        highlightTypeString = aDecoder.decodeObject(forKey: "highlightType") as? String
        localizedType = aDecoder.decodeObject(forKey: "type") as? String

        super.init()
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(roomId, forKey: "roomId")
        aCoder.encode(options, forKey: "options")
        aCoder.encode(discount, forKey: "discount")
        aCoder.encode(oldPrice, forKey: "oldPrice")
        aCoder.encode(price, forKey: "price")
        aCoder.encode(priceUsd, forKey: "priceUsd")
        aCoder.encode(deeplink, forKey: "deeplink")
        aCoder.encode(internalTypeId, forKey: "internalTypeId")
        aCoder.encode(name, forKey: "description")
        aCoder.encode(gate.gateId, forKey: "partnerId")
        aCoder.encode(gate.name, forKey: "partnerName")
        aCoder.encode(hotelId, forKey: "hotelId")
        aCoder.encode(highlightTypeString, forKey: "highlightType")
        aCoder.encode(localizedType, forKey: "type")
    }

    //swiftlint:disable:next cyclomatic_complexity
    override public func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? HDKRoom else {
            return false
        }

        if roomId != other.roomId {
            return false
        }

        if options != other.options {
            return false
        }

        if discount != other.discount {
            return false
        }

        if oldPrice != other.oldPrice {
            return false
        }

        if price != other.price {
            return false
        }

        if priceUsd != other.priceUsd {
            return false
        }

        if deeplink != other.deeplink {
            return false
        }

        if internalTypeId != other.internalTypeId {
            return false
        }

        if name != other.name {
            return false
        }

        if gate != other.gate {
            return false
        }

        if hotelId != other.hotelId {
            return false
        }

        if highlightTypeString != other.highlightTypeString {
            return false
        }

        if localizedType != other.localizedType {
            return false
        }

        return true
    }

    override public var hash: Int {
        return roomId.hash ^ price.hashValue ^ hotelId.hash ^ gate.hash
    }

    public func copy(with zone: NSZone? = nil) -> Any {
        let archived = NSKeyedArchiver.archivedData(withRootObject: self)
        return NSKeyedUnarchiver.unarchiveObject(with: archived)!
    }

    // MARK: - Props

    public var hasMobileOrPrivatePriceOption: Bool {
        return options.priceType == "mobile" || options.priceType == "private"
    }

    public var hasHotelWebsiteOption: Bool {
        return options.hotelWebsite == true
    }

    public var cardRequired: Bool {
        return options.cardRequired == true
    }

    public var payNow: Bool {
        return options.deposit == true
    }

    public var payLater: Bool {
        return options.deposit == false
    }

    public var hasBreakfast: Bool {
        return options.breakfast == true
    }

    public var allInclusive: Bool {
        return options.allInclusive == true
    }

    public var hasBreakfastOrAllInclusive: Bool {
        return hasBreakfast || allInclusive
    }

    public var refundable: Bool {
        return options.refundable == true
    }

    public var smokingAllowed: Bool {
        return options.smoking == true
    }

    public var hasFan: Bool {
        return options.fan == true
    }

    public var hasAirConditioning: Bool {
        return options.airConditioner == true
    }

    public var hasSharedBathroom: Bool {
        return options.privateBathroom == false
    }

    public var hasPrivateBathroom: Bool {
        return options.privateBathroom == true
    }

    public var hasWifi: Bool {
        return options.freeWifi == true
    }

    public var isDormitory: Bool {
        return options.dormitory == true
    }

    public var availableRoomsOptionValue: Int {
        return options.available ?? -1
    }

    public var niceView: Bool {
        return options.view != nil
    }
}
