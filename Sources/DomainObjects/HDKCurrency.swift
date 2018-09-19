public final class HDKCurrency: NSObject, NSCopying, NSCoding {
    public let code: String
    public let symbol: String
    public let text: String
    public let formatter: NumberFormatter

    internal init(proto: PBCurrencyMeta) {
        code = proto.code
        symbol = proto.sign
        text = proto.name
        formatter = HDKCurrency.formatter(for: code, symbol: symbol)
    }

    public init(code: String, symbol: String, text: String) {
        self.code = code
        self.symbol = symbol
        self.text = text
        self.formatter = HDKCurrency.formatter(for: code, symbol: symbol)

        super.init()
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(code, forKey: "code")
        aCoder.encode(symbol, forKey: "symbol")
        aCoder.encode(text, forKey: "text")
        aCoder.encode(formatter, forKey: "formatter")
    }

    public init?(coder aDecoder: NSCoder) {
        guard let code = aDecoder.decodeObject(forKey: "code") as? String,
              let symbol = aDecoder.decodeObject(forKey: "symbol") as? String,
              let text = aDecoder.decodeObject(forKey: "text") as? String,
              let formatter = aDecoder.decodeObject(forKey: "formatter") as? NumberFormatter else { return nil }

        self.code = code
        self.symbol = symbol
        self.text = text
        self.formatter = formatter

        super.init()
    }

    public func copy(with zone: NSZone?) -> Any {
        let archived = NSKeyedArchiver.archivedData(withRootObject: self)
        return NSKeyedUnarchiver.unarchiveObject(with: archived)!
    }

    public static func formatter(for currencyCode: String, symbol: String) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        formatter.locale = Locale.current
        formatter.currencyCode = currencyCode
        formatter.currencySymbol = symbol

        return formatter
    }

    override public func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? HDKCurrency else { return false }
        return code == other.code
    }

    override public var hash: Int {
        return code.hash
    }
}
