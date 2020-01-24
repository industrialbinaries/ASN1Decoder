//
//  ASN1Decoder
//
//  Copyright (c) 2020 Industrial Binaries
//  MIT license, see LICENSE file for details
//

import Foundation

enum ASPN1Type: Int {
	// MARK: - Reciept

  case bundleId = 2
  case bundleVersion = 3
  case opaque = 4
  case hash = 5
  case createDate = 12
  case shortVersion = 19
  case expirationDate = 21

	// MARK: - Purchase

  case purchase = 17
  case purchaseQuantity = 1701
  case purchaseProductIdentifier = 1702
  case purchaseTransactionIdentifier = 1703
  case purchaseOriginalTransactionIdentifier = 1705
  case purchaseDate = 1704
  case originalPurchaseDate = 1706
  case purchaseSubscriptionExpirationDate = 1708
  case purchaseSubscriptionIntroductoryPricePeriod = 1719
  case purchaseCancellationDate = 1712
  case purchaseWebOrderLineItemID = 1711
}
