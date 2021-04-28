//
//  MoveSerializer.swift
//  provider
//
//  Created by Mitchell Drew on 12/3/21.
//

import Foundation
import presenter
import SwiftyJSON

public class MoveMapper:IDataMapper<[ModelMove]>{
    private let encoder:IDataEncoder<[JSON]>
    
    public init(encoder:IDataEncoder<[JSON]>) {
        self.encoder = encoder
    }
    
    public override func map(data: [ModelMove]) throws -> Data {
        var json = [JSON]()
        for move in data {
            var moveJson = JSON()
            moveJson["uid"].int32 = move.uid
            moveJson["name"].string = move.name
            moveJson["startup"].stringValue = move.startup
            moveJson["active"].stringValue = move.active
            moveJson["recovery"].stringValue = move.recovery
            moveJson["hitAdv"].stringValue = move.hitAdv
            moveJson["blockAdv"].stringValue = move.blockAdv
            moveJson["notes"].stringValue = move.notes
            json.append(moveJson)
        }
        return try encoder.encode(json)
    }
    
    public override func map(data: Data) throws -> [ModelMove] {
        let json = try JSON(data: data)
        var ret = [ModelMove]()
        for element in json.arrayValue {
            ret.append(serialize(json: element))
        }
        return ret
    }
    
    private func serialize(json: JSON) -> ModelMove {
        return ModelMove(uid: json["uid"].int32Value, name: json["name"].stringValue, startup: json["startup"].stringValue, active: json["active"].stringValue, recovery: json["recovery"].stringValue, hitAdv: json["hitAdv"].stringValue, blockAdv: json["blockAdv"].stringValue, notes: json["notes"].stringValue)
    }
}
