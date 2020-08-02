
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
}
