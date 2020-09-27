import XCTest

#if RUN_UNIT_TESTS_AGAINST_COMBINE
import Combine
#else
@testable import TinyPublisher
#endif

final class AssignToTests: XCTestCase {
    
    @available(iOS 13.0, *)
    func testAssignBool() {
        
        var cancellables: [AnyCancellable] = []
        
        let subject = PassthroughSubject<Bool, Never>()
        
        class Test {
            
            let expectation: XCTestExpectation
            
            var value: Bool = false {
                didSet {
                    expectation.fulfill()
                    XCTAssertTrue(value)
                }
            }
            
            init(expectation: XCTestExpectation) {
                self.expectation = expectation
            }
        }
        
        let test = Test(expectation: expectation(description: "expecting true"))
        
        subject.assign(to: \.value, on: test).store(in: &cancellables)

        subject.send(true)
        
        waitForExpectations(timeout: 1)
    }
        
    static var allTests = [
        ("testPassthroughSubjectBool", testAssignBool),
    ]
}
