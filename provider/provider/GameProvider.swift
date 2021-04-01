//
//  GameProvider.swift
//  provider
//
//  Created by Mitchell Drew on 26/2/21.
//

import Foundation
import presenter
/*

open class GameProvider: Provider<[ModelGame]>, IGameProvider {
    private var listeners = [IGameProviderListener]()
    private var games = [ModelGame]()
    private var lastGet:Int64 = 0
    private var requests = [[KotlinInt]]()
    private var isDiskPulled = false
    
    private let JSON_FILENAME = "games.json"
    private let PULL_TIMER_MILLIS = 100000
    private let PULL_TIMER_KEY = "pulltimer"
    
    public init(restManager:IRestManager, fileManager:IFileManager, mapper:DataMapper<[ModelGame]>, userDefaults:IUserDefaults, gamesUrl:URL, encoder:IEncoder){
        super.init(restManager: restManager, fileManager: fileManager, userDefaults: userDefaults, encoder: encoder, url: gamesUrl, mapper: mapper)
    }
    
    public func get(ids: [KotlinInt]) {
        if(!isDiskPulled){
            pullFromDisk(ids: ids)
        }
        else{
            if(isSatisfiable(request: ids)){ informListeners(ids: ids, games: retrieve(ids: ids)) }
            else{
                requests.append(ids)
                restManager.dataTask(with: createRequest(ids: ids), completionHandler: getRestClosure(ids: ids)).resume()
            }
        }
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
        return ret
    }
    
    private func addGames(newGames:[ModelGame]){
        for game in newGames {
            games.removeAll(where: {existingGame in return game.id == existingGame.id})
            games.append(game)
        }
    }
    
    private func pullFromDisk(ids: [KotlinInt]){
        isDiskPulled = true
        requests.append(ids)
        if let json = fileManager.contents(atPath: fileManager.currentDirectoryPath + JSON_FILENAME) {
            do{
                games = try mapper.map(data: json)
            }
            catch {
                informListenersError(ids: ids, error: KotlinException(message: "serialization error"))
            }
        }
        restManager.dataTask(with: createRequest(ids: ids), completionHandler: getRestClosure(ids: ids)).resume()
    }
    
    private func satisfyRequests(){
        for request in requests {
            if(isSatisfiable(request: request)){
                informListeners(ids: request, games: retrieve(ids: request))
                requests.removeAll(where: {comparison in return comparison == request})
            }
        }
    }
    
    private func isSatisfiable(request: [KotlinInt]) -> Bool {
        for id in request {
            if(!games.contains(where: {game in return game.id == id.int32Value})){ return false }
        }
        return true
    }
    
    private func retrieve(ids: [KotlinInt]) -> [ModelGame] {
        var ret = [ModelGame]()
        for id in ids {
            ret.append(games.first(where: {game in return game.id == id.int32Value})!)
        }
        return ret
    }
    
    public func removeListener(gameListener: IGameProviderListener) {
        listeners.removeAll(where: {listener in return listener === gameListener})
    }
    
    public func addListener(gameListener: IGameProviderListener) {
        listeners.append(gameListener)
    }
    
    private func informListenersError(ids:[KotlinInt], error:KotlinException){
        for listener in listeners {
            listener.onError(ids: ids, error: error)
        }
    }
    
    private func informListeners(ids: [KotlinInt], games: [ModelGame]){
        for listener in listeners { listener.onReceive(ids: ids, games: games) }
    }
}
*/
