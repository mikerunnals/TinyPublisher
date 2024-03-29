import XCTest

#if RUN_UNIT_TESTS_AGAINST_COMBINE
import Combine
#else
@testable import TinyPublisher
#endif

final class CatchTests: XCTestCase {
    
    @available(iOS 13.0.0, *)
    func testCatchCanMapErrorToJust() {
        struct SimpleError: Error {}
        let numbers = [5, 4, 3, 2, 1, 0, 9, 8, 7, 6]
        var result: Int? = nil
        _ = numbers.publisher
            .tryLast(where: {
                guard $0 != 0 else {
                    throw SimpleError()
                }
                return true
            })
            .catch({ (error) in
                Just(-1)
            })
            .sink {
                result = $0
            }

        XCTAssertEqual(-1, result)
    }
}
