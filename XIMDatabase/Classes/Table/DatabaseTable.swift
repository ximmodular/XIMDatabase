//
//  DatabaseTable.swift
//  XIMDBPodLib_Example
//
//  Created by xiaofengmin on 2019/10/9.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import FMDB

public protocol DatabaseTableProtocol: AnyObject {
    var databaseName:String { get }
    var tableName:String { get }
    var columInfos:[String:ColumInfo] { get }
    var primaryKeyName:String { get }
}

public struct ColumInfo {
//    let name:String
    public let type:ColumType
    public var nullable:Bool
    public var info: String { get {
        let nullStateStr = nullable ? "" : "not null"
        return "\(type.description) \(nullStateStr)"
        }
    }
    
    public init(type:ColumType, nullable:Bool=true) {
        self.type = type
        self.nullable = nullable
    }
    
}

public enum ColumType:CustomStringConvertible {
    case text
    case integer
    
    public var description: String {
        switch self {
        case .text:
            return "text"
        case .integer:
            return "integer"
        }
    }
    
}

open class DatabaseTable: NSObject {
    lazy var queryCommand:QueryCommand! = {
        let queryCommand = QueryCommand.init(tb: (self as! DatabaseTableProtocol))
        return queryCommand
    }()
    
    private func config(_ queryCommand:QueryCommand) -> Void {
        let _ = queryCommand.creatTable()
    }
    
    public override init() {
        super.init()
        config(queryCommand!)
    }
    
    
    public func excute(sql:String) -> Bool {
        queryCommand.excute(sql: sql)
    }
    
    public func fetch(sql:String) -> [FMResultSet] {
        return queryCommand.fetch(sql: sql)
        
    }
    
    public func insert(conditions:[String:Any]) -> Bool {
        return queryCommand.insert(conditions: conditions)
    }
    
    public func update(conditions:[String:Any], whereString:String, whereValue:Any) -> Bool {
        return queryCommand.update(conditions: conditions, whereString: whereString, whereValue: whereValue)
    }
    
    //FMResultSet need to remove
    public func search(whereString:String, whereValue:Any, parseFunc:(FMResultSet) -> Any) -> [Any]! {
        return queryCommand.search(whereString: whereString, whereValue: whereValue, parseFunc: parseFunc)
    }
    
    public func delete(whereString:String, whereValue:Any) -> Void {
        return queryCommand.delete(whereString: whereString, whereValue: whereValue)
    }
    
    public func clear() {
        return queryCommand.clear()
    }
    
}
