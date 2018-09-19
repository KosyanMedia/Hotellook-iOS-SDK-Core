@objcMembers
public class HDKConfig: NSObject {
    public let appHostName: String
    public let lang: String

    public init(appHostName: String, lang: String) {
        self.appHostName = appHostName
        self.lang = lang
    }
}
