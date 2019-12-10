//
//  NCDeviceExtension.swift
//  xxxx
//
//  Created by xxxxon 2017/4/18.
//  Copyright © 2017年 xxxx. All rights reserved.
//

import Foundation
import UIKit

public extension UIDevice {
    
    // MARK: 设备宽度是否大于375
    static var isGreaterThan375 : Bool {
        return UIScreen.main.bounds.width > CGFloat(375)
    }
    
    // MARK: 设备宽度是否等于375
    var is375 : Bool {
        return UIScreen.main.bounds.width == CGFloat(375)
    }
    
    // MARK: 设备宽度是否小于375
    static var islessThan375:Bool {
        return UIScreen.main.bounds.width < CGFloat(375)
    }
    
    // MARK:是否是iPhone X XR XS XS-Max的设备
    @objc static var isiPhoneX:Bool {
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

