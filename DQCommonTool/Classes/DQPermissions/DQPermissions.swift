//
//  DQPermissions.swift
//  DQCommonTool
//
//  Created by dengqi on 2018/10/9.
//  Copyright © 2018 XXX. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

public enum DQPrivacyType: Int {
    case photo = 0,  // 相册
    camera,          // 相机
    record,          // 录音
    unknow           // 未知
    
}

//相机/相机的访问 受到限制 就是拒接 之前点击没有反应的问题
class DQPermissions: NSObject {
    
    // MARK: 相册的权限
    static func authorizePhotoWith(comletion:@escaping () -> ()){
        let granted = PHPhotoLibrary.authorizationStatus()
        switch granted {
        case .authorized:
            comletion()
        case .restricted:
            hintPrivacyFunction(.photo)
        case .denied:
            hintPrivacyFunction(.photo)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) in
                DispatchQueue.main.async {
                    if status == PHAuthorizationStatus.authorized {//第一次访问
                        comletion()
                    }
                }
            }
        default:
            break
        }
        
    }
    
    // MARK: 相机权限
    static func authorzeCameraWith(comletion:@escaping ()->()) {
        let granted = AVCaptureDevice.authorizationStatus(for: .video)
        switch granted {
        case .authorized:
            comletion()
        case .restricted:
            hintPrivacyFunction(.camera)
        case .denied:
            hintPrivacyFunction(.camera)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (status) in
                DispatchQueue.main.async {
                    if status == true {//第一次访问
                        comletion()
                    }
                }
            }
        default:
            break
        }
    }
    
    // MARK: 录音权限
    static func authorzeRecordingWith(comletion:@escaping ()->()) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        switch authStatus {
        case .authorized:
            comletion()
        case .restricted:
            hintPrivacyFunction(.record)
        case .denied:
            hintPrivacyFunction(.record)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .audio) { (status) in
                if status == true {//第一次访问
                    comletion()
                }
            }
        default:
            break
        }
    }
    
    // MARK: 跳转到APP系统设置权限界面
    static func jumpToSystemPrivacySetting() {
        
        if #available(iOS 9.0, *) {
            let appSetting = URL(string: UIApplication.OpenURLOptionsKey.openInPlace.rawValue)
            if appSetting != nil {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(appSetting!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(appSetting!)
                }
            }
        } else {
            // Fallback on earlier versions
        }
            //URL(string: UIApplication.UIApplicationOpenSettingsURLString)
        
    }
    
    // MARK: 提示信息
    static func hintPrivacyFunction(_ type:DQPrivacyType) {
        var hintStr = ""
        switch type {
        case .photo:
            hintStr = "打开相册失败,请在手机设置进行设置"
        case .camera:
            hintStr = "打开相机失败,请在手机设置进行设置"
        case .record:
             hintStr = "录音未设置,请在手机设置进行设置"
        default:
            break
        }
        guard type != .unknow else {
            return
        }
        let alerCtl = UIAlertController.init(title: String.getInfoPlistStringFunction(key: "DQScan.WarmPrompt.title"), message: hintStr, preferredStyle: .alert)
        alerCtl.addAction(title: String.getInfoPlistStringFunction(key: "DQScan.Cancel.title"), style: .default, isEnabled: true) { (action) in
            
        }
        alerCtl.addAction(title: "设置", style: .default, isEnabled: true) { (action) in
            jumpToSystemPrivacySetting()
        }
        alerCtl.show()
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
