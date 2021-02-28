//
//  Serializer.swift
//  provider
//
//  Created by Mitchell Drew on 26/2/21.
//

import Foundation
import presenter

class DataSerializer<O>: IMapper {
    func map(data: Data) -> O {
        fatalError("Override me!")
    }
}


