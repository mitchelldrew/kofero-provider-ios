//
//  Serializer.swift
//  provider
//
//  Created by Mitchell Drew on 26/2/21.
//

import Foundation
import presenter

open class IDataMapper<O>: IMapper {
    typealias I = Data
    
    public func map(data: Data) throws -> O { fatalError("Override me!") }
    
    public func map(data: O) throws -> Data { fatalError("Override me!") }
}


