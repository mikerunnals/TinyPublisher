import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(TinyPublisherTests.allTests),
        testCase(AnyCancellableTests.allTests),
    ]
}
#endif
