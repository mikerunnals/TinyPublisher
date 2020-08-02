
@propertyWrapper
public class Published<Value> {
    private var value: Value
    let subject: CurrentValueSubject<Value, Never>
    
    public init(wrappedValue: Value) {
        self.value = wrappedValue
        subject = CurrentValueSubject<Value, Never>(wrappedValue)
    }
    
    public init(initialValue: Value) {
        self.value = initialValue
        subject = CurrentValueSubject<Value, Never>(initialValue)
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
