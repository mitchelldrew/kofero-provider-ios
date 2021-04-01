//
//  Provider.swift
//  provider
//
//  Created by Mitchell Drew on 1/4/21.
//

import Foundation
import presenter

open class Provider<O:ModelModelObj>: IProvider {
    internal var listeners = [IProviderListener]()
    internal let restManager: IRestManager
    internal let fileManager: IFileManager
    internal let userDefaults: IUserDefaults
    internal let encoder:IEncoder
    internal var elements = [O]()
    internal let url:URL
    internal let mapper:DataMapper<[O]>
    internal var isDiskPulled = false
    internal var requests = [[KotlinInt]]()
    internal var jsonFilename: String
    
    init(restManager: IRestManager, fileManager: IFileManager, userDefaults: IUserDefaults, encoder: IEncoder, url:URL, mapper:DataMapper<[O]>, jsonFilename:String){
        self.fileManager = fileManager
        self.restManager = restManager
        self.userDefaults = userDefaults
        self.encoder = encoder
        self.url = url
        self.mapper = mapper
        self.jsonFilename = jsonFilename
    }
    
    internal func isResponseGood(data:Data?, response:URLResponse?, error:Error?) -> Bool {
        return data != nil && (response as! HTTPURLResponse).statusCode == 200 && error == nil
    }
    
    private func isSatisfiable(request: [KotlinInt]) -> Bool {
        for id in request {
            if(!elements.contains(where: {element in return element.id == id.int32Value})){ return false }
        }
        return true
    }
    
    public func get(ids: [KotlinInt]) {
            if(!isDiskPulled){
                pullFromDisk(ids: ids)
            }
            else{
                if(isSatisfiable(request: ids)){ informListeners(ids: ids, elements: retrieve(ids: ids)) }
                else{
                    requests.append(ids)
                    restManager.dataTask(with: createRequest(ids: ids), completionHandler: getRestClosure(ids: ids)).resume()
                }
            }
    }
    
    private func add(new:[O]){
        for element in new {
            elements.removeAll(where: {existingElement in return element.id == existingElement.id})
            elements.append(element)
        }
    }
    
    private func getRestClosure(ids: [KotlinInt]) -> RestClosure {
        return {[self] data, response, error in
            if(isResponseGood(data:data, response:response, error:error)){
                do{ add(new: try mapper.map(data: data!)) }
                catch { informListenersError(ids: ids, error: KotlinException(message: error.localizedDescription)) }
            }
            else{
                informListenersError(ids: ids, error: KotlinException(message: "error:\(error.debugDescription), response: \(response.debugDescription)"))
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
    
    
    private func retrieve(ids: [KotlinInt]) -> [O] {
        var ret = [O]()
        for id in ids {
            ret.append(elements.first(where: {element in return element.id == id.int32Value})!)
        }
        return ret
    }
    
    private func pullFromDisk(ids: [KotlinInt]){
        isDiskPulled = true
        requests.append(ids)
        if let json = fileManager.contents(atPath: fileManager.currentDirectoryPath + jsonFilename) {
            do{
                elements = try mapper.map(data: json)
            }
            catch {
                informListenersError(ids: ids, error: KotlinException(message: "serialization error"))
            }
        }
        restManager.dataTask(with: createRequest(ids: ids), completionHandler: getRestClosure(ids: ids)).resume()
    }
    
    
    public func addListener(listener: IProviderListener) {
        listeners.append(listener)
    }
    
    public func removeListener(listener: IProviderListener) {
        listeners.removeAll{compListener in return listener === compListener}
    }
    
    private func informListeners(ids: [KotlinInt], elements: [ModelModelObj]){
        for listener in listeners{
            listener.onReceive(ids: ids, elements: elements)
        }
    }
    
    private func informListenersError(ids: [KotlinInt], error: KotlinException){
        for listener in listeners {
            listener.onError(ids: ids, error: error)
        }
    }
}
