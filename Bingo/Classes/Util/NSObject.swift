//
//  NSObject.swift
//  UtilToolKit
//
//  Created by tao on 2016/8/7.
//  Copyright © 2016年 xattacker. All rights reserved.
//

import Foundation


extension NSObject
{
    public class var className: String
    {
        return NSStringFromClass(self).components(separatedBy: ".").last ?? ""
    }
    
    public var className: String
    {
        return type(of: self).className
    }
    
    public func synchronized(_ lock: AnyObject, closure: () -> Void)
    {
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }
    
    public static func loadClass<T: NSObject>(_ bundle: Bundle = Bundle.main, className: String) -> T.Type?
    {
        let package = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        let type = NSClassFromString(package + "." + className) as? T.Type
        
        return type
    }
    
    @inline(__always) public func log(_ content: Any?)
    {
        AppUtility.log(content)
    }
}


extension NSObject
{
    public func delay<T: NSObject>(_ delay: Double, call: @escaping(_ weakSelf: T?) -> Void)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay)
        {
            [weak self] in
            call(self as? T)
        }
    }
    
    public func async<T: NSObject>(_ call: @escaping(_ weakSelf: T?) -> Void)
    {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async
        {
            [weak self] in
            call(self as? T)
        }
    }
    
    public func main<T: NSObject>(_ call: @escaping(_ weakSelf: T?) -> Void)
    {
        if Thread.isMainThread
        {
             call(self as? T)
        }
        else
        {
            DispatchQueue.main.async
            {
                [weak self] in
                call(self as? T)
            }
        }
    }
}
