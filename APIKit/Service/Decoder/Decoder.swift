//
//  Decoder.swift
//  APIKit
//
//  Created by Bartosz Żmija on 10/02/2021.
//

import Foundation

/// Describes an entity capable of decoding data.
public protocol Decoder {
    /// Decodes the provided data.
    /// - Parameters:
    ///   - data: data to be decoded.
    func decode<DecodedType: Decodable>(data: Data) -> DecodedType?
}

// MARK: JSONDecoder conformance

extension JSONDecoder: Decoder {
    public func decode<DecodedType>(data: Data) -> DecodedType? where DecodedType : Decodable {
        try? decode(DecodedType.self, from: data)
    }
}
