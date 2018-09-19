public final class HDKReviewHighlight: NSObject {
    public let score: Int
    public let quotes: [String]

    private let sentenses: [String]
    private let shortText: String

    internal init(sentiment: HDKSentimentScore) {
        score = sentiment.score
        quotes = sentiment.highlights
        sentenses = sentiment.summarySentences
        shortText = sentiment.shortText
    }

    public var title: String {
        return sentenses.count > 0
            ? sentenses.joined(separator: " ")
            : shortText
    }
}
