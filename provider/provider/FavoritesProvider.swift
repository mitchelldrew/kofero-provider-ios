//
//  FavoritesProvider.swift
//  provider
//
//  Created by Mitchell Drew on 19/4/21.
//

import Foundation
import presenter

public class FavoritesProvider: IFavoritesProvider {
    private var listeners = [IProviderListener]()
    private let defaults:IUserDefaults
    private let CHAR_KEY = "char"
    private let GAME_KEY = "game"
    private let MOVE_KEY = "move"
    
    public init(defaults:IUserDefaults){
        self.defaults = defaults
    }
    
    public func addListener(listener: IProviderListener) {
        listeners.append(listener)
    }
    
    public func get(ids: [KotlinInt]) {
        
    }
    
    public func removeListener(listener: IProviderListener) {
        listeners.removeAll{existingListener in return listener === existingListener}
    }
    
    public func delete(item: ModelObj, type: IFavoritesProviderFavType) {
        
    }
    
    public func save(item: ModelObj, type: IFavoritesProviderFavType) {
        switch type {
        case .char_: save(item: item, key: CHAR_KEY)
        case .game: save(item: item, key: GAME_KEY)
        case .move: save(item: item, key: MOVE_KEY)
        default:
           informListenersError()
        }
    }
    
    private func informListenersError(){
        
    }
    
    private func save(item: ModelObj, key: String) {
        
    }
    
    
}
