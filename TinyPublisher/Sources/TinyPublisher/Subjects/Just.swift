
struct Just<Output> : Publisher {
    
    func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        subject.receive(subscriber: subscriber)
    }
    
    
    typealias Output = Output
    typealias Failure = Never

    let subject: CurrentValueSubject<Output, Failure>
    
    init(_ output: Output) {
        self.subject = CurrentValueSubject<Output, Failure>(output)
    }
    
//    func subscribe<S>(_ subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
//        
//    }
}

//public struct Just<Output> : Publisher {
//
//    /// The kind of errors this publisher might publish.
//    ///
//    /// Use `Never` if this `Publisher` does not publish errors.
//    public typealias Failure = Never
//
//    /// The one element that the publisher emits.
//    public let output: Output
//
//    /// Initializes a publisher that emits the specified output just once.
//    ///
//    /// - Parameter output: The one element that the publisher emits.
//    public init(_ output: Output)
//
//    /// This function is called to attach the specified `Subscriber` to this `Publisher` by `subscribe(_:)`
//    ///
//    /// - SeeAlso: `subscribe(_:)`
//    /// - Parameters:
//    ///     - subscriber: The subscriber to attach to this `Publisher`.
//    ///                   once attached it can begin to receive values.
//    public func receive<S>(subscriber: S) where Output == S.Input, S : Subscriber, S.Failure == Just<Output>.Failure
//}
