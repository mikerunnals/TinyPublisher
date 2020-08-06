extension Publisher {
    func eraseToAnyPublisher() -> AnyPublisher<Self.Output, Self.Failure> {
        return AnyPublisher()
    }
}

@frozen public struct AnyPublisher<Output, Failure> where Failure : Error {
    
}
