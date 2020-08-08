extension Publisher {
    
    func map<T>(_ transform: @escaping (Self.Output) -> T) -> Map<AnyPublisher<Self.Output, Self.Failure>, T> {
        return Map<AnyPublisher<Self.Output, Self.Failure>, T>(upstream: self as! AnyPublisher<Self.Output, Self.Failure>, transform: transform)
    }
}

public struct Map<Upstream, Output> : Publisher where Upstream : Publisher {
    
    public typealias Failure = Upstream.Failure
    public typealias Output = Output

    public let upstream: Upstream

    public let transform: (Upstream.Output) -> Output

    public init(upstream: Upstream, transform: @escaping (Upstream.Output) -> Output) {
        self.upstream = upstream
        self.transform = transform
    }

    public func subscribe<S>(_ subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        
    }

}
