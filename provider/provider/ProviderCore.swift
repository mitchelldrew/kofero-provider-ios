//
//  ProviderCore.swift
//  provider
//
//  Created by Mitchell Drew on 5/4/21.
//

import Foundation

public class ProviderCore {
    public let restManager:IRestManager
    public let fileManager:IFileManager
    public let userDefaults:IUserDefaults
    public let requestEncoder:IDataEncoder<[Int32]>
    
    public init(restManager: IRestManager, fileManager:IFileManager, userDefaults:IUserDefaults, requestEncoder:IDataEncoder<[Int32]>){
        self.restManager = restManager
        self.fileManager = fileManager
        self.userDefaults = userDefaults
        self.requestEncoder = requestEncoder
    }
}
