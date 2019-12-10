//
//  DQCodableFile.swift
//  DQCommonTool
//
//  Created by dengqi on 2018/10/19.
//  Copyright © 2018 XXX. All rights reserved.
//

import Foundation

//MARK: Codable 模型与[String:Any]换转
public class DQCodableTool {
    
   // MARK: [String:Any]转成(Coable)Model
   static func dq_getModelWithAnyFunction<T: Codable>(data:[String: Any],dqClass: T.Type)->T? {
        
        if let JSONData = try? JSONSerialization.data(withJSONObject: data, options: []) {
            let decoder = JSONDecoder()
            do {
                let model = try decoder.decode(dqClass, from: JSONData)
                return model
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        return nil

    }
    
    // MARK: (Coable)Model转成[String:Any]
    static func dq_getJSONWithModelFunction<T:Codable>(model:T)->[String: Any]? {
        let encoder = JSONEncoder()
        do {
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(model)
            if let jsonDict = try?  JSONSerialization.jsonObject(with: data, options: []) {
                if let dict = jsonDict as? [String: Any] {
                    return dict
                }
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
    
}

