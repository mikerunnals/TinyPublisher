
struct Just<Output> : Publisher {
    
    typealias Output = Output
    typealias Failure = Never

    let subject: CurrentValueSubject<Output, Failure>
    
    init(_ output: Output) {
        self.subject = CurrentValueSubject<Output, Failure>(output)
    }
    
    func subscribe<S>(_ subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        subject.subscribe(subscriber)
    }
}

