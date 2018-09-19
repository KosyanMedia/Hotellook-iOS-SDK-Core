import CoreTelephony
import Alamofire

public class HDKNetworkInfo: NSObject {

    public static let shared = HDKNetworkInfo()

    public var currentNetworkStatus: NetworkReachabilityManager.NetworkReachabilityStatus {
        return reachability?.networkReachabilityStatus ?? .unknown
    }

    public var currentNetworkStatusName: String {
        switch currentNetworkStatus {
        case .reachable(.ethernetOrWiFi):
            return "wifi"
        case .reachable(.wwan):
            if let currentRadioAccessTechnology = telephonyNetworkInfo.currentRadioAccessTechnology {
                switch currentRadioAccessTechnology {
                case CTRadioAccessTechnologyGPRS:
                    return "gprs"
                case CTRadioAccessTechnologyEdge:
                    return "edge"
                case CTRadioAccessTechnologyWCDMA:
                    return "3g"
                case CTRadioAccessTechnologyHSDPA:
                    return "3g"
                case CTRadioAccessTechnologyHSUPA:
                    return "3g"
                case CTRadioAccessTechnologyCDMA1x:
                    return "cdma"
                case CTRadioAccessTechnologyCDMAEVDORev0:
                    return "cdma"
                case CTRadioAccessTechnologyCDMAEVDORevA:
                    return "cdma"
                case CTRadioAccessTechnologyCDMAEVDORevB:
                    return "cdma"
                case CTRadioAccessTechnologyeHRPD:
                    return "3g"
                case CTRadioAccessTechnologyLTE:
                    return "lte"
                default:
                    return "3g"
                }
            }
            return "3g"
        case .notReachable:
            return ""
        case .unknown:
            return "unknown"
        }
    }

    private lazy var reachability: NetworkReachabilityManager? = NetworkReachabilityManager()

    public var currentCarrierName: String {
        if let carrier = telephonyNetworkInfo.subscriberCellularProvider, let carrierName = carrier.carrierName {
            return carrierName
        }
        return ""
    }

    public var currentMobileCountryCode: String {
        return telephonyNetworkInfo.subscriberCellularProvider?.mobileCountryCode ?? ""
    }

    public var currentMobileNetworkCode: String {
        return telephonyNetworkInfo.subscriberCellularProvider?.mobileNetworkCode ?? ""
    }

    private lazy var telephonyNetworkInfo = CTTelephonyNetworkInfo()
}
