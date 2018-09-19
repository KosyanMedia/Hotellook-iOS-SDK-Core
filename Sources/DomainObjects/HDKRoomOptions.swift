@objcMembers
public final class HDKRoomOptions: NSObject, NSCoding {

    public let airConditioner: Bool?
    public let breakfast: Bool?
    public let cardRequired: Bool?
    public let deposit: Bool?
    public let freeWifi: Bool?
    public let refundable: Bool?
    public let priceType: String?
    public let smoking: Bool?
    public let allInclusive: Bool?
    public let fan: Bool?
    public let dormitory: Bool?
    public let privateBathroom: Bool?
    public let available: Int?
    public let hotelWebsite: Bool?
    public let view: String?
    public let viewSentence: String?

    public override init() {
        airConditioner = nil
        breakfast = nil
        cardRequired = nil
        deposit = nil
        freeWifi = nil
        refundable = nil
        smoking = nil
        priceType = nil
        privateBathroom = nil
        allInclusive = nil
        fan = nil
        dormitory = nil
        available = nil
        hotelWebsite = nil
        view = nil
        viewSentence = nil
    }

    public init(airConditioner: Bool? = nil,
                breakfast: Bool? = nil,
                cardRequired: Bool? = nil,
                deposit: Bool? = nil,
                freeWifi: Bool? = nil,
                refundable: Bool? = nil,
                smoking: Bool? = nil,
                priceType: String? = nil,
                privateBathroom: Bool? = nil,
                allInclusive: Bool? = nil,
                fan: Bool? = nil,
                dormitory: Bool? = nil,
                available: Int? = nil,
                hotelWebsite: Bool? = nil,
                view: String? = nil,
                viewSentence: String? = nil) {
        self.airConditioner = airConditioner
        self.breakfast = breakfast
        self.cardRequired = cardRequired
        self.deposit = deposit
        self.freeWifi = freeWifi
        self.refundable = refundable
        self.smoking = smoking
        self.priceType = priceType
        self.privateBathroom = privateBathroom
        self.allInclusive = allInclusive
        self.fan = fan
        self.dormitory = dormitory
        self.available = available
        self.hotelWebsite = hotelWebsite
        self.view = view
        self.viewSentence = viewSentence
    }

    internal init(proto: PBProposalOptions) {
        airConditioner = proto.hasAirConditioner ? proto.airConditioner.val : nil
        breakfast = proto.hasBreakfast ? proto.breakfast.val : nil
        cardRequired = proto.hasCardRequired ? proto.cardRequired.val : nil
        deposit = proto.hasDeposit ? proto.deposit.val : nil
        freeWifi = proto.hasFreeWifi ? proto.freeWifi.val : nil
        refundable = proto.hasRefundable ? proto.refundable.val : nil
        smoking = proto.hasSmoking ? proto.smoking.val : nil
        priceType = proto.hasPriceType ? proto.priceType.val : nil
        allInclusive = proto.hasAllInclusive ? proto.allInclusive.val : nil
        fan = proto.hasFan ? proto.fan.val : nil
        dormitory = proto.hasDormitory ? proto.dormitory.val : nil
        privateBathroom = proto.hasPrivateBathroom ? proto.privateBathroom.val : nil
        available = proto.hasAvailable ? Int(proto.available.val) : nil
        hotelWebsite = proto.hasHotelWebsite ? proto.hotelWebsite.val : nil
        view = proto.hasView ? proto.view.val : nil
        viewSentence = proto.hasViewSentence ? proto.viewSentence.val : nil
    }

    public init?(coder aDecoder: NSCoder) {
        airConditioner = aDecoder.decodeObject(forKey: "airConditioner") as? Bool
        breakfast = aDecoder.decodeObject(forKey: "breakfast") as? Bool
        cardRequired = aDecoder.decodeObject(forKey: "cardRequired") as? Bool
        deposit = aDecoder.decodeObject(forKey: "deposit") as? Bool
        freeWifi = aDecoder.decodeObject(forKey: "freeWifi") as? Bool
        refundable = aDecoder.decodeObject(forKey: "refundable") as? Bool
        smoking = aDecoder.decodeObject(forKey: "smoking") as? Bool
        priceType = aDecoder.decodeObject(forKey: "priceType") as? String
        allInclusive = aDecoder.decodeObject(forKey: "allInclusive") as? Bool
        fan = aDecoder.decodeObject(forKey: "fan") as? Bool
        dormitory = aDecoder.decodeObject(forKey: "dormitory") as? Bool
        privateBathroom = aDecoder.decodeObject(forKey: "privateBathroom") as? Bool
        available = aDecoder.decodeObject(forKey: "available") as? Int
        hotelWebsite = aDecoder.decodeObject(forKey: "hotelWebsite") as? Bool
        view = aDecoder.decodeObject(forKey: "view") as? String
        viewSentence = aDecoder.decodeObject(forKey: "viewSentence") as? String
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(airConditioner, forKey: "airConditioner")
        aCoder.encode(breakfast, forKey: "breakfast")
        aCoder.encode(cardRequired, forKey: "cardRequired")
        aCoder.encode(deposit, forKey: "deposit")
        aCoder.encode(freeWifi, forKey: "freeWifi")
        aCoder.encode(refundable, forKey: "refundable")
        aCoder.encode(smoking, forKey: "smoking")
        aCoder.encode(priceType, forKey: "priceType")
        aCoder.encode(allInclusive, forKey: "allInclusive")
        aCoder.encode(fan, forKey: "fan")
        aCoder.encode(dormitory, forKey: "dormitory")
        aCoder.encode(privateBathroom, forKey: "privateBathroom")
        aCoder.encode(available, forKey: "available")
        aCoder.encode(hotelWebsite, forKey: "hotelWebsite")
        aCoder.encode(view, forKey: "view")
        aCoder.encode(viewSentence, forKey: "viewSentence")
    }

    public func notNilOptionsCount() -> Int {
        let options: [Any?] = [
            airConditioner,
            breakfast,
            cardRequired,
            deposit,
            freeWifi,
            refundable,
            smoking,
            priceType,
            allInclusive,
            fan,
            dormitory,
            privateBathroom,
            available,
            hotelWebsite,
            view,
            viewSentence
        ]

        return options.compactMap { $0 }.count
    }

}
