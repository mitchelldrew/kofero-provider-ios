//
//  JsonEncoder.swift
//  provider
//
//  Created by Mitchell Drew on 1/4/21.
//

import Foundation

open class DataEncoder<I:Encodable>: IEncoder {
    public typealias O = Data
    let encoder = JSONEncoder()
    
    public func encode(_ value: I) throws -> Data {
        return try encoder.encode(value)
    }
}
