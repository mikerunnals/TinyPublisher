import XCTest
@testable import TinyPublisher
import Combine

final class AnyCancellableTests: XCTestCase {
        
    func testGivenDeinitCalledThenCallsCancelClosure() {
        let e = expectation(description: "cancel called on deinit")
        var cancellable: TinyPublisher.AnyCancellable? = AnyCancellable {
            e.fulfill()
        }
        XCTAssertNotNil(cancellable)
        cancellable = nil
        waitForExpectations(timeout: 1)
    }
    
    @available(iOS 13.0, *)
    func testCombineGivenDeinitCalledThenCallsCancelClosure() {
        let e = expectation(description: "cancel called on deinit")
        var cancellable: Combine.AnyCancellable? = AnyCancellable {
            e.fulfill()
        }
        XCTAssertNotNil(cancellable)
        cancellable = nil
        waitForExpectations(timeout: 1)
    }

    
    func testGivenCancelCalledThenCallsCancelClosure() {
        let e = expectation(description: "cancel called on deinit")
        let cancellable: TinyPublisher.AnyCancellable? = AnyCancellable {
            e.fulfill()
        }
        XCTAssertNotNil(cancellable)
        cancellable?.cancel()
        waitForExpectations(timeout: 1)
    }
    
    @available(iOS 13.0, *)
    func testCombineGivenCancelCalledThenCallsCancelClosure() {
        let e = expectation(description: "cancel called on deinit")
        let cancellable: Combine.AnyCancellable? = AnyCancellable {
            e.fulfill()
        }
        XCTAssertNotNil(cancellable)
        cancellable?.cancel()
        waitForExpectations(timeout: 1)
    }

    
    var deinitCancelClosure: XCTestExpectation? = nil

    func testGivenCancelCalledTwiceThenCallsCancelClosureOnlyOnce() {
        deinitCancelClosure = expectation(description: "expect cancel to be called on deinit")
        
        let cancellable: TinyPublisher.AnyCancellable = AnyCancellable {
            self.deinitCancelClosure?.fulfill()
        }
        
        cancellable.cancel()
        waitForExpectations(timeout: 1)
        
        deinitCancelClosure = expectation(description: "expect cancel to NOT be called on deinit")
        deinitCancelClosure?.isInverted = true
        
        cancellable.cancel()
        waitForExpectations(timeout: 1)
    }
    
    @available(iOS 13.0, *)
    func testCombineGivenCancelCalledTwiceThenCallsCancelClosureOnlyOnce() {
        deinitCancelClosure = expectation(description: "expect cancel to be called on deinit")
        
        let cancellable: Combine.AnyCancellable = AnyCancellable {
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
        ("testGivenDeinitCalledThenCallsCancelClosure", testGivenDeinitCalledThenCallsCancelClosure),
        ("testGivenCancelCalledThenCallsCancelClosure", testGivenCancelCalledThenCallsCancelClosure),
        ("testGivenCancelCalledTwiceThenCallsCancelClosureOnlyOnce", testGivenCancelCalledTwiceThenCallsCancelClosureOnlyOnce)
    ]
}
