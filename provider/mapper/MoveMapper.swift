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
            moveJson["attributes"].dictionaryObject = move.attributes
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
        return ModelMove(uid: json["uid"].int32Value, name: json["name"].stringValue, attributes: transformDict(dict: json["attributes"].dictionaryValue))
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
