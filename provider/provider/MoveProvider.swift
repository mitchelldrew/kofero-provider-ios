//
//  MoveProvider.swift
//  provider
//
//  Created by Mitchell Drew on 10/3/21.
//

import Foundation
import presenter

/*
open class MoveProvider: IMoveProvider {
    private var listeners = [IMoveProviderListener]()
    private var moves = [ModelMove]()
    private let fileManager:IFileManager
    private let restManager:IRestManager
    private let mapper: IMoveMapper
    private let moveUrl:URL
    
    public init(fileManager:IFileManager, restManager:IRestManager, mapper: IMoveMapper, moveUrl:URL){
        self.fileManager = fileManager
        self.restManager = restManager
        self.mapper = mapper
        self.moveUrl = moveUrl
    }
    
    public func addListener(moveListener: IMoveProviderListener) {
        listeners.append(moveListener)
    }
    
    private func informListeners(ids:[KotlinInt], move:[ModelMove]){
        for listener in listeners {
            listener.onReceive(ids: ids, moves: move)
        }
    }
    
    private func informListenersError(ids:[KotlinInt], error:KotlinException){
        for listener in listeners {
            listener.onError(ids: ids, error: error)
        }
    }
    
    public func get(ids: [KotlinInt]) {
        
    }
    
    public func removeListener(moveListener: IMoveProviderListener) {
        listeners.removeAll{listener in return listener === moveListener}
    }
    
    
}
*/
