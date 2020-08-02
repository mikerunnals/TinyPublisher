
@propertyWrapper
public class TinyPublished<Value> { // TODO: How to name this Published<Value> and not collide with Foundation?
    private var value: Value
    private let subject = PassthroughSubject<Value, Never>()
    
    public init(wrappedValue: Value) {
        self.value = wrappedValue
    }
    
    public init(initialValue: Value) {
        self.value = initialValue
    }
        
    public var wrappedValue: Value {
        get {
            value
        }
        set {
            value = newValue
            subject.send(wrappedValue)
        }
    }
    
    public var projectedValue: PassthroughSubject<Value, Never> {
        subject
    }
}
