# ASN1Decoder
 
[![SPM Compatible](https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager)
![Platforms: macOS](https://img.shields.io/badge/platforms-macOS-brightgreen.svg?style=flat)
[![Twitter](https://img.shields.io/badge/twitter-@i_binaries-blue.svg?style=flat)](https://twitter.com/i_binaries)
 
Library for helping you with decoding ASN1 in your project. It can be easily use for parse local Receipt from Apple in PKCS7 like in [youda](https://github.com/industrialbinaries/youda) package.
 
## Instalation
`ASN1Decoder` is distributed via SPM. You can use it as a framework in your `macOS` or `iOS` project. 
In your `Package.swift` add a new package depedency: 
```swift
.package(
    url: "https://github.com/industrialbinaries/ASN1Decoder",
    from: "0.1.0"
)
```
 
## Usage
Create an instance from `ASN1Decoder` with `pointer` on your own data
Then you can use your decoder to read base values from `ASN1`

Note: Some method moves with the pointer when read value, for this case you should use a copy of your pointer 
 
### Integer
```swift
let integerValue = decoder.readInteger(&pointer, with: length)
```

### String
ASN1Decoder support `UTF8` and `IA5` string types
```swift
let stringValue = decoder.readString(&pointer, with: length)
```

### Date
Read string and parse to `Date` with format `yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'`
```swift
let date = readDate(&pointer, length: length)
```

### Data
Read raw data
```swift
let data = readData(&pointer, length: length)
```

### ASN1Object
```swift
let asn1Object = readObject(&pointer, length: length)
```

### ASN1Sequence
```swift
let asn1Sequence = readSequence(with: endOfSequence)
```
 
## License and Credits
 
**ASN1Decoder** is released under the MIT license. See [LICENSE](/LICENSE) for details.
 
Created by [Jan Timar](https://github.com/jantimar) @ [Industrial Binaries](https://industrial-binaries.co).
