
extension Publisher {
    
    func sink(receiveCompletion: @escaping ((Subscribers.Completion<Self.Failure>) -> Void), receiveValue: @escaping ((Self.Output) -> Void)) -> AnyCancellable {
   
        let identifier = CombineIdentifier()
        let subscriber = Subscriber(identifier)
        self.subscribe(Subscriber)

        return AnyCancellable(cancelClosure: nil)
    }
    
    func assign<Root>(to keyPath: ReferenceWritableKeyPath<Root, Self.Output>, on object: Root) -> AnyCancellable {
        // TODO: call subscribe on publisher to get subscription then return it as AnyCancellable
        return AnyCancellable(cancelClosure: nil)
    }
}

struct ClosureSubscriber : Subscriber {
    
}
