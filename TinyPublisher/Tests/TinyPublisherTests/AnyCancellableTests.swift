import XCTest
@testable import TinyPublisher

final class AnyCancellableTests: XCTestCase {
        
    func testAnyCancellableGivenDeinitCalledThenCallsCancelClosure() {
        let e = expectation(description: "cancel called on deinit")
        var cancellable: AnyCancellable? = AnyCancellable {
            e.fulfill()
        }
        XCTAssertNotNil(cancellable)
        cancellable = nil
        waitForExpectations(timeout: 1)
    }
    
    func testAnyCancellableGivenCancelCalledThenCallsCancelClosure() {
        let e = expectation(description: "cancel called on deinit")
        let cancellable: AnyCancellable? = AnyCancellable {
            e.fulfill()
        }
        XCTAssertNotNil(cancellable)
        cancellable?.cancel()
        waitForExpectations(timeout: 1)
    }
    
    var deinitCancelClosure: XCTestExpectation? = nil

    func testAnyCancellableGivenCancelCalledTwiceThenCallsCancelClosureOnlyOnce() {
        deinitCancelClosure = expectation(description: "expect cancel to be called on deinit")
        
        let cancellable: AnyCancellable = AnyCancellable {
            self.deinitCancelClosure?.fulfill()
        }
        
        cancellable.cancel()
        waitForExpectations(timeout: 1)
        
        deinitCancelClosure = expectation(description: "expect cancel to NOT be called on deinit")
        deinitCancelClosure?.isInverted = true
        
        cancellable.cancel()
        waitForExpectations(timeout: 1)
    }

    static var allTests = [
        ("testAnyCancellableGivenDeinitCalledThenCallsCancelClosure", testAnyCancellableGivenDeinitCalledThenCallsCancelClosure),
        ("testAnyCancellableGivenCancelCalledThenCallsCancelClosure", testAnyCancellableGivenCancelCalledThenCallsCancelClosure),
        ("testAnyCancellableGivenCancelCalledTwiceThenCallsCancelClosureOnlyOnce", testAnyCancellableGivenCancelCalledTwiceThenCallsCancelClosureOnlyOnce)
    ]
}
