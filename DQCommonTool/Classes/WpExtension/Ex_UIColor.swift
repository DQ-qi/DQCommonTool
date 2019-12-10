//
//  UIColorExtension.swift
//  xxxxx
//
//  Created by xxx on 2017/4/28.
//  Copyright © 2017年 xxx. All rights reserved.
//

import Foundation
import UIKit

public typealias Color = UIColor
extension UIColor {
    /// SwifterSwift: Create Color from RGB values with optional transparency.
    ///
    /// - Parameters:
    ///   - red: red component.
    ///   - green: green component.
    ///   - blue: blue component.
    ///   - transparency: optional transparency value (default is 1).
    public convenience init?(red: Int, green: Int, blue: Int, transparency: CGFloat = 1) {
        guard red >= 0 && red <= 255 else { return nil }
        guard green >= 0 && green <= 255 else { return nil }
        guard blue >= 0 && blue <= 255 else { return nil }
        
        var trans = transparency
        if trans < 0 { trans = 0 }
        if trans > 1 { trans = 1 }
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: trans)
    }
    
    /// SwifterSwift: Create Color from hexadecimal value with optional transparency.
    ///
    /// - Parameters:
    ///   - hex: hex Int (example: 0xDECEB5).
    ///   - transparency: optional transparency value (default is 1).
    public convenience init?(hex: Int, transparency: CGFloat = 1) {
        var trans = transparency
        if trans < 0 { trans = 0 }
        if trans > 1 { trans = 1 }
        
        let red = (hex >> 16) & 0xff
        let green = (hex >> 8) & 0xff
        let blue = hex & 0xff
        self.init(red: red, green: green, blue: blue, transparency: trans)
    }

    /// Quickly construct color object
    convenience init(r : CGFloat, g : CGFloat, b : CGFloat, alpha:CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }
    
    
    /// Compare whether the colors are the same for the same color
    func compar (_ color:UIColor) -> Bool{
        
        var r:CGFloat = 0;  var g:CGFloat  = 0; var b:CGFloat = 0;  var alpha:CGFloat  = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &alpha)
        
        var r2:CGFloat = 0; var g2:CGFloat  = 0; var b2:CGFloat = 0;  var alpha2:CGFloat  = 0
        color.getRed(&r2, green: &g2, blue: &b2, alpha: &alpha2)
        
        return (Int(r*255) == Int(r2*255) && Int(g*255) == Int(g2*255) && Int(b*255) == Int(b2*255) )
    }
}

extension UIColor {
    
    /**默认背景灰*/
    class func defaultBgColor() -> UIColor {
        return UIColor.init(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1)
    }

    /** 16进制转RGB*/
    class func hex(RGB:Int,_ alpha:CGFloat = 1.0 ) -> UIColor {
        return UIColor.init(red: CGFloat(Float(Float((RGB & 0xFF0000) >> 16) / 255.0)), green: CGFloat(Float(Float((RGB & 0xFF00) >> 8) / 255.0)), blue: CGFloat(Float((RGB & 0xFF)) / 255.0), alpha: alpha)
    }
    
}

// MARK: - Flat UI colors
public extension Color {
    
    /// SwifterSwift: Flat UI colors
    struct FlatUI {
        // http://flatuicolors.com.
        
        public static let dqMaincolor           = Color(hex: 0x49B9EE)//01A0EB
        
        public static let textDeepColor         = Color(hex: 0x333333)//深label字体颜色
        
        public static let textShallowColor      = Color(hex: 0x666666)//浅label字体颜色
        
        /// SwifterSwift: hex #1ABC9C
        public static let turquoise             = Color(hex: 0x1abc9c)!
        
        /// SwifterSwift: hex #16A085
        public static let greenSea              = Color(hex: 0x16a085)!
        
        /// SwifterSwift: hex #2ECC71
        public static let emerald               = Color(hex: 0x2ecc71)!
        
        /// SwifterSwift: hex #27AE60
        public static let nephritis             = Color(hex: 0x27ae60)!
        
        /// SwifterSwift: hex #3498DB
        public static let peterRiver            = Color(hex: 0x3498db)!
        
        /// SwifterSwift: hex #2980B9
        public static let belizeHole            = Color(hex: 0x2980b9)!
        
        /// SwifterSwift: hex #9B59B6
        public static let amethyst              = Color(hex: 0x9b59b6)!
        
        /// SwifterSwift: hex #8E44AD
        public static let wisteria              = Color(hex: 0x8e44ad)!
        
        /// SwifterSwift: hex #34495E
        public static let wetAsphalt            = Color(hex: 0x34495e)!
        
        /// SwifterSwift: hex #2C3E50
        public static let midnightBlue          = Color(hex: 0x2c3e50)!
        
        /// SwifterSwift: hex #F1C40F
        public static let sunFlower             = Color(hex: 0xf1c40f)!
        
        /// SwifterSwift: hex #F39C12
        public static let flatOrange            = Color(hex: 0xf39c12)!
        
        /// SwifterSwift: hex #E67E22
        public static let carrot                = Color(hex: 0xe67e22)!
        
        /// SwifterSwift: hex #D35400
        public static let pumkin                = Color(hex: 0xd35400)!
        
        /// SwifterSwift: hex #E74C3C
        public static let alizarin              = Color(hex: 0xe74c3c)!
        
        /// SwifterSwift: hex #C0392B
        public static let pomegranate           = Color(hex: 0xc0392b)!
        
        /// SwifterSwift: hex #ECF0F1
        public static let clouds                = Color(hex: 0xecf0f1)!
        
        /// SwifterSwift: hex #BDC3C7
        public static let silver                = Color(hex: 0xbdc3c7)!
        
        /// SwifterSwift: hex #7F8C8D
        public static let asbestos              = Color(hex: 0x7f8c8d)!
        
        /// SwifterSwift: hex #95A5A6
        public static let concerte              = Color(hex: 0x95a5a6)!
        
        public static let baseCtlBackgroundColor = Color(hex: 0xf2f2f2)!
        
        public static let baseMainColor = Color(hex: 0x00ac8b)!
    }
    
}

