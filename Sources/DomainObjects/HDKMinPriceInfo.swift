@objc public enum HDKMinPriceRate: Int {
    case cheap = 0
    case regular = 1
    case expensive = 2
}

@objcMembers
public final class HDKMinPriceItem: NSObject {
    public let rate: HDKMinPriceRate
    public let price: Float

    internal init(proto: PBMinpriceCalendarResponse.Price) {
        rate = HDKMinPriceRate(rawValue: Int(proto.rate)) ?? .regular
        price = proto.price
    }
}

@objcMembers
public final class HDKMinPriceInfo: NSObject {
    public let pricesForDates: [String: HDKMinPriceItem]
    public let currency: HDKCurrency
    public let city: HDKCity
    public let adults: Int

    internal init(city: HDKCity, currency: HDKCurrency, adults: Int, proto: PBMinpriceCalendarResponse) {
        self.city = city
        self.currency = currency
        self.adults = adults

        self.pricesForDates = proto.dates.hdk_map { dateStr, pbprice in
            return (dateStr, HDKMinPriceItem(proto: pbprice))
        }
    }
}
