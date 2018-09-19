final public class HDKDeeplinkInfo: NSObject {
    public let url: String
    public let scripts: [String]

    internal init(proto: PBClickResponse) {
        url = proto.deeplink
        scripts = proto.webviewjs
    }
}
