//
//  GameProvider.swift
//  provider
//
//  Created by Mitchell Drew on 26/2/21.
//

import Foundation
import presenter

open class GameProvider: IGameProvider {
    private var listeners = [IGameProviderListener]()
    private var games = [ModelGame]()
    private let serializer:GameSeralizer
    private let urlSession:URLSession
    private let fileManager:FileManager
    private let gamesUrl:URL
    
    init(urlSession:URLSession, fileManager:FileManager, serializer:GameSeralizer, gamesUrl:URL){
        self.urlSession = urlSession
        self.fileManager = fileManager
        self.gamesUrl = gamesUrl
        self.serializer = serializer
    }
    
    private func getRestClosure() -> RestClosure {
        return { [self] data,response,error in
            if let uResponse = response as? HTTPURLResponse {
                if(uResponse.statusCode != 200) { informListenersError(id: 0)}
                if let uData = data {
                    let newGames = serializer.map(data: uData)
                    informListeners(games: newGames)
                    saveToDisk()
                }
            }
            else{informListenersUnexpectedError()}
        }
    }
    
    private func saveToDisk(){
        
    }
    
    private func informListenersUnexpectedError(){
        for listener in listeners {
            listener.onError(id: 0, error: KotlinException(message: "unexpected error"))
        }
    }
    
    private func informListenersError(id:Int32){
        for listener in listeners {
            listener.onError(id: id, error: KotlinException())
        }
    }
    
    
    private func informListeners(id:Int32, game:ModelGame){
        for listener in listeners {
            listener.onReceive(id: id, game: game)
        }
    }
    
    private func informListeners(games:[ModelGame]){
        for listener in listeners {
            listener.onReceive(games: games)
        }
    }
    
    private func getFromDisk(){
        
    }
    
    private func getFromDisk(id:Int32){
        
    }
    
    public func get() {
        getFromDisk()
        urlSession.dataTask(with: gamesUrl, completionHandler: getRestClosure())
    }
    
    public func get(id: Int32) {
        if(games.contains{game in return game.id == id}){
            let game = games.filter {game in game.id == id}
            if(game.count == 1){ informListeners(id: id, game: game[0]) }
            
        }
    }
    
    public func removeListener(gameListener: IGameProviderListener) {
        listeners.removeAll(where: {listener in return listener === gameListener})
    }
    
    public func addListener(gameListener: IGameProviderListener) {
        listeners.append(gameListener)
    }
}
