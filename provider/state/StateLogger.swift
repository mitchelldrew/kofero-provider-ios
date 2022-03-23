//
//  StateLogger.swift
//  provider
//
//  Created by Mitchell Drew on 21/3/22.
//

import Foundation
import presenter

public class StateLogger: IStateLogger {
    public init(){}
    
    public func getStateMap() -> [KotlinLong : ModelEvent] {
        return [KotlinLong:ModelEvent]()
    }
    
    public func logState(unixTime: Int64, event: ModelEvent) -> Bool {
        return false
    }
}
