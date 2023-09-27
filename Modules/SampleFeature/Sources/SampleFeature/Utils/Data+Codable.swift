//
//  Data+Codable.swift
//  Sample Feature
//

import Foundation

// TODO: Move to a general utils package

extension Data {

    func decoded<T: Decodable>(into type: T.Type, decoder: JSONDecoder = JSONDecoder()) -> T? {
        try? decoder.decode(type, from: self)
    }
}

extension Encodable {

    func encoded(encoder: JSONEncoder = JSONEncoder()) -> Data? {
        try? encoder.encode(self)
    }
}
