import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(TinyPublishedTests.allTests),
        testCase(AnyCancellableTests.allTests),
        testCase(PassthroughSubjectTests.allTests)
    ]
}
#endif
