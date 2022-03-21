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
    private let FAVS_KEY = "favs"
    
    public init(defaults:IUserDefaults){
        self.defaults = defaults
    }
    
    public func addListener(listener__ listener: IProviderListener) {
        listeners.append(listener)
    }
    
    public func removeListener(listener__ listener: IProviderListener) {
        listeners.removeAll{existingListener in return listener === existingListener}
    }
    
    
    public func get(ids: [KotlinInt]) {
        if let favs = defaults.object(forKey: FAVS_KEY) as? [ModelObj]{
            informListeners(favs: favs)
        }
    }
    
    public func delete(item: ModelObj) {
        let favs = defaults.object(forKey: FAVS_KEY)
        if var uFavs = favs as? [ModelObj] {
            uFavs.removeAll{obj in return obj.uid == item.uid}
            defaults.set(uFavs, forKey: FAVS_KEY)
        }
    }
    
    public func save(item: ModelObj) {
        let favs = defaults.object(forKey: FAVS_KEY)
        if var uFavs = favs as? [ModelObj] {
            uFavs.append(item)
            defaults.set(uFavs, forKey: FAVS_KEY)
        }
    }
    
    private func informListeners(favs:[ModelObj]){
        for listener in listeners {
            listener.onReceive(ids: [], elements: favs)
        }
    }
}
