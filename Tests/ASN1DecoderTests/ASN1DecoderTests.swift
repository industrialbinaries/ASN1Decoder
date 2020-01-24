//
//  ASN1Decoder
//
//  Copyright (c) 2020 Industrial Binaries
//  MIT license, see LICENSE file for details
//

@testable import ASN1Decoder
import XCTest

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
