internal func + <KeyType, ValueType> (left: [KeyType: ValueType], right: [KeyType: ValueType]) -> [KeyType: ValueType] {
    var result = [KeyType: ValueType]()
    for (key, value) in left {
        result[key] = value
    }
    for (key, value) in right {
        result[key] = value
    }

    return result
}

internal func += <KeyType, ValueType> (left: [KeyType: ValueType], right: [KeyType: ValueType]) -> [KeyType: ValueType] {
    var result = left
    for (key, value) in right {
        result.updateValue(value, forKey: key)
    }

    return result
}
