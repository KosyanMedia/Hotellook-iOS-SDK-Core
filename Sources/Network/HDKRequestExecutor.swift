import Alamofire

@objc public protocol Cancellable: class {
    func cancel()
}

extension HDKResource: URLRequestConvertible {
    public func asURLRequest() throws -> URLRequest {
        return try request()
    }
}

public class CancellableTask: NSObject, Cancellable {
    private let task: Request
    init(task: Request) {
        self.task = task
    }

    public func cancel() {
        task.cancel()
    }
}

open class HDKRequestExecutor: NSObject {
    static let urlCache = URLCache(memoryCapacity: 5 * 1024 * 1024, diskCapacity: 300 * 1024 * 1024, diskPath: "networkCache")

    private static let kDefaultTimeout: TimeInterval = 60

    private let queue = DispatchQueue(label: "com.hotellookSDK.requestExecutor", attributes: [.concurrent])
    private let manager: SessionManager = HDKRequestExecutor.createSessionManager()

    @discardableResult
    open func load<T>(resource: HDKResource<T>, completion: @escaping (T?, Error?) -> Void) -> Cancellable? {

        let task = manager.request(resource).validate().responseData(queue: queue) { response in
            do {
                switch response.result {
                case .success(let data):
                    let parsed = try resource.parse(data)
                    completion(parsed, nil)
                case .failure(let err):
                    completion(nil, err)
                }
            } catch let err {
                completion(nil, err)
            }
        }
        return CancellableTask(task: task)
    }

    private static func createSessionManager() -> SessionManager {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = kDefaultTimeout
        configuration.urlCache = HDKRequestExecutor.urlCache

        let manager = SessionManager(configuration: configuration)
        manager.retrier = HDKRequestRetrier()
        return manager
    }

    public static func isCacheBiggerThanMax() -> Bool {
        return urlCache.currentDiskUsage > urlCache.diskCapacity
    }

    public static func cleanupCache() {
        urlCache.removeAllCachedResponses()
    }
}
