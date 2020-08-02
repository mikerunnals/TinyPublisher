import XCTest
@testable import TinyPublisher

final class PassthroughSubjectTests: XCTestCase {
    
    var cancellables: [AnyCancellable] = []
        
    func testPassthroughSubjectBool() {
        
        let publisher = PassthroughSubject<Bool, Never>()
        
        let e = expectation(description: "true")
        
        publisher.sink { value in
            XCTAssertTrue(value)
            e.fulfill()
        }.store(in: &cancellables)
        
        publisher.send(true)
        
        waitForExpectations(timeout: 1)
    }
    
    func testGivenSubscriberCancelledThenSinkClosureIsNotCalled() {
        let publisher = PassthroughSubject<Bool, Never>()
        
        let e = expectation(description: "Expect NOT to be fulfilled!")
        e.isInverted = true
        
        let cancellable = publisher.sink { value in
            e.fulfill()
        }
        
        cancellable.cancel()
        
        publisher.send(true)
        
        waitForExpectations(timeout: 1)

    }
    
    static var allTests = [
        ("testPassthroughSubjectBool", testPassthroughSubjectBool),
    ]
}
