//
//  QueryCommand.swift
//  XIMDBPodLib_Example
//
//  Created by xiaofengmin on 2019/10/9.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import FMDB

//1. open
//2. execute

//每次的实际指令---> 由qcmd 进行执行
class QueryCommand: NSObject {
    weak var databaseQueue:DataBaseQueue! {
        get {
            return DatabasePool.shared.findDatabaseQueue(name:table.databaseName)
        }
    }
    
    weak var database:DataBase! {
        get {
            return DatabasePool.shared.findDatabase(name:table.databaseName)
        }
    }
    
    
    weak var table:DatabaseTableProtocol!

    init(tb:DatabaseTableProtocol) {
        table = tb
    }
    
    func creatTable() -> Bool {
        let sql = sqlCommandCreateTable(table: table)
        var result = false
        //数据库是否被打开
        if database.openDatabase() {
            
            if database.fmdb.tableExists(table.tableName) {
                return true
            }
            
            if database.fmdb.executeStatements(sql) {
                result = true
            }
        }
        return result
    }
    
    func excute(sql:String) -> Bool {
        var res = false
        if database.openDatabase() {
            res = database.fmdb.executeStatements(sql)
        }
        return res
    }
    
    func fetch(sql:String) -> [FMResultSet] {
        var ary:[FMResultSet] = []
        do {
            let rs = try database.fmdb.executeQuery(sql, values: nil)
            
            while rs.next() {
                ary.append(rs)
            }
            
        } catch {
        }
        return ary
        
    }
    
    func insert(conditions:[String:Any]) -> Bool {
        var result = false
        let (sqlCmd, values) = sqlCommandInsert(table: table, conditions: conditions)
        if database.openDatabase() {
            let res = database.fmdb.executeUpdate(sqlCmd, withArgumentsIn: values)
            if res {
                result = true
            } else {
            }
        }
        return result
    }
    
    func update(conditions:[String:Any], whereString:String, whereValue:Any) -> Bool {
        var result = false
        
        if whereString.isEmpty
            || conditions.keys.count == 0 {
            return result
        }
        
        let (sqlCmd, values) = sqlCommandUpdate(table: table, whereString: whereString, whereValue: whereValue, update: conditions)
        
        if database.openDatabase() {
            result = database.fmdb.executeUpdate(sqlCmd, withArgumentsIn: values)
        }
        return result
    }
    
    //FMResultSet need to remove
    func search(whereString:String, whereValue:Any, parseFunc:(FMResultSet) -> Any) -> [Any]! {
        var dataAry:[Any] = []
        if database.openDatabase() {
            let (sqlCmd, values) = sqlCommandSearch(table: table, whereString: whereString, whereValue: whereValue)
            do {
//                let result = try database.fmdb.executeQuery(sqlCmd, values: nil)
                let result = try database.fmdb.executeQuery(sqlCmd, values:values)
                
                
                while result.next() {
                    let resultDic = parseFunc(result)
                    dataAry.append(resultDic)
                }
                
            } catch {
            }
        }
        return dataAry
    }
    
    func delete(whereString:String, whereValue:Any) -> Void {
        let sql = sqlCommandDelete(table: table, whereString: whereString, whereValue: whereValue)
        if database.openDatabase() {
            if !database.fmdb.executeStatements(sql) {
//                XLog("Failed to insert initial data into the database.")
//                XLog("\(database.fmdb.lastError()), \(database.fmdb.lastErrorMessage())")
            }
        }
        
    }
    
    func clear() {
        let sql = sqlCommandClear(table: table)
        if database.openDatabase() {
            if !database.fmdb.executeStatements(sql) {
//                XLog("Failed to insert initial data into the database.")
//                XLog("\(database.fmdb.lastError()), \(database.fmdb.lastErrorMessage())")
            }
        }
    }
    
    func sqlCommandCreateTable(table:DatabaseTableProtocol!) -> String {
        var sqlCommand = "create table \(table.tableName) ";
        let colum = table.columInfos[table.primaryKeyName]
        
        let nullState = colum!.nullable ? "" :" not null"
        let columSql = "( \(table.primaryKeyName) \(colum!.type.description) primary key \(nullState) "
        sqlCommand.append(columSql)
        for (key, columInfo) in table.columInfos {
            if key != table.primaryKeyName {
                sqlCommand.append(",")
                sqlCommand.append(" \(key) \(columInfo.info)")
            }
        }
        sqlCommand.append(")")
//        XLog(sqlCommand)
        //todo xiaofengmin "create table \(tableName) (stockcode text primary key not null, stockname text not null, stockmarket integer)"
        return sqlCommand
//        return "create table \(table.tableName) (stockcode text primary key not null, stockname text not null, stockmarket integer)"
    }
    //"INSERT INFO \(name) (stockcode, stockdesc, stockvalue) VALUES (?,?,?)"
    
    func sqlCommandInsert(table:DatabaseTableProtocol, conditions:[String:Any]) -> (String, [Any]) {
        var sqlCommand = "INSERT INTO \(table.tableName) "
        var keys:[String] = []
        var question:[String] = []
        var values:[Any] = []
        
        for (key, value) in conditions {
            keys.append(key)
            values.append(value)
            question.append("?")
        }
        
        sqlCommand.append("(\(keys.joined(separator: ", "))) ")
        sqlCommand.append("VALUES (\(question.joined(separator: ",")))")
        
//        sqlCommand = "INSERT INFO \(table.tableName) (stockcode, stockname, stockmarket) VALUES (?,?,?)"
        
        return (sqlCommand, values)
    }
    
    // let query = "update \(name) set stockname=?, stockmarket=? where stockcode=? and or "
    //condition lenth = 1
    func sqlCommandUpdate(table:DatabaseTableProtocol, whereString:String, whereValue:Any, update:[String:Any]) -> (String, [Any]) {
        var sqlCommand = "UPDATE \(table.tableName) "
        
        var keys:[String] = []
        var values:[Any] = []
        
        for (key, value) in update {
            keys.append(" \(key)=?")
            values.append(value)
        }
        
        sqlCommand.append("SET \(keys.joined(separator: ",")) ")
        sqlCommand.append("WHERE \(whereString) =?")
        values.append(whereValue)
        
        return (sqlCommand, values)
    }
    
    func sqlCommandSearch(table:DatabaseTableProtocol, whereString:String, whereValue:Any) -> String {
        let sqlCommand = "SELECT * FROM \(table.tableName) WHERE \(whereString) = \(whereValue)"
        return sqlCommand
    }
    
    func sqlCommandSearch(table:DatabaseTableProtocol, whereString:String, whereValue:Any) -> (String, [Any]?) {
        let sqlCommand = "SELECT * FROM \(table.tableName) WHERE \(whereString) = ?"
        return (sqlCommand, [whereValue])
    }
    
    func sqlCommandDelete(table:DatabaseTableProtocol, whereString:String, whereValue:Any) -> String {
        let sqlCommand = "DELETE FROM \(table.tableName) WHERE \(whereString) = \(whereValue)"
        return sqlCommand
    }
    
    func sqlCommandClear(table:DatabaseTableProtocol) -> String {
        let sqlCommand = "DELETE FROM \(table.tableName)"
        return sqlCommand
    }
    
}
