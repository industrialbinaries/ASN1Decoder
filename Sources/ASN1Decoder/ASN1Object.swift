//
//  ASN1Decoder
//
//  Copyright (c) 2020 Industrial Binaries
//  MIT license, see LICENSE file for details
//

import Foundation

/// ASN1 Object with base structure `type` `xclass` and `length`
public struct ASN1Object {
  public let type: Int32
  public let xclass: Int32
  public let length: Int
}
