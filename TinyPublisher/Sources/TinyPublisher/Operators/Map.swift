extension Publisher {
    
    func map<T>(_ transform: @escaping (Self.Output) -> T) -> Map<AnyPublisher<Self.Output, Self.Failure>, T> {
        return Map<AnyPublisher<Self.Output, Self.Failure>, T>(upstream: self as! AnyPublisher<Self.Output, Self.Failure>, transform: transform)
    }
}

public class Map<Upstream, Output> : Publisher where Upstream : Publisher {

    public typealias Failure = Upstream.Failure
    public typealias Output = Output

    public let upstream: Upstream

    public let transform: (Upstream.Output) -> Output
    
    private var cancellables: [TinyPublisher.AnyCancellable] = []

    public init(upstream: Upstream, transform: @escaping (Upstream.Output) -> Output) {
        self.upstream = upstream
        self.transform = transform
    }

    public func subscribe<S>(_ subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {

        let sub = ClosureSubscriber<Upstream.Output, Failure>(receiveCompletion: receiveCompletion(subscriber),
                                                               receiveValue: receiveValue(subscriber))
        upstream.subscribe(sub)
        cancellables.append(sub.eraseToAnyCancellable())
    }
    
    private func receiveCompletion<S>(_ subscriber: S) -> ((Subscribers.Completion<Failure>) -> Void)? where S : Subscriber, Failure == S.Failure, Output == S.Input {
        return { completion in
            subscriber.receive(completion: completion)
        }
    }
    
    private func receiveValue<S>(_ subscriber: S) -> ((Upstream.Output) -> Void) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        return { input in
            subscriber.receive(self.transform(input))
        }
    }
}
