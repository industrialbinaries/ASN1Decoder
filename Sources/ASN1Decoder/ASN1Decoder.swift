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

final public class ASN1Decoder {
  public var pointer: UnsafePointer<UInt8>!

  public init(pointer: UnsafePointer<UInt8>?) {
    self.pointer = pointer
  }

  public func readNextObject(_ pointer: inout UnsafePointer<UInt8>?, with objectLength: Int) -> ASN1Object {
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

  public func readInteger(_ pointer: inout UnsafePointer<UInt8>?, with objectLength: Int) -> Int? {
    let integer = d2i_ASN1_INTEGER(
      nil,
      &pointer,
      objectLength
    )
    let result = ASN1_INTEGER_get(integer)
    ASN1_INTEGER_free(integer)
    return result
  }

  public func readString(_ pointer: inout UnsafePointer<UInt8>?, with objectLength: Int) -> String? {
    let object = readNextObject(&pointer, with: objectLength)

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

  public func readData(_ pointer: inout UnsafePointer<UInt8>?, with length: Int) -> NSData {
    return NSData(bytes: &pointer, length: length)
  }

  public func readDate(_ pointer: inout UnsafePointer<UInt8>?, length: Int) -> Date? {
    guard let dateInString = readString(&pointer, with: length) else {
      return nil
    }

    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
    formatter.timeZone = TimeZone(secondsFromGMT: 0)

    return formatter.date(from: dateInString)
  }

  public func readSequence(with endOfSequence: UnsafePointer<UInt8>) throws -> ASN1Sequence {
    // Get next ASN1 Sequence
    let length = pointer!.distance(to: endOfSequence)
    let sequence = readNextObject(&pointer, with: length)
    guard sequence.type == V_ASN1_SEQUENCE else {
      throw ASN1Error.invalidType
    }

    // Read `Type`
    var nexLength = pointer!.distance(to: endOfSequence)
    guard let type = readInteger(&pointer, with: nexLength) else {
      throw ASN1Error.invalidSequenceType
    }

    // Read `Version`
    nexLength = pointer!.distance(to: endOfSequence)
    guard readInteger(&pointer, with: nexLength) != nil else {
      throw ASN1Error.missingLength
    }

    // Read octet string
    let octet = readNextObject(&pointer, with: length)
    guard octet.type == V_ASN1_OCTET_STRING else {
      throw ASN1Error.missingOctet
    }

    return ASN1Sequence(
      length: octet.length,
      type: type
    )
  }

  public func updateLocation(_ length: Int) {
    pointer = pointer?.advanced(by: length)
  }
}
