//
//  DQCalculate.swift
//  DQCommonTool_Example
//
//  Created by dengqi on 2020/5/15.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

public extension String {
    
    // MARK: 根据区间取子字符串
    func substringInRange(_ r: Range<Int>)->String {
        if r.lowerBound<0 {
            return ""
        }
        if r.upperBound>self.count {
            return self
        }
        let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
        let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
    
    // MARK: 提取子字符串 index: 下标 0即为原本的字符串
    func getExtractRemainString(index:Int = 0)->String {
        if (index>=self.count) {
            return ""
        }
        let index = self.index(self.startIndex, offsetBy: index)
        return String(self.suffix(from: index))
    }
    
    // MARK: 字符串转数组
    func stringToArray()->[String] {
        var muArr = [String]()
        for (_ ,str) in self.enumerated() {
            muArr.append(String.init(str))
        }
        return muArr
    }
    
}

public struct DQTestCalculateString {
    
    // MARK: 几串几的玩法的注数计算方法 num == 2
    func dq_ecyFunction(arr:[String])->[String] {
        // 输入 (n1,n2,n3) -> (n1*n2 + n1*n3 + n2*n3)
        var sum:[String] = []
        for i in 0..<arr.count {
            for j in i+1..<arr.count {
                let n1 = arr[i]
                let n2 = arr[j]
                sum.append(n1+n2)
            }
        }
        return sum
    }

    // MARK: 几串几的玩法的注数计算方法 num >= 3
    func dq_calculateBaseA_Few_StringsWayFunction(arr:[String],num:Int)->[String] {
        if num == 2 {
            return dq_ecyFunction(arr: arr)
        }
        var total:[String] = []
        let muSet = NSMutableSet()//用来存放被选出来元素的聚合 减轻计算的复杂度
        for i in 0..<arr.count {
            let n = arr[i]
            muSet.add(i)
            let newArr = dq_brushToChooseNumbersFunction(chooses: arr, brushs: muSet)
            let index = num-1
            if index<=2 {//递归的结束 基础是调用2串1
                let sub = dq_ecyFunction(arr: newArr)
                let arr = sub.map { (str) -> String in
                    return n+str
                }
                total.append(contentsOf: arr)
            } else {//自己调用自己 递归
                let sub = dq_calculateBaseA_Few_StringsWayFunction(arr: newArr, num: index)
                let arr = sub.map { (str) -> String in
                    return n+str
                }
                total.append(contentsOf: arr)
            }
        }
        return total
    }

    func dq_brushToChooseNumbersFunction(chooses:[String],brushs:NSMutableSet)->[String] {
        var muArr = [String]()
        for (i,number) in chooses.enumerated() {
            if !brushs.contains(i) {
                muArr.append(number)
            }
        }
        return muArr
    }

   public func dq_test() {
        let testStr = "abcd"
        var newArr = [String]()
        for i in 1...testStr.count {
            if i==1 {
                let arr1 = testStr.stringToArray()
                newArr.append(contentsOf: arr1)
            } else {
                let arr1 = testStr.stringToArray()
                let arr2 = dq_calculateBaseA_Few_StringsWayFunction(arr: arr1, num: i)
                newArr.append(contentsOf: arr2)
            }
        }
        print(newArr)
    }

}

