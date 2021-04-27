//
//  CharacterSerializer.swift
//  provider
//
//  Created by Mitchell Drew on 10/3/21.
//

import Foundation
import presenter
import SwiftyJSON

public class CharacterMapper:IDataMapper<[ModelCharacter]>{
    private let encoder:IDataEncoder<[JSON]>
    
    public init(encoder:IDataEncoder<[JSON]>){
        self.encoder = encoder
    }
    
    public override func map(data: Data) throws -> [ModelCharacter] {
        let json = try JSON(data: data)
        var ret = [ModelCharacter]()
        for element in json.arrayValue {
            ret.append(serialize(json: element))
        }
        return ret
    }
    
    public override func map(data: [ModelCharacter]) throws -> Data {
        var json = [JSON]()
        for char in data {
            var charJson = JSON()
            charJson["id"].int32 = char.id
            charJson["name"].string = char.name
            charJson["moveIds"].arrayObject = char.mvIds
            charJson["attributes"].dictionaryObject = char.attributes
            charJson["iconUrl"].string = char.iconUrl
            json.append(charJson)
        }
        return try encoder.encode(json)
    }
    
    private func serialize(json: JSON) -> ModelCharacter {
        var moveIds = [KotlinInt]()
        
        for element in json["moveIds"].arrayValue {
            moveIds.append(KotlinInt(int: element.int32Value))
        }
        return ModelCharacter(id: json["id"].int32Value, name: json["name"].stringValue, attributes: transformDict(dict: json["attributes"].dictionaryValue), moveIds: moveIds, iconUrl: json["iconUrl"].stringValue)
    }
    
    private func transformDict(dict:[String:JSON]) -> [String:String] {
        var mDict = dict
        var ret = [String:String]()
        for key in dict.keys {
            if let value = mDict.removeValue(forKey: key) {
                ret.updateValue(value.stringValue, forKey: key)
            }
        }
        return ret
    }
}
