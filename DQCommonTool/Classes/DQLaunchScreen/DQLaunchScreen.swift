//
//  DQLaunchScreen.swift
//  DQCommonTool_Example
//
//  Created by HXSMac on 2020/4/13.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

public class DQLaunchScreen: NSObject {
    
    lazy var launchScreenVc:DQLaunchScreenViewController = {
       let launchScreenVc = DQLaunchScreenViewController()
       launchScreenVc.view.backgroundColor = UIColor.clear
       return launchScreenVc
    }()
    
    var window:UIWindow?
    
    public override init() {
        super.init()
    }
    
    func setup() {
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.rootViewController = self.launchScreenVc
        window?.backgroundColor = UIColor.white
        window?.rootViewController?.view.isUserInteractionEnabled = false
        window?.windowLevel = UIWindow.Level.statusBar+1
        window?.alpha = 1
        window?.isHidden = false
        
        let imageView = UIImageView()
        imageView.frame = window!.frame
        imageView.backgroundColor = UIColor.orange
        window?.addSubview(imageView)
        imageView.image = imageFromLaunchScreen()
            //UIImage.init(named: "launch_custom_iPhoneX")
        //imageFromLaunchScreen()
    
    }
    
    public func showFunction() {
        setup()
    }
    
    public func dissFunction() {
        window?.subviews.forEach({ (view) in
            view.removeFromSuperview()
        })
        window?.isHidden = true
        window = nil
    }
    
    func imageFromLaunchScreen()->UIImage? {
        if let infoDict = Bundle.main.infoDictionary {
            guard let UILaunchStoryboardName = infoDict["UILaunchStoryboardName"] as? String else {
                return nil
            }
            if let launchVc = UIStoryboard.init(name: UILaunchStoryboardName, bundle: nil).instantiateInitialViewController() {
                let view = launchVc.view
                var containerWindow: UIWindow? = UIWindow.init(frame: UIScreen.main.bounds)
                view?.frame = containerWindow!.bounds
                containerWindow?.addSubview(view!)
                containerWindow?.layoutIfNeeded()
                let image = imageFromView(view: view!)
                containerWindow?.alpha = 0
                containerWindow?.isHidden = true
                containerWindow = nil
                return image
            }
        }
        return nil
    }
    
    func imageFromView(view: UIView)->UIImage? {
        let size = view.bounds.size
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        if view.drawHierarchy(in: view.bounds, afterScreenUpdates: true) {
            
        } else {
            view.layer.render(in: UIGraphicsGetCurrentContext()!)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

class DQLaunchScreenViewController: UIViewController {
    
    
}
