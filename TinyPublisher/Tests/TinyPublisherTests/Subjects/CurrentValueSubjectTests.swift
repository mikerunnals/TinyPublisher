import XCTest

#if RUN_UNIT_TESTS_AGAINST_COMBINE
import Combine
#else
@testable import TinyPublisher
#endif

final class CurrentValueSubjectTests: XCTestCase {
    
    @available(iOS 13.0, *)
    func testCurrentValueSubjectBool() {
        var cancellables: [AnyCancellable] = []
        
        let subject = CurrentValueSubject<Bool, Never>(false)
        let publisher = subject.eraseToAnyPublisher()

        let es: [(value: Bool, expectation: XCTestExpectation)] =
            [(value: false, expectation: expectation(description: "Expect false initial sink event")),
             (value: true, expectation: expectation(description: "Expect true sink event from send"))]
        var things = es.enumerated().makeIterator()
        
        publisher.sink { value in
            guard let (_, thing) = things.next() else { XCTFail(); return }

            XCTAssertEqual(thing.value, value)
            thing.expectation.fulfill()
        }.store(in: &cancellables)

        subject.send(true)

        waitForExpectations(timeout: 1)
    }

    static var allTests = [
        ("testCurrentValueSubjectBool", testCurrentValueSubjectBool),
    ]
}
