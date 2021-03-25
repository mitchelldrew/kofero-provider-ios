//
//  GameSerializer.swift
//  provider
//
//  Created by Mitchell Drew on 27/2/21.
//

import Foundation
import presenter
import SwiftyJSON

public protocol IGameMapper {
    func map(data:Data) throws -> [ModelGame]
    func map(data:[ModelGame]) throws -> Data
}

public class GameMapper: DataMapper<[ModelGame]>, IGameMapper {
    public override init() {}
    
    public override func map(data: Data) throws -> [ModelGame] {
        let json = try JSON(data: data)
        var ret = [ModelGame]()
        for element in json.arrayValue {
            ret.append(serialize(json: element))
        }
        return ret
    }
    
    public override func map(data: [ModelGame]) throws -> Data {
        
    }
    
    private func serialize(json:JSON) -> ModelGame{
        var characterIds = [KotlinInt]()
        for charIdElement in json["charIds"].arrayValue {
            characterIds.append(KotlinInt(int: charIdElement.int32Value))
        }
        return ModelGame(id: json["id"].int32Value, name: json["name"].stringValue, characterIds: characterIds, iconUrl: json["iconUrl"].stringValue)
    }
}
