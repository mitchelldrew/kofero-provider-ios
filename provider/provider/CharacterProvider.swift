//
//  CharacterProvider.swift
//  provider
//
//  Created by Mitchell Drew on 10/3/21.
//

import Foundation
import presenter

/*
open class CharacterProvider: Provider, ICharacterProvider {
    private var listeners = [ICharacterProviderListener]()
    private var characters = [ModelCharacter]()
    private let mapper:ICharacterMapper
    private var requests = [[KotlinInt]]()
    private var isDiskPulled = false
    private let JSON_FILENAME = "chars.json"
    
    public init(restManager:IRestManager, fileManager:IFileManager, mapper:ICharacterMapper, userDefaults:IUserDefaults, charUrl:URL, encoder:IEncoder){
        self.mapper = mapper
        
    }
    
    public func get(ids: [KotlinInt]) {
            if(!isDiskPulled){
                pullFromDisk(ids: ids)
            }
            else{
                if(isSatisfiable(request: ids)){ informListeners(ids: ids, chars: retrieve(ids: ids)) }
                else{
                    requests.append(ids)
                    restManager.dataTask(with: createRequest(ids: ids), completionHandler: getRestClosure(ids: ids)).resume()
                }
            }
    }
    
    private func pullFromDisk(ids: [KotlinInt]){
        isDiskPulled = true
        requests.append(ids)
        if let json = fileManager.contents(atPath: fileManager.currentDirectoryPath + JSON_FILENAME) {
            do{
                characters = try mapper.map(data: json)
            }
            catch {
                informListenersError(ids: ids, error: KotlinException(message: "serialization error"))
            }
        }
        restManager.dataTask(with: createRequest(ids: ids), completionHandler: getRestClosure(ids: ids)).resume()
    }
    
    private func add(new:[ModelCharacter]){
        for char in new {
            characters.removeAll(where: {existingChar in return char.id == existingChar.id})
            characters.append(char)
        }
    }
    
    private func getRestClosure(ids: [KotlinInt]) -> RestClosure {
        return {[self] data, response, error in
            if(isResponseGood(data:data, response:response, error:error)){
                do{ add(new: try mapper.map(data: data!)) }
                catch { informListenersError(ids: ids, error: KotlinException(message: error.localizedDescription)) }
            }
            else{
                informListenersError(ids: ids, error: KotlinException(message: "error:\(error.debugDescription), response: \(response.debugDescription)"))
            }
        }
    }
    
    private func isResponseGood(data:Data?, response:URLResponse?, error:Error?) -> Bool {
        return data != nil && (response as! HTTPURLResponse).statusCode == 200 && error == nil
    }
    
    private func createRequest(ids: [KotlinInt]) -> URLRequest {
        var ret = URLRequest(url: url)
        var ids32 = [Int32]()
        for id in ids{ ids32.append(id.int32Value) }
        do{
            try ret.httpBody = encoder.encode(ids32)
        }
        catch {
            informListenersError(ids: ids, error: KotlinException(message: "request body encoding failed"))
        }
    }
    
    private func retrieve(ids: [KotlinInt]) -> [ModelCharacter] {
        var ret = [ModelCharacter]()
        for id in ids {
            ret.append(characters.first(where: {char in return char.id == id.int32Value})!)
        }
        return ret
    }
    
    private func informListeners(ids: [KotlinInt], chars: [ModelCharacter]){
        for listener in listeners {
            listener.onReceive(ids: ids, chars: chars)
        }
    }
    
    private func informListenersError(ids: [KotlinInt], error: KotlinException){
        for listener in listeners {
            listener.onError(ids: ids, error: error)
        }
    }
    
    private func isSatisfiable(request: [KotlinInt]) -> Bool {
        for id in request {
            if(!characters.contains(where: {char in return char.id == id.int32Value})){ return false }
        }
        return true
    }
    
    public func removeListener(charListener: ICharacterProviderListener) {
        listeners.removeAll{listener in return listener === charListener}
    }
    
    public func addListener(charListener: ICharacterProviderListener) {
        listeners.append(charListener)
    }
    
}
*/
