//
//  Database.swift
//  XIMDBPodLib_Example
//
//  Created by xiaofengmin on 2019/10/9.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import FMDB

protocol DatabaseExecuteProtocol {
//    func init(name:String!, filePath:String?)
    func openDatabase() -> Bool
    func closeDatabase() -> Void
    
    func tableExists(_ tableName:String) -> Bool
    
    func executeStatements(_ sql:String) -> Bool
    func executeQuery(_ sql:String, values:[Any]?) -> FMResultSet?
    func executeUpdate(_ sql:String, values:[Any]?) -> Bool
    
}

class DataBase: NSObject, DatabaseExecuteProtocol {

    var fmdb:FMDatabase!
    var databaseName:String!
    var databaseFilePath:String!
    
    
    init(name:String!, filePath:String?) {
        super.init()
        
        databaseName = name
        
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let pathToDatabase = documentDirectory.appending("/\(databaseName!)")
        
        databaseFilePath = filePath ?? pathToDatabase
        
        let _ = openDatabase()
    }
    
    deinit {
        closeDatabase()
    }
    
    func closeDatabase() -> Void {
        if fmdb.open() {
            fmdb.close()
        }
    }
    
    func openDatabase() -> Bool {
        var open = false
        
        if !FileManager.default.fileExists(atPath: databaseFilePath) {
            fmdb = FMDatabase(path: databaseFilePath)
            if fmdb != nil && fmdb.open() {
                open = true
            }
        } else {
            if fmdb == nil {
                fmdb = FMDatabase(path: databaseFilePath)
            }
            if fmdb.open() {
                open = true
            }
        }
//        print("\(databaseFilePath!)")
        
        return open
    }
    
    func tableExists(_ tableName: String) -> Bool {
        return fmdb.tableExists(tableName)
    }
    
    func executeStatements(_ sql: String) -> Bool {
        return fmdb.executeStatements(sql)
    }
    
    func executeQuery(_ sql: String, values: [Any]?) -> FMResultSet? {
        let rs = try? fmdb.executeQuery(sql, values: nil)
        return rs
    }
    
    func executeUpdate(_ sql: String, values: [Any]?) -> Bool {
        return fmdb.executeUpdate(sql, withArgumentsIn: values!)
    }
    
}

class DataBaseQueue: NSObject, DatabaseExecuteProtocol {

    var queue:FMDatabaseQueue!
    var databaseName:String!
    var databaseFilePath:String!
    
    
    init(name:String!, filePath:String?) {
        super.init()
        
        databaseName = name
        
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let pathToDatabase = documentDirectory.appending("/\(databaseName!)")
        
        databaseFilePath = filePath ?? pathToDatabase
        
        let _ = openDatabase()
    }
    
    deinit {
        closeDatabase()
    }
    
    func closeDatabase() -> Void {
        queue.inDatabase { (fmdb) in
            if fmdb.open() {
                fmdb.close()
            }
        }
    }
    
    func openDatabase() -> Bool {
        var open = false
        
        if !FileManager.default.fileExists(atPath: databaseFilePath) {
            queue = FMDatabaseQueue(path: databaseFilePath)
            queue.inDatabase { (fmdb) in
                if fmdb.open() {
                    open = true
                }
            }
        } else {
            if queue == nil {
                queue = FMDatabaseQueue(path: databaseFilePath)
            }
            queue.inDatabase { (fmdb) in
                if fmdb.open() {
                    open = true
                }
            }
        }
        
        return open
    }
    
    func tableExists(_ tableName: String) -> Bool {
        var rs:Bool = false
        queue.inDatabase { (fmdb) in
            rs = fmdb.tableExists(tableName)
        }
        return rs
    }
    
    func executeStatements(_ sql: String) -> Bool {
        var rs:Bool = false
        queue.inDatabase { (fmdb) in
            rs = fmdb.executeStatements(sql)
        }
        return rs
    }
    
    func executeQuery(_ sql: String, values: [Any]?) -> FMResultSet? {
        var rs:FMResultSet?
        queue.inDatabase { (fmdb) in
            do {
                rs = try fmdb.executeQuery(sql, values: values)
            } catch {
            }
        }
        return rs
    }
    
    func executeUpdate(_ sql: String, values: [Any]?) -> Bool {
        var rs:Bool = false
        queue.inDatabase { (fmdb) in
            rs = fmdb.executeUpdate(sql, withArgumentsIn: values!)
        }
        return rs
    }
    
}
