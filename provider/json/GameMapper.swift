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

public class GameMapper: IDataMapper<[ModelGame]>, IGameMapper {
    private let encoder:IDataEncoder<[JSON]>
    
    public init(encoder:IDataEncoder<[JSON]>) {
        self.encoder = encoder
        super.init()
    }
    
    public override func map(data: Data) throws -> [ModelGame] {
        let json = try JSON(data: data)
        var ret = [ModelGame]()
        for element in json.arrayValue {
            ret.append(serialize(json: element))
        }
        return ret
    }
    
    public override func map(data: [ModelGame]) throws -> Data {
        var json = [JSON]()
        for game in data {
            var gameJson = JSON()
            gameJson["id"].int32 = game.id
            gameJson["name"].string = game.name
            gameJson["charIds"].arrayObject = game.charIds
            gameJson["iconUrl"].string = game.iconUrl
            json.append(gameJson)
        }
        return try encoder.encode(json)
    }
    
    private func serialize(json:JSON) -> ModelGame{
        var characterIds = [KotlinInt]()
        for charIdElement in json["charIds"].arrayValue {
            characterIds.append(KotlinInt(int: charIdElement.int32Value))
        }
        return ModelGame(id: json["id"].int32Value, name: json["name"].stringValue, characterIds: characterIds, iconUrl: json["iconUrl"].stringValue)
    }
}
