@objcMembers
public final class HDKBadge: NSObject {
    public let systemName: String
    public let color: String
    public let text: String

    internal init(proto: PBSearchResultResponse.Badge, systemName: String) {
        self.systemName = systemName
        color = proto.color
        text = proto.label
    }
}
