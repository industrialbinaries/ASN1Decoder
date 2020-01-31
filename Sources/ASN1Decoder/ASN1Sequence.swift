//
//  ASN1Decoder
//
//  Copyright (c) 2020 Industrial Binaries
//  MIT license, see LICENSE file for details
//

import Foundation

/// ASN1 Sequence
public struct ASN1Sequence {
  public let length: Int
  public let version: Int
  public let type: Int
}
