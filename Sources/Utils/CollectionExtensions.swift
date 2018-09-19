public extension Sequence {
    public func hdk_toDictionary<K, V>(_ transform:(_ element: Self.Iterator.Element) -> (key: K, value: V)?) -> [K: V] {
        var result: [K: V] = [:]
        for element in self {
            if let (key, value) = transform(element) {
                result[key] = value
            }
        }
        return result
    }

    public func hdk_allObjectsConfirm(_ pred: (Self.Iterator.Element) -> Bool) -> Bool {
        for elem in self {
            if !pred(elem) {
                return false
            }
        }
        return true
    }

    public func hdk_atLeastOneConfirms(_ pred: (Self.Iterator.Element) -> Bool) -> Bool {
        for elem in self {
            if pred(elem) {
                return true
            }
        }
        return false
    }

    func hdk_reduce<A>(into initial: A, _ combine: (inout A, Iterator.Element) throws -> Void) rethrows -> A {
        var result = initial
        for element in self {
            try combine(&result, element)
        }
        return result
    }
}

extension Dictionary {
    public func hdk_map<T: Hashable, U>(transform: (Key, Value) throws -> (T, U)) rethrows -> [T: U] {
        var result: [T: U] = [:]
        for (key, value) in self {
            let (transformedKey, transformedValue) = try transform(key, value)
            result[transformedKey] = transformedValue
        }
        return result
    }
}
