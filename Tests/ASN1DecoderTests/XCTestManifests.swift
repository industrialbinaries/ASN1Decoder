import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ASN1DecoderTests.allTests),
    ]
}
#endif
