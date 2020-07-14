//
//  AppProperties.swift
//  UtilToolKit
//
//  Created by xattacker on 2015/7/4.
//  Copyright (c) 2015年 xattacker. All rights reserved.
//

import UIKit
import LocalAuthentication


public enum ResolutionSize: Int
{
   case inch_3_5      = 0
   case inch_4        = 1
   case inch_4_7      = 2
   case inch_5_5      = 3 // iPhone plus
   case inch_5_8      = 4 // iPhone X
    
   case unknown       = 99
}

public enum UserInterfaceStyle
{
    case light
    case dark
    
    case unspecified
}


public final class AppProperties // Path related
{
    public class func getAppHomePath() -> String
    {
        return NSHomeDirectory()
    }
    
    public class func getAppDocPath() -> String
    {
        return NSSearchPathForDirectoriesInDomains(
               FileManager.SearchPathDirectory.documentDirectory,
               FileManager.SearchPathDomainMask.userDomainMask,
               true
               )[0]
    }
    
    public class func getAppCachesPath() -> String
    {
        return NSSearchPathForDirectoriesInDomains(
               FileManager.SearchPathDirectory.cachesDirectory,
               FileManager.SearchPathDomainMask.userDomainMask,
               true
               )[0]
    }
    
    public class func getAppStoragePath() -> String
    {
        let path = self.getAppDocPath().stringByAppendingPathComponent("Storage") ?? ""
        self.checkPath(path)
        
        return path
    }
    
    public class func getAppTempPath() -> String
    {
        let path = self.getAppHomePath().stringByAppendingPathComponent("temp") ?? ""
        self.checkPath(path)
        
        return path
    }
    
    public class func getTempPath() -> String
    {
        return NSTemporaryDirectory()
    }
    
    private class func checkPath(_ path: String)
    {
        if !FileUtility.isDirExisted(path)
        {
            do
            {
                try FileManager.default.createDirectory(
                    atPath: path,
                    withIntermediateDirectories: true,
                    attributes: nil)
            }
            catch
            {
            }
        }
    }
}


extension AppProperties // Info related
{
    public class func getAppName() -> String
    {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? ""
    }
    
    public class func getDisplayName() -> String
    {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""
    }

    public class func getBundleIdentifier() -> String
    {
        return Bundle.main.bundleIdentifier!
    }
    
    public static func getAppVersion() -> String
    {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        return version ?? ""
    }
    
    public static func getAppBuildVersion() -> String
    {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
        return version ?? ""
    }
    
    public class var isEmulator: Bool
    {
        var emu = false
        
#if arch(i386) || arch(x86_64)
        emu = true
#endif
        
        return emu
    }
    
    public class func getDeviceId() -> String
    {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
    
    public class func getDeviceName() -> String
    {
        return UIDevice.current.name
    }
    
    public class func getOSVersion() -> Float
    {
        let array = self.getOSVersionStr().components(separatedBy: ".")
        var new_version = ""
        
        for i in 0 ..< array.count
        {
            let v = array[i]
            new_version += v
            
            if i == 0 && array.count > 1
            {
                // first digit is before point
                new_version += "."
            }
        }
        
        return new_version.floatValue() ?? 0
    }

    public class func getOSVersionStr() -> String
    {
        return UIDevice.current.systemVersion
    }
}


extension AppProperties // UI related
{
    public class func getOrientation() -> UIInterfaceOrientation
    {
        return UIApplication.shared.statusBarOrientation
    }
    
    public class var isLandscape: Bool
    {
        return UIDevice.current.orientation.isLandscape ||
               self.getOrientation().isLandscape
    }
    
    public class var isPortrait: Bool
    {
        return UIDevice.current.orientation.isPortrait ||
               self.getOrientation().isPortrait
    }
    
    public class func getUserInterfaceIdiom() -> UIUserInterfaceIdiom
    {
        return UI_USER_INTERFACE_IDIOM()
    }
    
    public class var isPhone: Bool
    {
        return self.getUserInterfaceIdiom() == .phone
    }
    
    public class var isPad: Bool
    {
        return self.getUserInterfaceIdiom() == .pad
    }
    
    public class var screenScale: CGFloat
    {
        return UIScreen.main.scale
    }

    public class var screenSize: CGRect
    {
        return UIScreen.main.bounds
    }

    public class func getScreenResolution() -> ResolutionSize
    {
        var size = ResolutionSize.unknown
        
        if self.isPhone
        {
            let height = UIScreen.main.bounds.size.height

            switch height
            {
                case 480:
                    size = .inch_3_5
                    break
                
                case 568:
                    size = .inch_4
                    break
                
                case 667:
                    size = .inch_4_7
                    break
                
                case 736:
                    size = .inch_5_5
                    break
                
                case 812:
                    size = .inch_5_8
                    break
                
                default:
                    size = .unknown
                    break
            }
        }
    
        return size
    }
    
    public class var hasFaceDetector: Bool
    {
        if #available(iOS 11.0, *)
        {
            /*
            let context = LAContext()
            var error: NSError?
            
             // need LocationAuthorized declaration
            guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else
            {
                return false
            }
            
            return context.biometryType == .faceID
            */
            
            if self.isLandscape
            {
                if let leftPadding = UIApplication.shared.keyWindow?.safeAreaInsets.left, leftPadding > 20
                {
                    return true
                }
                
                if let rightPadding = UIApplication.shared.keyWindow?.safeAreaInsets.right, rightPadding > 20
                {
                    return true
                }
            }
            else
            {
                if let topPadding = UIApplication.shared.keyWindow?.safeAreaInsets.top, topPadding > 20
                {
                    return true
                }
                
                if let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom, bottomPadding > 20
                {
                    return true
                }
            }
        }
        
        return false
    }
    
    public class var userInterfaceStyle: UserInterfaceStyle
    {
        var style = UserInterfaceStyle.unspecified
        
        if #available(iOS 13.0, *)
        {
            switch UITraitCollection.current.userInterfaceStyle
            {
                case .light:
                    style = .light
                    break
                    
                case .dark:
                    style = .dark
                    break
                    
                default:
                    break
            }
        }
        
        return style
    }
}


extension UITraitEnvironment
{
    public var userInterfaceStyle: UserInterfaceStyle
    {
        var style = UserInterfaceStyle.unspecified
        
        if #available(iOS 13.0, *)
        {
            switch self.traitCollection.userInterfaceStyle
            {
                case .light:
                    style = .light
                    break
                    
                case .dark:
                    style = .dark
                    break
                    
                default:
                    break
            }
        }
        
        return style
    }
}
