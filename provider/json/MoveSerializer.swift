//
//  MoveSerializer.swift
//  provider
//
//  Created by Mitchell Drew on 12/3/21.
//

import Foundation
import SwiftyJSON
import presenter

public class MoveSerializer:DataSerializer<[ModelMove]>{
    public override init() {}
    
    override func map(data: Data) throws -> [ModelMove] {
        var ret = [ModelMove]()
        return ret
    }
}
