//
//  Data+Codable.swift
//  Storage
//

import Foundation

extension Data {

    public func decoded<T: Decodable>(into type: T.Type, decoder: JSONDecoder = JSONDecoder()) -> T? {
        try? decoder.decode(type, from: self)
    }
}

extension Encodable {

    public func encoded(encoder: JSONEncoder = JSONEncoder()) -> Data? {
        try? encoder.encode(self)
    }
}
