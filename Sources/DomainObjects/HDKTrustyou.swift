public final class HDKTrustyou: NSObject, NSCoding, NSCopying {
    public let score: Int
    public let popularity: Int
    public let reviewsCount: Int
    public let goodToKnow: [HDKGoodToKnow]
    public let languageDistribution: [HDKLanguageDistribution]
    public let tripTypeDistribution: [HDKTripTypeDistribution]
    public let summaryDescription: String?
    public let sentiments: [HDKSentimentScore]
    public let reviewHighlights: [HDKReviewHighlight]

    internal init(proto: PBTrustyou) {
        popularity = Int(proto.summary.popularity)
        reviewsCount = Int(proto.summary.reviewsCount)

        tripTypeDistribution = proto.tripTypeSplit.tripTypeSplit.map { type, percentage in
            return HDKTripTypeDistribution(type: type, percentage: Int(percentage))
        }

        languageDistribution = proto.languageSplit.map { lang, info in
            return HDKLanguageDistribution(lang: lang, percentage: Int(info.percentage))
        }

        score = Int(proto.summary.score)
        summaryDescription = proto.summary.text

        goodToKnow = proto.goodToKnow.map { HDKGoodToKnow(proto: $0) }
        sentiments = proto.sentimentScoreList.map { HDKSentimentScore(proto: $0) }

        reviewHighlights = HDKTrustyou.reviewHighlights(from: sentiments)
    }

    //swiftlint:disable:next function_parameter_count
    public init(score: Int,
                popularity: Int,
                reviewsCount: Int,
                goodToKnow: [HDKGoodToKnow]?,
                languageDistribution: [HDKLanguageDistribution]?,
                tripTypeDistribution: [HDKTripTypeDistribution]?,
                summaryDescription: String?,
                sentiments: [HDKSentimentScore]?) {

        self.score = score
        self.popularity = popularity
        self.reviewsCount = reviewsCount
        self.goodToKnow = goodToKnow ?? []
        self.languageDistribution = languageDistribution ?? []
        self.tripTypeDistribution = tripTypeDistribution ?? []
        self.summaryDescription = summaryDescription
        self.sentiments = sentiments ?? []
        self.reviewHighlights = HDKTrustyou.reviewHighlights(from: self.sentiments)
    }

    private static func reviewHighlights(from sentiments: [HDKSentimentScore]) -> [HDKReviewHighlight] {
        return sentiments.map {
            HDKReviewHighlight(sentiment: $0)
        }.filter {
            $0.quotes.count > 0
        }
    }

    public init?(coder aDecoder: NSCoder) {
        reviewsCount = aDecoder.decodeInteger(forKey: "reviewsCount")
        score = aDecoder.decodeInteger(forKey: "score")
        popularity = aDecoder.decodeInteger(forKey: "popularity")
        summaryDescription = aDecoder.decodeObject(forKey: "summaryDescription") as? String
        sentiments = (aDecoder.decodeObject(forKey: "sentiments") as? [HDKSentimentScore]) ?? []
        reviewHighlights = HDKTrustyou.reviewHighlights(from: sentiments)
        goodToKnow = (aDecoder.decodeObject(forKey: "goodToKnow") as? [HDKGoodToKnow]) ?? []
        tripTypeDistribution = (aDecoder.decodeObject(forKey: "tripTypeSplit") as? [HDKTripTypeDistribution]) ?? []
        languageDistribution = (aDecoder.decodeObject(forKey: "languageSplit") as? [HDKLanguageDistribution]) ?? []
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(reviewsCount, forKey: "reviewsCount")
        aCoder.encode(score, forKey: "score")
        aCoder.encode(popularity, forKey: "popularity")
        aCoder.encode(summaryDescription, forKey: "summaryDescription")
        aCoder.encode(sentiments, forKey: "sentiments")
        aCoder.encode(goodToKnow, forKey: "goodToKnow")
        aCoder.encode(tripTypeDistribution, forKey: "tripTypeSplit")
        aCoder.encode(languageDistribution, forKey: "languageSplit")

    }

    public func copy(with zone: NSZone? = nil) -> Any {
        let archived = NSKeyedArchiver.archivedData(withRootObject: self)
        return NSKeyedUnarchiver.unarchiveObject(with: archived)!
    }
}
