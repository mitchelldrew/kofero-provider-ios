//
//  CharacterSerializer.swift
//  provider
//
//  Created by Mitchell Drew on 10/3/21.
//

import Foundation
import presenter
import SwiftyJSON

public class CharacterSerializer:DataSerializer<[ModelCharacter]>{
    public override init(){}
    
    override func map(data: Data) throws -> [ModelCharacter] {
        let json = try JSON(data: data)
        var ret = [ModelCharacter]()
        for element in json.arrayValue {
            ret.append(serialize(json: element))
        }
        return ret
    }
    
    private func serialize(json: JSON) -> ModelCharacter {
        var moveIds = [KotlinInt]()
        for element in json["moveIds"].arrayValue {
            moveIds.append(KotlinInt(int: element.int32Value))
        }
        return ModelCharacter(id: json["id"].int32Value, name: json["name"].stringValue, health: json["health"].int32Value, moveIds: moveIds, iconUrl: json["iconUrl"].stringValue)
    }
}
