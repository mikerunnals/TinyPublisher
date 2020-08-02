
public final class AnyCancellable : Cancellable {
    
    func store(in array: inout [AnyCancellable]) {
        array.append(self)
    }
    
    public func cancel() {
        // TODO: must be thread-safe.
        cancelClosure?()
        cancelClosure = nil
    }
    
    private var cancelClosure: (() -> Void)?
        
    init(cancelClosure: (() -> Void)?) {
        self.cancelClosure = cancelClosure
    }
    
    deinit {
        cancel()
    }
}
