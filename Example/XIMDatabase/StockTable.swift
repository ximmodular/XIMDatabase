//
//  StockTable.swift
//  XIMDBPodLib_Example
//
//  Created by xiaofengmin on 2019/10/10.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import XIMDatabase

class StockTable: DatabaseTable, DatabaseTableProtocol {
    var databaseName: String = "database.sqlite"
    
    var tableName: String = "StockTable"
    var columInfos: [String : ColumInfo] = [
        "stockcode":ColumInfo(type: .text, nullable: false),
        "stockname":ColumInfo(type: .text, nullable: false),
        "stockmarket":ColumInfo(type: .integer)
    ]
    var primaryKeyName: String = "stockcode"

}

class DescriptionTable: DatabaseTable, DatabaseTableProtocol {
    var databaseName: String = "database.sqlite"
    
    var tableName: String = "DescriptionTable"
    
    var columInfos: [String : ColumInfo] = [
        "stockcode":ColumInfo(type: .text, nullable: false),
        "stockdescription":ColumInfo(type: .text, nullable: false),
    ]
    var primaryKeyName: String = "stockcode"
}
