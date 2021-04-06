//
//  ImageProvider.swift
//  provider
//
//  Created by Mitchell Drew on 26/2/21.
//

import Foundation
import presenter

open class ImageProvider: IImageProvider {
    private var listeners = [IImageProviderListener]()
    public let restManager:IRestManager
    public let fileManager:IFileManager
    
    public init(core:ProviderCore){
        self.restManager = core.restManager
        self.fileManager = core.fileManager
    }
    
    private func informListenersNon200(url:String, response:HTTPURLResponse){
        for listener in listeners {
            listener.onError(url: url, error: KotlinException(message: "status code: \(response.statusCode), response: \(response)"))
        }
    }
    
    private func informListenersUnexpectedError(url:String){
        for listener in listeners {
            listener.onError(url: url, error: KotlinException(message: "unexpected error"))
        }
    }
    
    private func informListeners(data:Data, url:String){
        for listener in listeners {
            listener.onReceive(url: url, imgBase64: data.base64EncodedString())
        }
    }
    
    private func getFromDisk(url:String){
        DispatchQueue.global().async { [self] in
            if(fileManager.fileExists(atPath: url)){
                if let uData = fileManager.contents(atPath: url){
                    informListeners(data: uData, url: url)
                }
            }
        }
    }
    
    private func saveToDisk(data: Data, url: String){
        
    }
    
    private func getRestClosure(url:String) -> RestClosure {
        return {[self] data,response,error in
            if let uResponse = response as? HTTPURLResponse {
                if let uData = data {
                    if(uResponse.statusCode == 200) {
                        informListeners(data: uData, url: url)
                        saveToDisk(data: uData, url: url)
                    }
                    else { informListenersNon200(url: url, response: uResponse)}
                }
                else{informListenersUnexpectedError(url: url)}
            }
            else{informListenersUnexpectedError(url: url)}
        }
    }
    
    public func get(url: String) {
        getFromDisk(url: url)
        if let uRL = URL(string: url) {
            restManager.dataTask(with: URLRequest(url: uRL), completionHandler: getRestClosure(url:url)).resume()
        }
    }
    
    public func removeListener(imgListener: IImageProviderListener) {
        listeners.removeAll(where: {listener in return imgListener === listener})
    }
    
    public func addListener(imgListener: IImageProviderListener) {
        listeners.append(imgListener)
    }
}
