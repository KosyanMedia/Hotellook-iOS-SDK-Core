@objcMembers
public final class HDKCurrencyInfo: NSObject, NSCoding {
    public let localeCurrencies: [HDKCurrency]
    public let otherCurrencies: [HDKCurrency]

    internal init(proto: PBCurrencyInfoResponse) {
        var popularCurrencies: [HDKCurrency] = []
        var otherCurrencies: [HDKCurrency] = []

        for pbcurrency in proto.meta {
            let currency = HDKCurrency(proto: pbcurrency)

            if pbcurrency.popular {
                popularCurrencies.append(currency)
            } else {
                otherCurrencies.append(currency)
            }
        }

        self.localeCurrencies = popularCurrencies
        self.otherCurrencies = otherCurrencies
    }

    public init(otherCurrencies: [HDKCurrency]) {
        localeCurrencies = []
        self.otherCurrencies = otherCurrencies
        super.init()
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(localeCurrencies, forKey: "localeCurrencies")
        aCoder.encode(otherCurrencies, forKey: "otherCurrencies")
    }

    public init?(coder aDecoder: NSCoder) {
        guard let localeCurrencies = aDecoder.decodeObject(forKey: "localeCurrencies") as? [HDKCurrency],
              let otherCurrencies = aDecoder.decodeObject(forKey: "otherCurrencies") as? [HDKCurrency] else { return nil }

        self.localeCurrencies = localeCurrencies
        self.otherCurrencies = otherCurrencies

        super.init()
    }
}
