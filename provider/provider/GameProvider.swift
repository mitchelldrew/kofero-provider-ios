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
    private let serializer:GameSerializer
    private let restManager:IRestManager
    private let fileManager:IFileManager
    private let gamesUrl:URL
    private var requests = [[KotlinInt]]()
    private var isDiskPulled = false
    private let userDefaults: IUserDefaults
    
    private let JSON_FILENAME = "games.json"
    private let PULL_TIMER_MILLIS = 100000
    private let PULL_TIMER_KEY = "pulltimer"
    
    public init(restManager:IRestManager, fileManager:IFileManager, serializer:GameSerializer, userDefaults:IUserDefaults, gamesUrl:URL){
        self.restManager = restManager
        self.fileManager = fileManager
        self.gamesUrl = gamesUrl
        self.serializer = serializer
        self.userDefaults = userDefaults
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
    
    private func getRestClosure(ids: [KotlinInt]) -> RestClosure {
        return {[self] data, response, error in
            if(isResponseGood(data:data, response:response, error:error)){
                do{ addGames(newGames: try serializer.map(data: data!)) }
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
        var ret = URLRequest(url: gamesUrl)
        ret.httpBody = 
        
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
                games = try serializer.map(data: json)
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
