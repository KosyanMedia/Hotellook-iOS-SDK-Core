public struct HDKResource<T> {
    public let request: () throws -> URLRequest
    public let parse: (Data) throws -> T

    public init(request: @escaping () throws -> URLRequest, parse: @escaping (Data) throws -> T) {
        self.request = request
        self.parse = parse
    }
}
