//
//  UIAlertController.swift
//  UtilToolKit
//
//  Created by xattacker on 2015/8/3.
//  Copyright (c) 2015年 xattacker. All rights reserved.
//

import UIKit


public enum AlertTitleType
{
    case notification
    case illustration
    case warning
    case error
    case confirm
    
    // associated value
    case custom(title: String)
    
    var title: String
    {
        switch self
        {
            case .notification:
                return String.localizedString("NOTIFICATION")
                
            case .illustration:
                 return String.localizedString("ILLUSTRATION")
            
            case .warning:
                 return String.localizedString("WARNING")
            
            case .error:
                 return String.localizedString("ERROR")
            
            case .confirm:
                 return String.localizedString("CONFIRM")
            
            case .custom(let title):
                return title
        }
    }
}

public struct AlertButtonStyle
{
    var title: String
    var style: UIAlertAction.Style
    
    init(title: String, style: UIAlertAction.Style = UIAlertAction.Style.default)
    {
        self.title = title
        self.style = style
    }
}

public enum AlertButtonType
{
    case yes_no
    case confirm_cancel
    
    // associated value
    case twice(AlertButtonStyle, AlertButtonStyle)
    case single(AlertButtonStyle)
}


public protocol UIAlertControllerAppearance: class
{
    func onAlertControllerCreated(alertCtrl: UIAlertController)
}


public class UIAlertControllerAdapter
{
    private(set) internal static var instance: UIAlertControllerAdapter?
    private(set) var appearance: UIAlertControllerAppearance?
    
    public static func initial(_ appearance: UIAlertControllerAppearance)
    {
        if instance == nil
        {
            instance = UIAlertControllerAdapter()
            instance?.appearance = appearance
        }
    }
    
    public static func releaseInstance()
    {
        instance = nil
    }
}


extension UIAlertController
{
    public static func createAlertCtrl(_ type: AlertTitleType, message: String?) -> UIAlertController
    {
        return self.createAlertCtrl(type.title, message: message)
    }
    
    public static func createAlertCtrl(_ title: String? = nil, message: String?) -> UIAlertController
    {
        let alert = UIAlertController(
                    title: title,
                    message: message,
                    preferredStyle: UIAlertController.Style.alert)

        UIAlertControllerAdapter.instance?.appearance?.onAlertControllerCreated(alertCtrl: alert)
        
        return alert
    }
    
    public func addAction(
    _ title: String,
    style: UIAlertAction.Style = UIAlertAction.Style.default,
    handler: @escaping((UIAlertAction?) -> Void))
    {
        self.addAction(UIAlertAction(title: title, style: style, handler: handler))
    }
}


extension UIViewController
{
    public func showAlertController(
    _ type: AlertTitleType,
    message: String,
    confirm: ((UIAlertAction) -> Void)? = nil)
    {
        let alert = UIAlertController.createAlertCtrl(type, message: message)
        self.showAlertController(alert, confirm: confirm)
    }
    
    public func showAlertController(
    _ title: String,
    message: String,
    confirm: ((UIAlertAction) -> Void)? = nil)
    {
        let alert = UIAlertController.createAlertCtrl(title, message: message)
        self.showAlertController(alert, confirm: confirm)
    }
    
    public func showAlertController(
    _ alert: UIAlertController,
    confirm: ((UIAlertAction) -> Void)? = nil)
    {
        self.showConformAlertController(
            alert,
            buttonType: AlertButtonType.single(AlertButtonStyle(title: String.localizedString("OK"))),
            confirm: confirm)
    }
    
    public func showConformAlertController(
    _ type: AlertTitleType,
    message: String,
    buttonType: AlertButtonType = .yes_no,
    confirm: ((UIAlertAction) -> Void)?,
    reject: ((UIAlertAction) -> Void)? = nil)
    {
        let alert = UIAlertController.createAlertCtrl(type, message: message)
        self.showConformAlertController(alert, buttonType: buttonType, confirm: confirm, reject: reject)
    }
    
    public func showConformAlertController(
    _ alert: UIAlertController,
    buttonType: AlertButtonType = .yes_no,
    confirm: ((UIAlertAction) -> Void)?,
    reject: ((UIAlertAction) -> Void)? = nil)
    {
        var buttons = [AlertButtonStyle]()
        
        switch buttonType
        {
            case .yes_no:
                buttons.append(AlertButtonStyle(title: "YES"))
                buttons.append(AlertButtonStyle(title: "NO"))
                break
            
            case .confirm_cancel:
                buttons.append(AlertButtonStyle(title: "CONFIRM"))
                buttons.append(AlertButtonStyle(title: "CANCEL"))
                break
            
            case let .twice(button1, button2):
                buttons.append(button1)
                buttons.append(button2)
                break
            
            case let .single(button):
                buttons.append(button)
                break
        }
        
        
        for (i, button) in buttons.enumerated()
        {
            alert.addAction(
            String.localizedString(button.title),
            style: button.style,
            handler:
            {
                (UIAlertAction) -> Void in
                
                switch i
                {
                    case 0:
                        confirm?(UIAlertAction!)
                        break
                    
                    case 1:
                        reject?(UIAlertAction!)
                        break
                    
                    default:
                        break
                }
            })
        }

        self.present(alert, animated: true, completion: nil)
    }
}
