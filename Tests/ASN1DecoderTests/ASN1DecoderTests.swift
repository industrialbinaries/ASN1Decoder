import XCTest
@testable import ASN1Decoder

final class ASN1DecoderTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(ASN1Decoder().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
