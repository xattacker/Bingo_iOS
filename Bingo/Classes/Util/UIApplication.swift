//
//  UIApplication.swift
//  UtilToolKit
//
//  Created by xattacker on 2017/5/6.
//  Copyright © 2017年 xattacker. All rights reserved.
//

import UIKit


extension UIApplication
{
    public static func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController?
    {
        if let nav = base as? UINavigationController
        {
            return self.topViewController(base: nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController
        {
            if let selected = tab.selectedViewController
            {
                return self.topViewController(base: selected)
            }
            
            return self.topViewController(base: tab)
        }
        
        if let presented = base?.presentedViewController
        {
            return self.topViewController(base: presented)
        }
        
        return base
    }
}


extension UIApplicationDelegate
{
    @discardableResult
    public func addSkipBackupAttributeToItemAtPath(_ path: String) -> Bool
    {
        var result = false
        
        do
        {
            var url = URL(fileURLWithPath: path, isDirectory: true)
            
            var values = URLResourceValues()
            values.isExcludedFromBackup = true
            try url.setResourceValues(values)
            
            result = true
        }
        catch
        {
        }
        
        return result
    }
    
    public func registerNotificationPermission()
    {
        AppUtility.registerNotificationPermission()
    }
}
