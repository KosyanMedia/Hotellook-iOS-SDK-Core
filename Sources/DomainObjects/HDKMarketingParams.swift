public final class HDKMarketingParams: NSObject {
    public let utm: String?
    public let hls: String?

    public init(utm: String?, hls: String?) {
        self.utm = utm
        self.hls = hls
        super.init()
    }
}
