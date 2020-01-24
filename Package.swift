// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "ASN1Decoder",
  platforms: [
    .iOS(.v12),
  ],
  products: [
    .library(
      name: "ASN1Decoder",
      targets: ["ASN1Decoder"]
    ),
  ],
  dependencies: [
    .package(
      url: "https://github.com/industrialbinaries/OpenSSL",
      .branch("feature/asn1")
    ),
  ],
  targets: [
    .target(
      name: "ASN1Decoder",
      dependencies: ["OpenSSL"]
    ),
    .testTarget(
      name: "ASN1DecoderTests",
      dependencies: ["ASN1Decoder", "OpenSSL"]
    ),
  ]
)
