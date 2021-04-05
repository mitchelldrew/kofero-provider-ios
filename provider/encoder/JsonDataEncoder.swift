//
//  JsonDataEncoder.swift
//  provider
//
//  Created by Mitchell Drew on 5/4/21.
//

import Foundation


open class JsonDataEncoder<I:Encodable>: IDataEncoder<I> {
    private let encoder = JSONEncoder()
    
    public override init(){}
    
    public override func encode(_ value: I) throws -> Data {
        return try encoder.encode(value)
    }
}
