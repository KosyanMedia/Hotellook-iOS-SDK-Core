internal class HDKClientDeviceInfo: NSObject {
    public static func metaHeader(withAmplitudeDeviceId amplitudeDeviceId: String?, host: String) -> String {
        var meta: [String: String] = [:]

        meta["source"] = "search"
        meta["type"] = "mobile"
        meta["os"] = "ios"

        setIfNotEmpty(value: host, forHeaderName: "host", to: &meta)

        setIfNotEmpty(value: amplitudeDeviceId, forHeaderName: "amplitude_device_id", to: &meta)

        let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
        setIfNotEmpty(value: safeString(appName), forHeaderName: "application", to: &meta)

        let appId = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
        setIfNotEmpty(value: appId, forHeaderName: "application_id", to: &meta)

        let deviceId: String? = UIDevice.current.identifierForVendor?.uuidString
        setIfNotEmpty(value: deviceId, forHeaderName: "device_id", to: &meta)

        meta["token"] = HDKTokenManager.mobileToken()
        setIfNotEmpty(value: UIDevice.current.systemVersion, forHeaderName: "os_version", to: &meta)

        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        setIfNotEmpty(value: version, forHeaderName: "version", to: &meta)
        setIfNotEmpty(value: safeString(deviceModel()), forHeaderName: "device_model", to: &meta)

        let networkInfo = HDKNetworkInfo.shared
        setIfNotEmpty(value: networkInfo.currentNetworkStatusName, forHeaderName: "network", to: &meta)
        setIfNotEmpty(value: safeString(networkInfo.currentCarrierName), forHeaderName: "carrier_name", to: &meta)
        setIfNotEmpty(value: networkInfo.currentMobileCountryCode, forHeaderName: "mobile_country_code", to: &meta)
        setIfNotEmpty(value: networkInfo.currentMobileNetworkCode, forHeaderName: "mobile_network_code", to: &meta)

        return encodeHeaderDict(meta)
    }

    private static func deviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let device: String = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return device
    }

    private static func setIfNotEmpty(value: String?, forHeaderName headerName: String, to dict: inout [String: String]) {
        if let unwrapped = value, !unwrapped.isEmpty {
            dict[headerName] = unwrapped
        }
    }

    private static func safeString(_ str: String) -> String {
        var result = str
        result = result.replacingOccurrences(of: ";", with: ".")
        result = result.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        return result
    }

    private static func encodeHeaderDict(_ dict: [String: String]) -> String {
        var keysValues: [String] = []
        for (key, value) in dict {
            let keyValue = String(format: "%@=%@", key, value)
            keysValues.append(keyValue)
        }
        return keysValues.joined(separator: "; ")
    }
}
