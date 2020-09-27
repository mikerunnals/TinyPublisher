import XCTest

#if RUN_UNIT_TESTS_AGAINST_COMBINE
import Combine
#else
@testable import TinyPublisher
#endif

/// see https://developer.apple.com/documentation/combine/publisher/erasetoanypublisher()
final class AnyPublisherTests: XCTestCase {

    @available(iOS 13.0.0, *)
    func testAnyPublisherCannotBeDowncast() {
        
        class TypeWithSubject {
            public let publisher: some Publisher = PassthroughSubject<Int,Never>()
        }

        class TypeWithErasedSubject {
            public let publisher: some Publisher = PassthroughSubject<Int,Never>()
                .eraseToAnyPublisher()
        }

        let nonErased = TypeWithSubject()
        if let subject = nonErased.publisher as? PassthroughSubject<Int,Never> {
            print("Successfully cast nonErased.publisher. \(subject)")
        } else {
            XCTFail()
        }
        
        let erased = TypeWithErasedSubject()
        if let subject = erased.publisher as? PassthroughSubject<Int,Never> {
            print("Successfully cast erased.publisher. \(subject)")
            XCTFail()
        }
    }
}
