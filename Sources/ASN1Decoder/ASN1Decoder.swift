//
//  ASN1Decoder
//
//  Copyright (c) 2020 Industrial Binaries
//  MIT license, see LICENSE file for details
//

import Foundation
import OpenSSL

enum ASN1Error: Error {
  case invalidSequenceType
  case missingOctet
  case missingLength
  case invalidType
}

/// Decoder for ASN1 data
public final class ASN1Decoder {
  public var pointer: UnsafePointer<UInt8>!

  /// Create new instance with ASN1
  /// - Parameter pointer: Pointer on data where should start read
  public init(pointer: UnsafePointer<UInt8>?) {
    self.pointer = pointer
  }

  /// Read `ASN1Object`
  /// - Parameters:
  ///   - pointer: Pointer the start of the object.
  ///   - objectLength: Lenght of object
  public func readObject(_ pointer: inout UnsafePointer<UInt8>?, with objectLength: Int) -> ASN1Object {
    var type = Int32(0)
    var xclass = Int32(0)
    var length = 0

    ASN1_get_object(
      &pointer,
      &length,
      &type,
      &xclass,
      objectLength
    )

    return ASN1Object(
      type: type,
      xclass: xclass,
      length: length
    )
  }

  /// Read number `Int`
  /// - Parameters:
  ///   - pointer: Pointer the start of the object.
  ///   - length: Length of object
  public func readInt(_ pointer: inout UnsafePointer<UInt8>?, with length: Int) -> Int? {
    let integer = d2i_ASN1_INTEGER(
      nil,
      &pointer,
      length
    )
    let result = ASN1_INTEGER_get(integer)
    ASN1_INTEGER_free(integer)
    return result
  }

  /// Read `String` with `UTF8` or `IA5` type
  /// - Parameters:
  ///   - pointer: Pointer the start of the object.
  ///   - objectLength: Length of object
  public func readString(_ pointer: inout UnsafePointer<UInt8>?, with objectLength: Int) -> String? {
    let object = readObject(&pointer, with: objectLength)

    switch object.type {
    case V_ASN1_UTF8STRING:
      let stringPointer = UnsafeMutableRawPointer(mutating: pointer)
      return String(
        bytesNoCopy: stringPointer!,
        length: object.length,
        encoding: String.Encoding.utf8,
        freeWhenDone: false
      )
    case V_ASN1_IA5STRING:
      let stringPointer = UnsafeMutableRawPointer(mutating: pointer)
      return String(
        bytesNoCopy: stringPointer!,
        length: object.length,
        encoding: String.Encoding.ascii,
        freeWhenDone: false
      )
    default:
      return nil
    }
  }

  /// Read raw `Data`
  /// - Parameters:
  ///   - pointer: Pointer the start of the object.
  ///   - objectLength: Length of object
  public func readData(_ pointer: inout UnsafePointer<UInt8>?, with count: Int) -> Data {
    return Data(bytes: &pointer, count: count)
  }

  /// Read `Date` in US POSIX format `yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'`
  /// - Parameters:
  ///   - pointer: Pointer the start of the object.
  ///   - objectLength: Length of object
  public func readDate(_ pointer: inout UnsafePointer<UInt8>?, length: Int, formatter: DateFormatter = .posix) -> Date? {
    guard let dateInString = readString(&pointer, with: length) else {
      return nil
    }
    return formatter.date(from: dateInString)
  }

  /// Read `ASN1Sequence` where validate sequence `type` and required parameters - `length` `octet` and value `type`
  /// Can be use for example in Apple Receipt https://developer.apple.com/library/archive/releasenotes/General/ValidateAppStoreReceipt/Chapters/ValidateLocally.html
  /// - Parameter endOfSequence: End of current sequence
  public func readSequence(with endOfSequence: UnsafePointer<UInt8>) throws -> ASN1Sequence {
    // Get next ASN1 Sequence
    let length = pointer!.distance(to: endOfSequence)
    let sequence = readObject(&pointer, with: length)
    guard sequence.type == V_ASN1_SEQUENCE else {
      throw ASN1Error.invalidType
    }

    // Read `Type`
    var nexLength = pointer!.distance(to: endOfSequence)
    guard let type = readInt(&pointer, with: nexLength) else {
      throw ASN1Error.invalidSequenceType
    }

    // Read `Version`
    nexLength = pointer!.distance(to: endOfSequence)
    guard let version = readInt(&pointer, with: nexLength) else {
      throw ASN1Error.missingLength
    }

    // Read octet string
    let octet = readObject(&pointer, with: length)
    guard octet.type == V_ASN1_OCTET_STRING else {
      throw ASN1Error.missingOctet
    }

    return ASN1Sequence(
      length: octet.length,
      version: version,
      type: type
    )
  }

  /// Move current pointer with length
  /// - Parameter length: Length where should move pointer from current location
  public func updateLocation(_ length: Int) {
    pointer = pointer?.advanced(by: length)
  }
}

public extension DateFormatter {
  static var posix: DateFormatter {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter
  }
}
