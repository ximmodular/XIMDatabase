//
//  DatabasePool.swift
//  XIMDBPodLib_Example
//
//  Created by xiaofengmin on 2019/10/9.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

class DatabasePool: NSObject {
    static let shared = DatabasePool()
    
    private var databaseList:[String:DatabaseExecuteProtocol] = [:]
    var lock:NSLock!
    
    func findDatabaseQueue(name:String!) -> DataBaseQueue? {
        lock.lock()
        
        let currentThread = Thread.current
        let key = "\(currentThread.description) - \(filePath(databaseName: name))"
        var db = databaseList[key]
        if db == nil {
            db = DataBaseQueue.init(name: name, filePath: nil)
            self.databaseList[key] = db
        }
        
        lock.unlock()
        
        return (db as! DataBaseQueue)
    }
    
    func findDatabase(name:String!) -> DataBase? {
        lock.lock()
        
        let currentThread = Thread.current
        let key = "\(currentThread.description) - \(filePath(databaseName: name))"
        
        var db = databaseList[key]
        if db == nil {
            db = DataBase.init(name: name, filePath: nil)
            self.databaseList[key] = db
        }
        
        lock.unlock()
        
        return (db as! DataBase)
    }
    
    func closeDataBase(name:String) -> Void {
        lock.lock()
        
        for (_, value) in databaseList.keys.enumerated() {
            if value.contains("- \(filePath(databaseName: name))") {
                let db = databaseList[value]
                db?.closeDatabase()
                databaseList.removeValue(forKey: value)
            }
        }
        lock.unlock()
    }
    
    func closeAllDataBase() -> Void {
        lock.lock()
        
        for (_, value) in databaseList.keys.enumerated() {
            let db = databaseList[value]
            db?.closeDatabase()
            databaseList.removeValue(forKey: value)
        }
        lock.unlock()
    }
    
    override init() {
        super.init()
        lock = NSLock.init()
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNSThreadWillExitNotification(notificition:)), name:NSNotification.Name.NSThreadWillExit, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        self.closeAllDataBase()
    }
    
    @objc func didReceiveNSThreadWillExitNotification(notificition:NSNotification) {
        lock.lock()
        
        var databaseToColse:[DatabaseExecuteProtocol] = []
        var keyToDelete:[String] = []
        
        for (key, value) in databaseList {
            if key.contains(Thread.current.description) {
                databaseToColse.append(value)
                keyToDelete.append(key)
            }
        }
        
        for db in databaseToColse {
            db.closeDatabase()
        }
        
        for key in keyToDelete {
            databaseList.removeValue(forKey: key)
        }
        
        lock.unlock()
    }
    
    
    private func filePath(databaseName:String!) ->String {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let pathToDatabase = documentDirectory.appending("/\(databaseName!)")
        return pathToDatabase
    }
    
}
