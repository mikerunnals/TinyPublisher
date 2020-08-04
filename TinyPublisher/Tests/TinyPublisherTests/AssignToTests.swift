import XCTest
@testable import TinyPublisher
import Combine

final class AssignToTests: XCTestCase {
    
    func testAssignBool() {
        
        var cancellables: [TinyPublisher.AnyCancellable] = []
        
        let subject = TinyPublisher.PassthroughSubject<Bool, Never>()
        
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
    
    @available(iOS 13.0, *)
    func testCombineAssignBool() {
        
        var cancellables: [Combine.AnyCancellable] = []
        
        let subject = Combine.PassthroughSubject<Bool, Never>()
        
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
