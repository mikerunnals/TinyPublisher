
public final class AnyCancellable : Cancellable {
    
    func store(in array: inout [AnyCancellable]) {
        array.append(self)
    }
    
    public func cancel() {
        cancellable?.cancel()
        cancellable = nil
    }
    
    private var cancellable: Cancellable?
        
    init(cancellable: Cancellable) {
        self.cancellable = cancellable
    }
    
    init(cancelClosure: (() -> Void)?) {
        self.cancellable = ClosureCancellable(cancelClosure)
    }
    
    deinit {
        cancel()
    }
}

final class ClosureCancellable : Cancellable {
        
    public func cancel() {
        cancelClosure?()
        cancelClosure = nil
    }
    
    private var cancelClosure: (() -> Void)?
        
    init(_ cancelClosure: (() -> Void)?) {
        self.cancelClosure = cancelClosure
    }
    
    deinit {
        cancel()
    }
}
