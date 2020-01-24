//
//  ASN1Decoder
//
//  Copyright (c) 2020 Industrial Binaries
//  MIT license, see LICENSE file for details
//

import Foundation

extension Data {
  static var receiptASN1: Data? {
    guard
      let url = Bundle.main.appStoreReceiptURL,
      let data = try? Data(contentsOf: url) else {
      return nil
    }
    return data
  }
}
