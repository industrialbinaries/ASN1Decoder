//
//  ASN1Decoder
//
//  Copyright (c) 2020 Industrial Binaries
//  MIT license, see LICENSE file for details
//

import Foundation

public struct ASN1Object {
  let type: Int32
  let xclass: Int32
  let length: Int
}
