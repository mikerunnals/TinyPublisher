
public class CurrentValueSubject<Output, Failure> : PassthroughSubject<Output, Failure> where Failure : Error {
    
    public var value: Output
    
    public init(_ value: Output) {
        self.value = value
        super.init()
    }
    
    override public func send(_ value: Output) {
        self.value = value
        super.send(value)
    }
    
    override public func subscribe<S>(_ subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        super.subscribe(subscriber)
        _ = subscriber.receive(value) // Send current value to new subscriber
    }
}
