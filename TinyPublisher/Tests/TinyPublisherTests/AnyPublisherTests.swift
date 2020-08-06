import XCTest
@testable import TinyPublisher
import Combine

/// see https://developer.apple.com/documentation/combine/publisher/erasetoanypublisher()


final class AnyPublisherTests: XCTestCase {

    @available(iOS 13.0, *)
    func testCombineAnyPublisherCannotBeDowncast() {
        
        class TypeWithSubject {
            public let publisher: some Combine.Publisher = Combine.PassthroughSubject<Int,Never>()
        }

        class TypeWithErasedSubject {
            public let publisher: some Combine.Publisher = Combine.PassthroughSubject<Int,Never>()
                .eraseToAnyPublisher()
        }

        let nonErased = TypeWithSubject()
        if let subject = nonErased.publisher as? Combine.PassthroughSubject<Int,Never> {
            print("Successfully cast nonErased.publisher. \(subject)")
        } else {
            XCTFail()
        }
        
        let erased = TypeWithErasedSubject()
        if let subject = erased.publisher as? Combine.PassthroughSubject<Int,Never> {
            print("Successfully cast erased.publisher. \(subject)")
            XCTFail()
        }
    }
}
