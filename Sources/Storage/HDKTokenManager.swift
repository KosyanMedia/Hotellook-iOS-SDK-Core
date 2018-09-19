import Foundation
import KeychainSwift

@objcMembers
public class HDKTokenManager: NSObject {
    private static let kMobileTokenKey = "mobileTokenKey"

    public static func mobileToken() -> String {
        if let tokenFromDefaults = loadTokenFromDefaults() {
            return tokenFromDefaults
        }

        let token = createToken()
        saveTokenToDefaults(token)
        return token
    }

    private static func loadTokenFromDefaults() -> String? {
        return HDKDefaultsSaver.loadObjectWithKey(kMobileTokenKey) as? String
    }

    private static func saveTokenToDefaults(_ token: String) {
        HDKDefaultsSaver.saveObject(token, forKey: kMobileTokenKey)
    }

    private static func createToken() -> String {
        // Keychain is used to make sure that token is the same among different app installs
        let keychain = KeychainSwift()

        if let token = keychain.get(kMobileTokenKey), !token.isEmpty {
            return token
        }

        let userId = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        let token = HDKStringUtils.aiMd5(from: userId)
        keychain.set(token, forKey: kMobileTokenKey, withAccess: KeychainSwiftAccessOptions.accessibleAlwaysThisDeviceOnly)
        return token
    }

}
