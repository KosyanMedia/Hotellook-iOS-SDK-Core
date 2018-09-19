import Foundation
import Alamofire

internal class HDKRequestRetrier: RequestRetrier {

    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        if request.retryCount < 1 {
            completion(true, 0.5)
        } else {
            completion(false, 0)
        }
    }

}
