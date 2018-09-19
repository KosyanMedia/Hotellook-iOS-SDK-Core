@objcMembers
public final class HDKSentimentScore: NSObject, NSCoding {
    public let name: String
    public let score: Int

    public let highlights: [String]
    public let summarySentences: [String]
    public let shortText: String

    internal init(proto: PBTrustyou.SentimentScoreList) {
        name = proto.categoryName
        score = Int(proto.score)

        highlights = proto.highlightList.map { $0.text }
        summarySentences = proto.summarySentenceList.map { $0.text }
        shortText = proto.shortText
    }

    public init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: "name") as? String,
              let shortText = aDecoder.decodeObject(forKey: "shortText") as? String
        else { return nil }

        self.name = name
        self.shortText = shortText
        self.score = aDecoder.decodeInteger(forKey: "score")
        self.highlights = aDecoder.decodeObject(forKey: "highlights") as? [String] ?? []
        self.summarySentences = aDecoder.decodeObject(forKey: "summarySentences") as? [String] ?? []
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(score, forKey: "score")
        aCoder.encode(highlights, forKey: "highlights")
        aCoder.encode(summarySentences, forKey: "summarySentences")
        aCoder.encode(shortText, forKey: "shortText")
    }
}
