//
//  AppUtility.swift
//  UtilToolKit
//
//  Created by xattacker on 2015/7/4.
//  Copyright (c) 2015年 xattacker. All rights reserved.
//

import UIKit
import SystemConfiguration
import UserNotifications
import CoreTelephony
import AudioToolbox.AudioServices


public final class AppUtility
{
    public class func registerNotificationPermission()
    {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(
        options: [.alert, .badge, .sound],
        completionHandler:
        {
            (granted: Bool, error: Error?) in
        })

        UIApplication.shared.registerForRemoteNotifications()
    }

    public class func getString(_ key: String, parameters: String...) -> String
    {
        var value = String.localizedString(key)
        
        if parameters.count > 0
        {
            var count = 0
            var temp = String(describing: value)
            
            for para in parameters
            {
                let replace = String(format: "[%d]", count)
                if let index = temp.range(of: replace)
                {
                    temp.replaceSubrange(index, with: para)
                }
                
                count += 1
            }
            
            value = temp
        }
        
        return value
    }

    public class func checkNetworkConnection() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(
                                             to: &zeroAddress,
                                             {
                                                $0.withMemoryRebound(to: sockaddr.self, capacity: 1)
                                                {
                                                    SCNetworkReachabilityCreateWithAddress(nil, $0)
                                                }
                                             }) else
        {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags)
        {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return isReachable && !needsConnection
    }
   
    @discardableResult
    public class func openUrl(_ url: String, force: Bool = false) -> Bool
    {
        var result = false
        
        // we must encode the url if there are chinese chars inside
        guard let ns_url = url.toURL() else
        {
            return false
        }
        
        
        if force || UIApplication.shared.canOpenURL(ns_url)
        {
            /*
             from iOS9:
             If you call the “canOpenURL” method on a URL that is not in your whitelist, it will return “NO”,
             even if there is an app installed that has registered to handle this scheme.
             A “This app is not allowed to query for scheme xxx” syslog entry will appear.
             */
            UIApplication.shared.open(ns_url)
            result = true
        }
        
        return result
    }

    @inline(__always) public class func log(_ content: Any?)
    {
#if DEBUG
        if let content = content
        {
            switch content
            {
                case let error as Error:
                    print(error.localizedDescription)
                    break
                    
                default:
                    print(content)
                    break
            }
        }
        else
        {
            print("log is nil")
        }
#endif
    }
}
