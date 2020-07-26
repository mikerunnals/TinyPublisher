import XCTest
@testable import TinyPublisher

final class TinyPublisherTests: XCTestCase {
    
    var cancellables: [AnyCancellable] = []
    
    func testExample() {
        
        let publisher = TinyPublisher<Bool>()
        
        let e = expectation(description: "true")
        
        publisher.sink { value in
            XCTAssertTrue(value)
            e.fulfill()
        }.store(in: &cancellables)
        
        publisher.send(true)
        
        waitForExpectations(timeout: 1)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
