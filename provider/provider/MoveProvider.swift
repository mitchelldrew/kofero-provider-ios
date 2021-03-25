//
//  MoveProvider.swift
//  provider
//
//  Created by Mitchell Drew on 10/3/21.
//

import Foundation
import presenter

open class MoveProvider: IMoveProvider {
    private var listeners = [IMoveProviderListener]()
    private var moves = [ModelMove]()
    private let fileManager:IFileManager
    private let restManager:IRestManager
    private let serializer: MoveSerializer
    private let moveUrl:URL
    
    public init(fileManager:IFileManager, restManager:IRestManager, serializer: MoveSerializer, moveUrl:URL){
        self.fileManager = fileManager
        self.restManager = restManager
        self.serializer = serializer
        self.moveUrl = moveUrl
    }
    
    public func addListener(moveListener: IMoveProviderListener) {
        listeners.append(moveListener)
    }
    
    private func informListeners(id:Int32, move:ModelMove){
        for listener in listeners {
            listener.onReceive(ids: <#T##[KotlinInt]#>, moves: <#T##[ModelMove]#>)
        }
    }
    
    public func get(id: Int32) {
        
    }
    
    public func removeListener(moveListener: IMoveProviderListener) {
        listeners.removeAll{listener in return listener === moveListener}
    }
    
    
}
