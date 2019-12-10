//
//  NCDeviceExtension.swift
//  xxxx
//
//  Created by xxxxon 2017/4/18.
//  Copyright © 2017年 xxxx. All rights reserved.
//

import Foundation
import UIKit

@objc extension UIDevice {
    
    // MARK: 设备宽度是否大于375
    static var isGreaterThan375 : Bool {
        return UIScreen.main.bounds.width > CGFloat(375)
    }
    
    // MARK: 设备宽度是否等于375
    static var is375 : Bool {
        return UIScreen.main.bounds.width == CGFloat(375)
    }
    
    // MARK: 设备宽度是否小于375
    static var islessThan375:Bool {
        return UIScreen.main.bounds.width < CGFloat(375)
    }
    
    // MARK:是否是iPhone X XR XS XS-Max的设备
    @objc  static var isiPhoneX:Bool {
        if UIDevice.current.userInterfaceIdiom != .phone {
            return false
        }
        if #available(iOS 11, *) {
            if let window = UIApplication.shared.delegate?.window {
                if let safeWindow = window {
                    if safeWindow.safeAreaInsets.bottom > 0.0 {
                        return true
                    }
                }
                
            }
        }
        return false
    }
}
extension UILabel {
    
    // MARK: 处理字符串的字体的颜色的不一致的情况
    class func dealWithAttributedString(str1:String,str2:String,color1:UIColor,color2:UIColor)->NSMutableAttributedString{
        let textStr:String = String(format:"%@%@",str1,str2)
        let currentAttStr:NSMutableAttributedString = NSMutableAttributedString.init(string: textStr, attributes: [NSAttributedString.Key.kern:1])
        let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.alignment = .center
        currentAttStr.addAttributes([NSAttributedString.Key.foregroundColor:color1], range: NSMakeRange(0, str1.count))
        currentAttStr.addAttributes([NSAttributedString.Key.foregroundColor:color2], range: NSMakeRange(str1.count, str2.count))
        currentAttStr.addAttributes([NSAttributedString.Key.paragraphStyle:paragraphStyle], range: NSMakeRange(0, textStr.count))
        return currentAttStr
    }
    
}
