public final class HDKGate: NSObject {
    public let gateId: String
    public let name: String?

    public init(gateId: String, name: String?) {
        self.gateId = gateId
        self.name = name
        super.init()
    }
}
