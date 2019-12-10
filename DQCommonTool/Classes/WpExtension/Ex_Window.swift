//
//  NCWindowExtension.swift
//  xxxxx
//
//  Created by xx on 2017/5/5.
//  Copyright © 2017年 xx. All rights reserved.
//

import Foundation
import UIKit

public extension UIWindow {
    
    /// To determine whether vcType is specific type of UIViewController
    /// KeWindow当期最顶部的 Controller类型 是不是 指定的 Controller类型
    static func isSpecific(_ vcType: UIViewController.Type) -> Bool {
        
        let vc = UIWindow.appKeyWindow.visibleViewController
        return vc?.isKind(of: vcType) ?? false
    }
    
    /// get application's KeyWindow
    static var appKeyWindow: UIWindow {
        return UIApplication.shared.keyWindow!
    }
    
    /// get TabBarController selected NavigationController
    static var selectedNavigationController: UINavigationController? {
        
        let keyWindowRootVc = (UIApplication.shared.keyWindow?.rootViewController as? UITabBarController)
        return  keyWindowRootVc?.selectedViewController as? UINavigationController
    }
    
    /// Get the current displaying UIViewController(top Controller) in window, 递归查找
    
    var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(self.rootViewController)
    }
    
    static func getVisibleViewControllerFrom(_ vc: UIViewController?) -> UIViewController? {
        
        if let nc = vc as? UINavigationController {
            return UIWindow.getVisibleViewControllerFrom(nc.visibleViewController)
            
        } else if let tc = vc as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(tc.selectedViewController)
            
        } else {
            
            if let pvc = vc?.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(pvc)
            } else {
                return vc
            }
            
        }
    }
    
}
