@objcMembers
public final class HDKGoodToKnow: NSObject, NSCoding {
    public let text: String
    public let score: Int

    internal init(proto: PBTrustyou.GoodToKnow) {
        text = proto.text
        score = Int(proto.score)
    }

    public init?(coder aDecoder: NSCoder) {
        guard let text = aDecoder.decodeObject(forKey: "text") as? String else {
            return nil
        }

        self.text = text
        score = aDecoder.decodeInteger(forKey: "score")
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "text")
        aCoder.encode(score, forKey: "score")
    }
}
