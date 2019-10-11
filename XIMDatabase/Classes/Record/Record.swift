//
//  Record.swift
//  XIMDBPodLib_Example
//
//  Created by xiaofengmin on 2019/10/10.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

public protocol DatabaseRecordProtocol {
    
    func dictionaryRepresentation(table:DatabaseTableProtocol) -> [String:Any]
    
    func objectRepresentation(dic:[String:Any]) -> DatabaseRecordProtocol
    
    func mergeRecord(record:DatabaseRecordProtocol, override:Bool) -> DatabaseRecordProtocol
    
    func availableKeyList() -> [String]
    
}

public extension DatabaseRecordProtocol {
    
    
    func availableInfos() -> [String:Any] {
        let structMirror = Mirror(reflecting: self).children
        var infos:[String:Any] = [:]
        for case let (key,value) in structMirror {
            infos[key!] = value
        }
        
        return infos
    }
    
    func availableKeyList() -> [String] {
        let structMirror = Mirror(reflecting: self).children
        var allKeys:[String] = []
        for case let (key,value) in structMirror {
            print("name: \(key!) value: \(value)")
            allKeys.append(key!)
        }
        
        return allKeys
    }
    
    func mergeRecord(record:DatabaseRecordProtocol, override:Bool) -> DatabaseRecordProtocol {
        var selfInfos = availableInfos()
        let recordInfos = record.availableInfos()
        for (key,value) in recordInfos {
            if (override || selfInfos[key] == nil) {
                selfInfos[key] = value
            }
        }
        return objectRepresentation(dic: selfInfos)
    }
}
