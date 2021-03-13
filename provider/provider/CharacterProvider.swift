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
        
    }
    
    public func removeListener(charListener: ICharacterProviderListener) {
        listeners.removeAll{listener in return listener === charListener}
    }
    
    public func addListener(charListener: ICharacterProviderListener) {
        listeners.append(charListener)
    }
    
}
