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
    private var lastGet:Int64 = 0
    private let serializer:GameSeralizer
    private let restManager:IRestManager
    private let fileManager:IFileManager
    private let JSON_FILENAME = "games.json"
    private let PULL_TIMER_MILLIS = 100000
    private let gamesUrl:URL
    
    init(restManager:IRestManager, fileManager:IFileManager, serializer:GameSeralizer, gamesUrl:URL){
        self.restManager = restManager
        self.fileManager = fileManager
        self.gamesUrl = gamesUrl
        self.serializer = serializer
    }
    
    private func getRestClosure(completionBlock: @escaping CompletionBlock) -> RestClosure {
        return { [self] data,response,error in
            if let uResponse = response as? HTTPURLResponse {
                if(uResponse.statusCode != 200) { informListenersError(id: 0, error: KotlinException(message: "bad status: \(uResponse)")) }
                if let uData = data {
                    games = serializer.map(data: uData)
                    informListeners(games: games)
                    saveToDisk(data: uData)
                    completionBlock()
                }
            }
            else{informListenersUnexpectedError()}
        }
    }
    
    private func saveToDisk(data:Data){
        if let url = URL(string: fileManager.currentDirectoryPath + JSON_FILENAME) {
            do { try data.write(to: url) }
            catch {
                informListenersError(id: 0, error: KotlinException(message: "failed to write"))
            }
        }
    }
    
    private func informListenersUnexpectedError(){
        for listener in listeners {
            listener.onError(id: 0, error: KotlinException(message: "unexpected error"))
        }
    }
    
    private func informListenersError(id:Int32, error:KotlinException){
        for listener in listeners {
            listener.onError(id: id, error: error)
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
    
    private func getFromDisk(completionBlock: @escaping ([ModelGame])->Void){
        DispatchQueue.global().async { [self] in
            if(fileManager.fileExists(atPath: fileManager.currentDirectoryPath + JSON_FILENAME)){
                if let uData = fileManager.contents(atPath: fileManager.currentDirectoryPath + JSON_FILENAME){
                    games = serializer.map(data: uData)
                    completionBlock(games)
                }
            }
        }
    }
    
    public func get() {
        let date = Date().currentTimeMillis()
        getFromDisk{games in self.informListeners(games: games)}
        if(lastGet == 0 || date - lastGet > PULL_TIMER_MILLIS){
            lastGet = date
            restManager.dataTask(with: URLRequest(url: gamesUrl), completionHandler: getRestClosure{}).resume()
        }
    }
    
    private func inform(id:Int32, games:[ModelGame]){
            let game = games.filter {game in game.id == id}
            if(game.count == 1){ informListeners(id: id, game: game[0]) }
            if(game.count > 1){informListenersError(id: id, error: KotlinException(message: "collision"))}
    }
    
    public func get(id: Int32) {
        if(games.count == 0){
            getFromDisk{games in self.inform(id: id, games: games) }
            restManager.dataTask(with: URLRequest(url: gamesUrl), completionHandler: getRestClosure { self.get(id: id) }).resume() }
        if(games.contains{game in return game.id == id}){
            inform(id: id, games: games)
        }
    }
    
    public func removeListener(gameListener: IGameProviderListener) {
        listeners.removeAll(where: {listener in return listener === gameListener})
    }
    
    public func addListener(gameListener: IGameProviderListener) {
        listeners.append(gameListener)
    }
}
