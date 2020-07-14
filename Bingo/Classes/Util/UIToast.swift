//
//  UIToast.swift
//  UtilToolKit
//
//  Created by xattacker on 2016/1/14.
//  Copyright © 2016年 xattacker. All rights reserved.
//

import UIKit


public enum ToastDuration: Int
{
    case short  = 1
    case normal = 3
    case long   = 10
}

public enum ToastGravity: Int
{
    case top_center    = 1
    case top_right     = 2
    case center        = 3
    case bottom_center = 4
    case bottom_right  = 5
}


public final class UIToast: NSObject
{
    public static var yOffset: CGFloat = 0
    public static var font: UIFont = UIFont.boldSystemFont(ofSize: 15)
    public static var align: NSTextAlignment = NSTextAlignment.center
    
    private var text: String
    private var view: UIButton
    private var duration: ToastDuration = .normal
    
    init(text: String)
    {
        self.text = text
        self.view = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    public class func show(_ text: String, duration: ToastDuration = .normal, gravity: ToastGravity = .bottom_center)
    {
        let toast = UIToast(text: text)
        toast.initView()
        toast.duration = duration

        if UIToast.yOffset == 0
        {
            UIToast.yOffset = AppProperties.screenSize.size.width / 5
        }
  
        toast.show(gravity)
    }

    // release static resource
    public class func releaseResource()
    {
        UIToast.yOffset = 0
        UIToast.align = NSTextAlignment.center
    }
    
    // notification callback function could not set private
    @objc func deviceOrientationDidChanged()
    {
        self.hideAnimation()
    }
    
    @objc func toastTaped()
    {
        self.hideAnimation()
    }
    
    @objc func dismissToast()
    {
        self.view.removeFromSuperview()
    }
    
    func showAnimation()
    {
        UIView.beginAnimations("show", context: nil)
        UIView.setAnimationCurve(UIView.AnimationCurve.easeIn)
        UIView.setAnimationDuration(TimeInterval(0.3))

        self.view.alpha = 1
        
        UIView.commitAnimations()
    }
    
    @objc func hideAnimation()
    {
        UIView.beginAnimations("hide", context: nil)
        UIView.setAnimationCurve(UIView.AnimationCurve.easeOut)
        UIView.setAnimationDelegate(self)
        UIView.setAnimationDidStop(#selector(UIToast.dismissToast))
        UIView.setAnimationDuration(TimeInterval(0.3))
        
        self.view.alpha = 0
        
        UIView.commitAnimations()
    }
    
    @discardableResult
    private func show(_ gravity: ToastGravity) -> Bool
    {
        guard let window = UIApplication.shared.keyWindow else
        {
            return false
        }

        
        let orientation = AppProperties.getOSVersion() >= 8 ? UIInterfaceOrientation.portrait : AppProperties.getOrientation()

        switch gravity
        {
            case .top_center:
                switch orientation
                {
                    case .landscapeLeft:
                        self.view.center = CGPoint(x: UIToast.yOffset + self.view.frame.size.height/2, y: window.center.y)
                        break
                    
                    case .landscapeRight:
                        self.view.center = CGPoint(
                                           x: window.center.y,
                                           y: window.frame.size.width - (UIToast.yOffset + self.view.frame.size.height/2))
                        break
                    
                    case .portrait:
                        self.view.center = CGPoint(x: window.center.x, y: UIToast.yOffset + self.view.frame.size.height/2)
                        break
                        
                    case .portraitUpsideDown:
                        self.view.center = CGPoint(
                                           x: window.center.x,
                                           y: window.frame.size.height - (UIToast.yOffset + self.view.frame.size.height/2))
                        break
                        
                    default:
                        break
                }
                break

            case .top_right:
                switch orientation
                {
                    case .landscapeLeft:
                        self.view.center = CGPoint(
                                           x: UIToast.yOffset + self.view.frame.size.height/2,
                                           y: window.center.y - window.frame.size.height/2 +  self.view.frame.size.width/2 + 10)
                        break
                        
                    case .landscapeRight:
                        self.view.center = CGPoint(
                                           x: window.frame.size.width - (UIToast.yOffset + self.view.frame.size.height/2),
                                           y: window.frame.size.height - (self.view.frame.size.width/2 + 10))
                        break
                        
                    case .portrait:
                        self.view.center = CGPoint(
                                           x: window.frame.size.width - (self.view.frame.size.width/2 + 10),
                                           y: UIToast.yOffset + self.view.frame.size.height/2)
                        break
                        
                    case .portraitUpsideDown:
                        self.view.center = CGPoint(
                                           x: self.view.frame.size.width/2 + 10,
                                           y: window.frame.size.height - (UIToast.yOffset + self.view.frame.size.height/2))
                        break
                        
                    default:
                        break
                }
                break
            
            case .center:
                self.view.center = window.center
                break
                
            case .bottom_right:
                switch orientation
                {
                    case .landscapeLeft:
                        self.view.center = CGPoint(
                                           x: window.frame.size.width - (UIToast.yOffset + self.view.frame.size.height/2),
                                           y: window.center.y - window.frame.size.height/2 +  self.view.frame.size.width/2 + 10)
                        break
                        
                    case .landscapeRight:
                        self.view.center = CGPoint(
                                           x: UIToast.yOffset + self.view.frame.size.height/2,
                                           y: window.frame.size.height - (self.view.frame.size.width/2 + 10))
                        break
                        
                    case .portrait:
                        self.view.center = CGPoint(
                                           x: window.frame.size.width - (self.view.frame.size.width/2 + 10),
                                           y: window.frame.size.height - (UIToast.yOffset + self.view.frame.size.height/2))
                        break
                        
                    case .portraitUpsideDown:
                        self.view.center = CGPoint(x: self.view.frame.size.width/2 + 10, y: UIToast.yOffset + self.view.frame.size.height/2)
                        break
                        
                    default:
                        break
                }
                break
            
            case .bottom_center:
                switch orientation
                {
                    case .landscapeLeft:
                        self.view.center = CGPoint(
                                           x: window.frame.size.width - (UIToast.yOffset + self.view.frame.size.height/2),
                                           y: window.center.y)
                        break
                        
                    case .landscapeRight:
                        self.view.center = CGPoint(x: UIToast.yOffset + self.view.frame.size.height/2, y: window.center.y)
                        break
                        
                    case .portrait:
                        self.view.center = CGPoint(
                                           x: window.center.x,
                                           y: window.frame.size.height - (UIToast.yOffset + self.view.frame.size.height/2))
                        break
                        
                    case .portraitUpsideDown:
                        self.view.center = CGPoint(
                                           x: window.center.x,
                                           y: window.frame.size.height - (UIToast.yOffset + self.view.frame.size.height/2))
                        break
                        
                    default:
                        break
                }
                break
        }

        window.addSubview(self.view)
        
        self.showAnimation()
        self.perform(#selector(UIToast.hideAnimation), with: nil, afterDelay: Double(self.duration.rawValue))
        
        return true
    }
    
    private func initView()
    {
        let ns_str = self.text as NSString
        let text_size = ns_str.boundingRect(
                        with: CGSize(width: 280, height: 0),
                        options: NSStringDrawingOptions.usesLineFragmentOrigin,
                        attributes: [NSAttributedString.Key.font: UIToast.font],
                        context: nil).size
        
        let padding = CGFloat(12)
        
        let label = UILabel(
                    frame: CGRect(
                    x: UIToast.align == NSTextAlignment.left ?
                       padding/2 :
                       UIToast.align == NSTextAlignment.right ? -padding/2 : 0,
                    y: 0,
                    width: text_size.width + padding,
                    height: text_size.height + padding))
        
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.textAlignment = UIToast.align
        label.font = UIToast.font
        label.text = text
        label.numberOfLines = 0

        self.view.frame = CGRect(x: 0, y: 0, width: label.frame.size.width, height: label.frame.size.height)
        self.view.layer.cornerRadius = 5
        self.view.layer.borderWidth = 1
        self.view.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        self.view.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.9)
        self.view.alpha = 0
        self.view.addSubview(label)
        self.view.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight, UIView.AutoresizingMask.flexibleWidth]
        self.view.addTarget(self, action: #selector(UIToast.toastTaped), for: UIControl.Event.touchDown)
        
        if AppProperties.userInterfaceStyle == .dark
        {
            label.textColor = UIColor.darkGray
            self.view.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        }
        
        NotificationCenter.default.addObserver(
        self,
        selector: #selector(UIToast.deviceOrientationDidChanged),
        name: UIDevice.orientationDidChangeNotification,
        object: nil)
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(
        self,
        name: UIDevice.orientationDidChangeNotification,
        object: nil)
    }
}
