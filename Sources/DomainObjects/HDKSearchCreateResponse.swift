@objcMembers
public final class HDKSearchCreateResponse: NSObject {
    public let searchId: String
    public let resultsTTL: Int
    public let resultsTTLByGate: [String: Int]

    public let gatesIds: [String]
    public let gatesNamesMap: [String: String]
    public let gatesSortOrder: [String]
    public let gatesToShowUser: [String]

    public let abGroup: String?
    public let roomTypes: [String: HDKRoomType]

    internal init(proto: PBSearchCreateResponse) {
        searchId = proto.searchID
        resultsTTL = Int(proto.resultsTtl)
        resultsTTLByGate = proto.resultsTtlByGate.hdk_map { (String($0), Int($1)) }
        gatesIds = proto.gatesList.map { String($0) }
        gatesNamesMap = proto.gatesNames.hdk_map { (String($0), $1) }
        gatesSortOrder = proto.gatesSortedOrder.map { String($0) }
        gatesToShowUser = proto.gatesToShowUser.map { String($0) }
        abGroup = proto.mobileMeta.abGroup
        roomTypes = proto.roomTypes.hdk_map { (String($0), HDKRoomType(proto: $1)) }
    }
}
