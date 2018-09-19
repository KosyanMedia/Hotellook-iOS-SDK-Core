public final class HDKErrors: NSObject {
    public static let HDKErrorDomain: String = "HDKErrorDomain"
}

@objc public enum HDKErrorCode: Int {
    case searchMaxDurationExceed = 0
}

public enum HDKDateError: Error {
    case incorrectFormat(dateString: String)
}

public enum HDKError: Error {
    case parsingError
}
