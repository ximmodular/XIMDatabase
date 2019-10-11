//
//  StockCenter.swift
//  XIMDBPodLib_Example
//
//  Created by xiaofengmin on 2019/10/10.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import XIMDatabase

class StockCenter: NSObject {
    lazy var stockTableA:StockTable = {
        let table = StockTable.init()
        return table
    }()
    
    lazy var stockTableB:DescriptionTable = {
        let table = DescriptionTable.init()
        return table
    }()
    
    override init() {
        super.init()
    }
    
    func insertDemo() -> Void {
        let _ = stockTableA.insert(conditions: [
            "stockcode":"300033",
            "stockname":"同花顺",
            "stockmarket":56
        ])
        
        let _ = stockTableB.insert(conditions: [
            "stockcode":"300033",
            "stockdescription":"第三方交易机构",
        ])
        
        
        let _ = stockTableA.insert(conditions: [
            "stockcode":"300037",
            "stockname":"同花顺",
            "stockmarket":56
        ])
        
        let _ = stockTableA.insert(conditions: [
            "stockcode":"300038",
            "stockname":"同花顺-1",
            "stockmarket":56
        ])
        
        let _ = stockTableA.insert(conditions: [
            "stockcode":"300039",
            "stockname":"同花顺-2",
            "stockmarket":56
        ])
        
        let _ = stockTableA.insert(conditions: [
            "stockcode":"300040",
            "stockname":"同花顺",
            "stockmarket":56
        ])
        let _ = stockTableA.update(conditions: ["stockname":"10jqka"], whereString: "stockcode", whereValue: "300040")
        
        let info = stockTableA.search(whereString: "stockcode", whereValue: "300033") { (FMResultSet) -> Any in
            var stock = StockBase()
            stock.stockCode = FMResultSet.string(forColumn: "stockcode")
            stock.stockName = FMResultSet.string(forColumn: "stockname")
            stock.stockMarket = Int(FMResultSet.int(forColumn: "stockmarket"))
            return stock
        }?.first as? DatabaseRecordProtocol
        
        let desc = stockTableB.search(whereString: "stockcode", whereValue: "300033") { (FMResultSet) -> Any in
            var stock = StockDesc()
            stock.stockCode = FMResultSet.string(forColumn: "stockcode")
            stock.stockDecription = FMResultSet.string(forColumn: "stockdescription")
            return stock
        }?.first as? DatabaseRecordProtocol
        
        //插入nil 会崩溃
        let stockInfo2 = StockInfo().mergeRecord(record: info!, override: true).mergeRecord(record: desc!, override: true)
        
        let _ = stockTableA.fetch(sql: "select * from stockTable where stockname = '10jqka'")
        
        let _ = stockTableA.delete(whereString: "stockcode", whereValue: "300037")
        
        
        let _ = stockTableA.clear()
        let _ = stockTableB.clear()
    }
    
}
