//
//  StockRecord.swift
//  XIMDBPodLib_Example
//
//  Created by xiaofengmin on 2019/10/10.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import XIMDatabase

struct StockInfo:DatabaseRecordProtocol {

    
    var stockCode:String?
    var stockName:String?
    var stockMarket:Int?
    var stockDecription:String?
    
    public func dictionaryRepresentation(table: DatabaseTableProtocol) -> [String : Any] {
        let dic:[String:Any] = [
            "stockCode":stockCode!,
            "stockName":stockName!,
            "stockMarket":stockMarket!,
            "stockDecription":stockDecription!
        ]
        return dic
    }
    
    public func objectRepresentation(dic: [String : Any]) ->DatabaseRecordProtocol {
        var stock = StockInfo.init()
        stock.stockCode = dic["stockCode"] as? String
        stock.stockName = dic["stockName"] as? String
        stock.stockMarket = dic["stockMarket"] as? Int
        stock.stockDecription = dic["stockDecription"] as? String
        return stock
    }
    
}

struct StockBase:DatabaseRecordProtocol {
    
    var stockCode:String?
    var stockName:String?
    var stockMarket:Int?
    
    public func dictionaryRepresentation(table: DatabaseTableProtocol) -> [String : Any] {
        let dic:[String:Any] = [
            "stockCode":stockCode!,
            "stockName":stockName!,
            "stockMarket":stockMarket!,
        ]
        return dic
    }
    
    public func objectRepresentation(dic: [String : Any]) ->DatabaseRecordProtocol {
        var stock = StockBase.init()
        stock.stockCode = dic["stockCode"] as? String
        stock.stockName = dic["stockName"] as? String
        stock.stockMarket = dic["stockMarket"] as? Int
        return stock
    }
    
}

struct StockDesc:DatabaseRecordProtocol {
    
    var stockCode:String?
    var stockDecription:String?
    
    public func dictionaryRepresentation(table: DatabaseTableProtocol) -> [String : Any] {
        let dic:[String:Any] = [
            "stockCode":stockCode!,
            "stockDecription":stockDecription!
        ]
        return dic
    }
    
    public func objectRepresentation(dic: [String : Any]) ->DatabaseRecordProtocol {
        var stock = StockDesc.init()
        stock.stockCode = dic["stockCode"] as? String
        stock.stockDecription = dic["stockDecription"] as? String
        return stock
    }
    
}
