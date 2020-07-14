//
//  NSObject+Custom.swift
//  Bingo
//
//  Created by TCCI MACKBOOK PRO on 2020/4/6.
//  Copyright © 2020 xattacker. All rights reserved.
//

import UIKit


extension UIView
{
    public var isReallyWhiteStyle: Bool
    {
        if #available(iOS 13.0, *)
        {
            if !self.isDarkStyle
            {
                return true
            }
        }
        
        return false
    }
}


extension UIViewController
{
    public var isReallyWhiteStyle: Bool
    {
        if #available(iOS 13.0, *)
        {
            if !self.isDarkStyle
            {
                return true
            }
        }
        
        return false
    }
}
