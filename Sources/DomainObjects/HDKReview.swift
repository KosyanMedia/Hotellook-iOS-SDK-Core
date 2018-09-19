import Foundation

@objcMembers
public final class HDKReviewsResponse {
    public let reviews: [HDKReview]

    internal init(proto: PBReviewHotelResponse) throws {
        let gates: [UInt32: HDKGate] = proto.gates.hdk_map { gateId, pbgate in
            let gate = HDKGate(gateId: String(gateId), name: pbgate.beautyName)
            return (gateId, gate)
        }

        reviews = try proto.reviews.map { pbreview in
            guard let gate = gates[pbreview.gateID] else {
                throw HDKError.parsingError
            }
            return HDKReview(proto: pbreview, gate: gate)
        }
    }
}

@objcMembers
public final class HDKReview: NSObject {
    public let gate: HDKGate
    public let createdAt: Date
    public let author: String
    public let rating: Int?
    public let text: String
    public let textPlus: String
    public let textMinus: String
    public let url: String?

    internal init(proto: PBHotelReview, gate: HDKGate) {
        self.gate = gate
        author = proto.authorName
        rating = proto.hasRating ? Int(proto.rating.val * 10) : nil
        text = proto.text
        textPlus = proto.textPlus
        textMinus = proto.textMinus
        createdAt = Date(timeIntervalSince1970: TimeInterval(proto.createdAt))
        url = proto.url
    }
}
