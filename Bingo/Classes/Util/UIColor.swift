//
//  UIColor.swift
//  UtilToolKit
//
//  Created by tao on 2016/7/19.
//  Copyright © 2016年 xattacker. All rights reserved.
//

import UIKit


extension UIColor
{
    public convenience init(decimalRed: Int, green: Int, blue: Int, alpha: CGFloat = 1)
    {
        self.init(red:
        CGFloat(decimalRed) / CGFloat(255),
        green: CGFloat(green) / CGFloat(255),
        blue: CGFloat(blue) / CGFloat(255),
        alpha: alpha)
    }
    
    public convenience init(hexString: String)
    {
        let str = hexString.replacingOccurrences(of: "#", with: "")
        
        var int = UInt32()
        if Scanner(string: str).scanHexInt32(&int)
        {
            let a, r, g, b: UInt32
            
            switch str.length
            {
                case 3: // RGB (12-bit)
                    (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
                    break
                
                case 6: // RGB (24-bit)
                    (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
                    break
                
                case 8: // ARGB (32-bit)
                    (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
                    break
                
                default:
                    (a, r, g, b) = (1, 1, 1, 0)
                    break
            }
            
            self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
        }
        else
        {
            self.init(red: 0, green: 0, blue: 0, alpha: 0)
        }
    }
    
    public var rgb: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
    {
        get
        {
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            
            if let rgb = self.cgColor.components
            {
                if self.cgColor.numberOfComponents == 2
                {
                    // white
                    r = rgb[0]
                    g = rgb[0]
                    b = rgb[0]
                    
                    a = rgb[1]
                }
                else
                {
                    r = rgb[0]
                    g = rgb[1]
                    b = rgb[2]
                    
                    a = rgb[3]
                }
            }
            
            return (r, g, b, a)
        }
    }
    
    public var alpha: CGFloat
    {
        let rgb = self.rgb
        return rgb.alpha
    }
    
    public var hexString: String
    {
        get
        {
            let rgb = self.rgb
            
            return String(
                   format: "#%02X%02X%02X%02X",
                   Int(rgb.alpha*255),
                   Int(rgb.red*255),
                   Int(rgb.green*255),
                   Int(rgb.blue*255))
        }
    }
}


extension CGColor
{
    public func toUIColor() -> UIColor
    {
        return UIColor(cgColor: self)
    }
}
