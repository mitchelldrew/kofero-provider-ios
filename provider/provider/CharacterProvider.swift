//
//  CharacterProvider.swift
//  provider
//
//  Created by Mitchell Drew on 10/3/21.
//

import Foundation
import presenter

open class CharacterProvider: ICharacterProvider {
    private var listeners = [ICharacterProviderListener]()
    private var characters = [ModelCharacter]()
    private let restManager:IRestManager
    private let fileManager:IFileManager
    private let serializer:CharacterSerializer
    private let url:URL
    
    public init(restManager:IRestManager, fileManager:IFileManager, serializer:CharacterSerializer, charUrl:URL){
        self.restManager = restManager
        self.fileManager = fileManager
        self.serializer = serializer
        self.url = charUrl
    }
    
    public func get(id: Int32) {
        
        restManager.dataTask(with: URLRequest(url: url), completionHandler: getRestClosure{}).resume()
        /**
         
             let date = Date().currentTimeMillis()
             getFromDisk{games in self.informListeners(games: games)}
             if(isDatePastPullTimer(date:date)){
                 lastGet = date
                 restManager.dataTask(with: URLRequest(url: gamesUrl), completionHandler: getRestClosure{}).resume()
             }
         */
    }
    
    private func getRestClosure(completionBlock: @escaping CompletionBlock) -> RestClosure {
        return { [self] data,response,error in
            if let uResponse = response as? HTTPURLResponse {
                if(uResponse.statusCode != 200) { informListenersError(id: 0, error: KotlinException(message: "bad status: \(uResponse)")) }
                if let uData = data {
                    do { games = try serializer.map(data: uData)
                        informListeners(games: games)
                        saveToDisk(data: uData)
                        completionBlock()
                    }
                    catch {
                        informListenersError(id: 0, error: KotlinException(message: error.localizedDescription))
                    }
                }
            }
            else{informListenersUnexpectedError()}
        }
    }
    
    private func informListeners(chars: [ModelCharacter]){
        for listener in listeners {
            listener.onReceive(id: <#T##Int32#>, char: <#T##ModelCharacter#>)
        }
    }
    
    public func removeListener(charListener: ICharacterProviderListener) {
        listeners.removeAll{listener in return listener === charListener}
    }
    
    public func addListener(charListener: ICharacterProviderListener) {
        listeners.append(charListener)
    }
    
}
