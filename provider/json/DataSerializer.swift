//
//  Serializer.swift
//  provider
//
//  Created by Mitchell Drew on 26/2/21.
//

import Foundation
import presenter

open class DataMapper<O>: IMapper {
    func map(data: Data) throws -> O {
        fatalError("Override me!")
    }
}


