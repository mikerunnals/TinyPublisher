import XCTest
@testable import TinyPublisher

final class TinyPublisherTests: XCTestCase {
    
    var cancellables: [AnyCancellable] = []
    
    func testTinyPublishedPropertyWrapper() {
        
        struct Test {
            @TinyPublished var property = false
        }
                
        let test = Test()

        let e = expectation(description: "Expect sink event")

        test.$property.sink { value in
            XCTAssertEqual(true, value, "Expected value to be true")
            e.fulfill()
        }.store(in: &cancellables)

        test.property = true

        waitForExpectations(timeout: 1)
    }

    func testTinyPublisherBool() {
        
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
        ("testTinyPublisherBool", testTinyPublisherBool),
        ("testTinyPublishedPropertyWrapper", testTinyPublishedPropertyWrapper)
    ]
}
