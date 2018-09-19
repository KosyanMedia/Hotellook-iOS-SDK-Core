import Foundation

@objcMembers
public class HDKDefaultsSaver: NSObject {

    private static let kDefaultsValueKey: String = "Value"
    private static let kDefaultsDateKey: String = "Date"

    public static func hasKey(_ key: String) -> Bool {
        return UserDefaults.standard.dictionaryRepresentation().keys.contains(key)
    }

    @discardableResult
    public static func saveObject(_ object: Any?, forKey key: String) -> Bool {
        if object == nil {
            UserDefaults.standard.removeObject(forKey: key)
            UserDefaults.standard.synchronize()

            return true
        } else if let obj = object as? NSCoding {
            let data = NSKeyedArchiver.archivedData(withRootObject: obj)
            UserDefaults.standard.set(data, forKey: key)
            UserDefaults.standard.synchronize()

            return true
        }
        assertionFailure()
        return false
    }

    public static func loadObjectWithKey(_ key: String) -> Any? {
        guard let data = UserDefaults.standard.object(forKey: key) as? Data else {
            return nil
        }

        do {
            if #available(iOS 9.0, *) {
                return try unarchiveData(data: data)
            } else {
                return try unarchiveDataIos8(data: data)
            }
        } catch {
            return nil
        }
    }

    @available(iOS 9.0, *)
    private static func unarchiveData(data: Data) throws -> Any? {
        let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
        unarchiver.decodingFailurePolicy = .setErrorAndReturn
        return try unarchiver.decodeTopLevelObject(forKey: "root")
    }

    private static func unarchiveDataIos8(data: Data) throws -> Any? {
        return try HDKObjC.catchException {
            return NSKeyedUnarchiver.unarchiveObject(with: data)
        }
    }

    public static func saveDouble(_ value: Double, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }

    public static func loadDoubleWithKey(_ key: String) -> Double {
        return UserDefaults.standard.double(forKey: key)
    }

    public static func saveInteger(_ value: Int, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }

    public static func loadIntegerWithKey(_ key: String) -> Int {
        return UserDefaults.standard.integer(forKey: key)
    }

    public static func saveBool(_ value: Bool, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }

    public static func loadBoolWithKey(_ key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }

    public static func saveParameter(_ parameter: String, withBaseKey baseKey: String) {
        let valueKey = String(format: "%@%@", baseKey, kDefaultsValueKey)
        let dateKey = String(format: "%@%@", baseKey, kDefaultsDateKey)

        saveObject(parameter, forKey: valueKey)
        saveObject(Date(), forKey: dateKey)
    }

    public static func loadParameter(withBaseKey baseKey: String, lifetime: Int) -> String? {
        let valueKey = String(format: "%@%@", baseKey, kDefaultsValueKey)
        let dateKey = String(format: "%@%@", baseKey, kDefaultsDateKey)

        guard let oldValue = loadObjectWithKey(valueKey) as? String else { return nil }
        guard let lastUpdate = loadObjectWithKey(dateKey) as? Date else { return nil }
        let interval = Date().timeIntervalSince(lastUpdate)
        if interval > TimeInterval(lifetime) {
            return nil
        }
        return oldValue
    }
}
