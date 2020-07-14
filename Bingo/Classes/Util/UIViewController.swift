//
//  UIViewController.swift
//  UtilToolKit
//
//  Created by xattacker on 2015/6/30.
//  Copyright (c) 2015年 xattacker. All rights reserved.
//

import UIKit


extension UIViewController
{
    public var isVisible: Bool
    {
        return self.isViewLoaded && self.view.window != nil
    }

    public var isDarkStyle: Bool
    {
        return AppProperties.userInterfaceStyle == .dark
    }

    public func present(_ ctrl: UIViewController, animated: Bool = true)
    {
        self.present(ctrl, animated: animated, completion: nil)
    }

    @discardableResult
    public func popViewController(_ animated: Bool = true) -> UIViewController?
    {
       return self.navigationController?.popViewController(animated: animated)
    }

    @discardableResult
    public func popViewController(_ animated: Bool = true, step: Int) -> UIViewController?
    {
        var ctrl: UIViewController?
        
        if let navi_ctrl = self.navigationController, navi_ctrl.viewControllers.count > step
        {
            let ctrls = navi_ctrl.viewControllers
            ctrl = ctrls[ctrls.count - step - 1]
            
            navi_ctrl.popToViewController(ctrl!, animated: animated)
        }
        
        return ctrl
    }
    
    @discardableResult
    public func popToRootViewController(_ animated: Bool = true) -> [UIViewController]?
    {
        return self.navigationController?.popToRootViewController(animated: animated)
    }
    
    public func dissmiss()
    {
        self.dismiss(animated: true)
    }
    
    public var swipeBackEnabled: Bool
    {
        get
        {
            return self.navigationController?.interactivePopGestureRecognizer?.isEnabled ?? false
        }
        set
        {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = newValue
        }
    }
}


extension UIViewController
{
    @discardableResult
    public func resignFirstResponderView(_ view: UIView? = nil) -> Bool
    {
        var result = false
        var view2 = view
        
        if view2 == nil
        {
            view2 = self.view
        }
        
        if let view2 = view2
        {
            for sub in view2.subviews
            {
                if sub.resignFirstResponder()
                {
                    result = true
                    
                    break
                }
                
                if sub.subviews.count > 0
                {
                    if self.resignFirstResponderView(sub)
                    {
                        result = true
                        
                        break
                    }
                }
            }
        }
        
        return result
    }
    
    public func convertLocalizedString()
    {
        self.view.convertLocalizedString(true)
    }
}
