import XCTest
@testable import TinyPublisher

final class PassthroughSubjectTests: XCTestCase {
    
    var cancellables: [AnyCancellable] = []
        
    func testPassthroughSubjectBool() {
        
        let subject = PassthroughSubject<Bool, Never>()
        
        let e = expectation(description: "true")
        
        subject.sink { value in
            XCTAssertTrue(value)
            e.fulfill()
        }.store(in: &cancellables)
        
        subject.send(true)
        
        waitForExpectations(timeout: 1)
    }
    
    func testGivenSubscriberCancelledThenSinkClosureIsNotCalled() {
        let subject = PassthroughSubject<Bool, Never>()
        
        let e = expectation(description: "Expect NOT to be fulfilled!")
        e.isInverted = true
        
        let cancellable = subject.sink { value in
            e.fulfill()
        }
        
        cancellable.cancel()
        
        subject.send(true)
        
        waitForExpectations(timeout: 1)

    }
    
    static var allTests = [
        ("testPassthroughSubjectBool", testPassthroughSubjectBool),
    ]
}
