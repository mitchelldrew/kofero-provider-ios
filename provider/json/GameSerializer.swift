//
//  GameSerializer.swift
//  provider
//
//  Created by Mitchell Drew on 27/2/21.
//

import Foundation
import presenter
import SwiftyJSON

class GameSeralizer: DataSerializer<[ModelGame]> {
    override func map(data: Data) throws -> [ModelGame] {
        var ret = [ModelGame]()
        return ret
    }
}
