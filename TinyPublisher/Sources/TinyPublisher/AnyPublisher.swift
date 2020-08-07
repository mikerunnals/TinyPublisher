extension Publisher {
    func eraseToAnyPublisher() -> AnyPublisher<Self.Output, Self.Failure> {
        return AnyPublisher(self)
    }
}

@frozen public struct AnyPublisher<Output, Failure>: Publisher where Failure : Error {
    
    public typealias Output = Output
    public typealias Failure = Failure
    
    let erasedPublisher: Any
    
    init<P: Publisher>(_ publisher: P) where Self.Failure == P.Failure, Self.Output == P.Output {
        self.erasedPublisher = publisher
    }
        
    public func subscribe<S>(_ subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        if let publisher = erasedPublisher as? Publisher {
            
        }
    }
}
