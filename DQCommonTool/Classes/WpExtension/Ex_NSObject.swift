//
//  NCNSObjectExtension.swift
//  xxxxx
//
//  Created by xx on 2017/4/13.
//  Copyright © 2017年 xx. All rights reserved.
//

import Foundation

public extension NSObject{
    
    class var className: String{
    
        return  NSStringFromClass(self).components(separatedBy: ".").last!
    }
    
    var className: String{
        return NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
        
    }
    
    //MARK: 将yyy-MM-dd HH:mm:ss 指定格式转成时间戳的类方法
   static func changeTimeFormatGetTimestamp(timerStr: String,dateFormat:String = "yyyy-MM-dd HH:mm:ss") -> String{
       guard timerStr != "" else {
           return ""
       }
       let format:DateFormatter = DateFormatter()
       format.dateFormat = dateFormat
       format.locale = Locale.init(identifier: "en_US")
       if let fromdate:Date = format.date(from: timerStr) {
           let time:TimeInterval = fromdate.timeIntervalSince1970*1000
           let timString:String = String(time)
           return timString
       }
       return ""
   }
    
    // MARK: 获取本地语言文件的字符串
    static func getInfoPlistStringFunction(key:String,_ tableName:String = "DQStringFile")->String {
        return NSLocalizedString(key, tableName: tableName, bundle: Bundle.main, value: "", comment: "")
    }
    
    // MARK: 获取当前时间格式的字符串
    func dq_getCurrentTimeStrFunction(_ dateFormat: String = "YYYY-MM-dd HH:mm:ss") ->String {
        let senddate = Date()
        let datefoematter = DateFormatter.init()
        datefoematter.dateFormat = dateFormat
        let currnentData = datefoematter.string(from: senddate)
        return currnentData
    }
    
     // MARK: 获取当前时间格式的字符串
    func dq_getCurrentTimeStampFunction() ->String {
        let senddate = Date()
        let datefoematter = DateFormatter.init()
        datefoematter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let currnentData = datefoematter.string(from: senddate)
        let currnentDataStr = NSObject.changeTimeFormatGetTimestamp(timerStr: currnentData)
        return  "\(currnentDataStr.intValue)"
    }
    
    // 获取当前时间戳
    func dq_changeTimeFormatGetTimestamp(dateFormat:String = "yyyy-MM-dd HH:mm:ss") -> TimeInterval {
        let timeStr = dq_getCurrentTimeStrFunction(dateFormat)
        let format:DateFormatter = DateFormatter()
        format.dateFormat = dateFormat
        format.locale = Locale.init(identifier: "en_US")
        if let fromdate:Date = format.date(from: timeStr) {
            let time:TimeInterval = fromdate.timeIntervalSince1970*1000
            return time
        }
        return 0.0
    }
    
   
   // MARK: 打开Url的 方法
    func dq_openUrlFunction(content: String) {
        if let url = URL.init(string: content) {
            if UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:]) { (status) in
                    }
                } else {
                    UIApplication.shared.openURL(url)
                }
                
            } else {
                let alertCtl = UIAlertController.init(title: "温馨提示", message: "打开链接失败", preferredStyle: .alert)
                alertCtl.addAction(title: "确定", style: .default, isEnabled: true) { (action) in
                }
                alertCtl.show()
            }
            
        } else {
            let alertCtl = UIAlertController.init(title: "温馨提示", message: "链接无效", preferredStyle: .alert)
            alertCtl.addAction(title: String.getInfoPlistStringFunction(key: "DQScan.Determine.title"), style: .default, isEnabled: true) { (action) in
            }
            alertCtl.show()
        }
    }
    
}
