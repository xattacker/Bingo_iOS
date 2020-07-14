//
//  UIView.swift
//  UtilToolKit
//
//  Created by tao on 2016/7/18.
//  Copyright © 2016年 xattacker. All rights reserved.
//

import UIKit


extension UIView // create related
{
    public class func createView<T: UIView>(_ nibName: String? = nil) -> T?
    {
        let view = Bundle.main.loadNibNamed(
                   nibName ?? className,
                   owner: self,
                   options: nil)?.first as? T

        return view
    }

    public func createToolBar(
    _ done: (text: String, action: Selector),
    cancel: (text: String, action: Selector)? = nil,
    barColor: UIColor? = nil,
    barTextColor: UIColor = UIColor.white) -> UIToolbar
    {
        let rect = AppProperties.screenSize

        let bar = UIToolbar(frame: CGRect(x: 0, y: 0, width: rect.size.width, height: 40))
        bar.barStyle = UIBarStyle.black
        bar.barTintColor = barColor
        
        var items = [UIBarButtonItem]()
        
        if let cancel = cancel
        {
            let cancel_item = UIBarButtonItem(
                                title: cancel.text,
                                style: UIBarButtonItem.Style.done,
                                target: self,
                                action: cancel.action)
            cancel_item.tintColor = barTextColor
            items.append(cancel_item)
        }

        // add a UIBarButtonSystemItemFlexibleSpace item to make item right alignment
        let space_left = UIBarButtonItem(
                            barButtonSystemItem:
                            UIBarButtonItem.SystemItem.flexibleSpace,
                            target: nil,
                            action: nil)
        items.append(space_left)
        
        let done_item = UIBarButtonItem(
                            title: done.text,
                            style: UIBarButtonItem.Style.done,
                            target: self,
                            action: done.action)
        done_item.tintColor = barTextColor
        items.append(done_item)

        bar.items = items
        bar.autoresizingMask = UIView.AutoresizingMask.flexibleHeight
        
        return bar
    }
    
    public func createKeyboardToolBar(
    _ buttonText: String = NSLocalizedString("DONE", comment: ""),
    action: Selector,
    barColor: UIColor? = nil) -> UIToolbar
    {
        return self.createToolBar((text: buttonText, action: action), barColor: barColor)
    }
    
    public func createBoardPickerView() -> UIPickerView
    {
        let rect = AppProperties.screenSize
        let picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: rect.size.width, height: 216))
        picker.showsSelectionIndicator = true
        
        if self.isDarkStyle
        {
            if #available(iOS 13.0, *)
            {
                picker.backgroundColor = UIColor.systemBackground
            }
        }
        else
        {
            picker.backgroundColor = UIColor.white
        }

        return picker
    }
    
    public func createBoardDatePicker() -> UIDatePicker
    {
        let rect = AppProperties.screenSize
        let picker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: rect.size.width, height: 216))
        picker.datePickerMode = UIDatePicker.Mode.date

        if self.isDarkStyle
        {
            if #available(iOS 13.0, *)
            {
                picker.backgroundColor = UIColor.systemBackground
            }
        }
        else
        {
            picker.backgroundColor = UIColor.white
        }
        
        return picker
    }
    
    public func saveToImage(
    _ rect: CGRect,
    storedPath: String,
    completed: ((_ image: UIImage) -> Void)? = nil) -> Bool
    {
        var result = false
        
        UIGraphicsBeginImageContext(rect.size)
        
        if let context = UIGraphicsGetCurrentContext()
        {
            context.concatenate(CGAffineTransform(translationX: -rect.origin.x, y: -rect.origin.y))
            self.layer.render(in: context)
            
            if let img = UIGraphicsGetImageFromCurrentImageContext(),
               let data = img.pngData()
            {
                do
                {
                    try data.write(to: URL(fileURLWithPath: storedPath), options: [.atomic])
                    completed?(img)
                    
                    result = true
                }
                catch
                {
                }
            }
        }
        
        UIGraphicsEndImageContext()
        
        return result
    }
}


extension UIView
{
    public var isDarkStyle: Bool
    {
        return AppProperties.userInterfaceStyle == .dark
    }
    
    public func setupSubView(_ subView: UIView, safeArea: Bool = false)
    {
        subView.translatesAutoresizingMaskIntoConstraints = false // we should set it to false before add constraint
        self.addSubview(subView)
        self.setupSubViewConstraints(subView, safeArea: safeArea)
    }
    
    public func setupSubViewInCenter(_ subView: UIView)
    {
        subView.translatesAutoresizingMaskIntoConstraints = false // we should set it to false before add constraint
        self.addSubview(subView)
        
        let x_const = NSLayoutConstraint(
                        item: subView,
                        attribute: NSLayoutConstraint.Attribute.centerX,
                        relatedBy: NSLayoutConstraint.Relation.equal,
                        toItem: self,
                        attribute: NSLayoutConstraint.Attribute.centerX,
                        multiplier: 1,
                        constant: 0)
        self.addConstraint(x_const)
        
        let y_const = NSLayoutConstraint(
                        item: subView,
                        attribute: NSLayoutConstraint.Attribute.centerY,
                        relatedBy: NSLayoutConstraint.Relation.equal,
                        toItem: self,
                        attribute: NSLayoutConstraint.Attribute.centerY,
                        multiplier: 1,
                        constant: 0)
        self.addConstraint(y_const)
    }
    
    public func setupSubViewConstraints(_ subView: UIView, safeArea: Bool = false)
    {
        if #available(iOS 11.0, *), safeArea
        {
            self.setupConstraints(subView, to: self.safeAreaLayoutGuide)
        }
        else
        {
            self.setupConstraints(subView, to: self)
        }
    }

    public func scale(_ ratio: CGFloat)
    {
        self.transform = CGAffineTransform(scaleX: ratio, y: ratio)
    }
    
    public func widthRatio(_ ratio: CGFloat) -> CGFloat
    {
        return self.frame.size.width * ratio
    }
    
    public func heightRatio(_ ratio: CGFloat) -> CGFloat
    {
        return self.frame.size.height * ratio
    }
    
    public func shortWidthRatio(_ ratio: CGFloat) -> CGFloat
    {
        return (self.frame.size.width > self.frame.size.height ? self.frame.size.height : self.frame.size.width) * ratio
    }
    
    public func convertLocalizedString(_ recursive: Bool = true)
    {
        self.convertLocalizedString(recursive, view: self)
    }
    
    public var isScrolling: Bool
    {
        if let scrollView = self as? UIScrollView
        {
            if scrollView.isDragging || scrollView.isDecelerating
            {
                return true
            }
        }
        
        for sub in self.subviews
        {
            if sub.isScrolling
            {
                return true
            }
        }
        
        return false
    }
    
    public func addGradientBackground(_ colors: CGColor...)
    {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colors
        self.layer.insertSublayer(gradient, at: 0)
    }

    private func setupConstraints(_ from: Any, to: Any)
    {
        let leading_const = NSLayoutConstraint(
                            item: from,
                            attribute: NSLayoutConstraint.Attribute.leading,
                            relatedBy: NSLayoutConstraint.Relation.equal,
                            toItem: to,
                            attribute: NSLayoutConstraint.Attribute.leading,
                            multiplier: 1,
                            constant: 0)
        self.addConstraint(leading_const)
        
        let trailing_const = NSLayoutConstraint(
                             item: to,
                             attribute: NSLayoutConstraint.Attribute.trailing,
                             relatedBy: NSLayoutConstraint.Relation.equal,
                             toItem: from,
                             attribute: NSLayoutConstraint.Attribute.trailing,
                             multiplier: 1,
                             constant: 0)
        self.addConstraint(trailing_const)
        
        let bottom_const = NSLayoutConstraint(
                           item: to,
                           attribute: NSLayoutConstraint.Attribute.bottom,
                           relatedBy: NSLayoutConstraint.Relation.equal,
                           toItem: from,
                           attribute: NSLayoutConstraint.Attribute.bottom,
                           multiplier: 1,
                           constant: 0)
        self.addConstraint(bottom_const)
        
        let top_const = NSLayoutConstraint(
                        item: from,
                        attribute: NSLayoutConstraint.Attribute.top,
                        relatedBy: NSLayoutConstraint.Relation.equal,
                        toItem: to,
                        attribute: NSLayoutConstraint.Attribute.top,
                        multiplier: 1,
                        constant: 0)
        self.addConstraint(top_const)
    }

    private func convertLocalizedString(_ recursive: Bool, view: UIView)
    {
        view.convertSelfLocalizedString()
        
        if view.subviews.count > 0
        {
            for sub in view.subviews
            {
                if recursive
                {
                    self.convertLocalizedString(recursive, view: sub)
                }
            }
        }
    }
    
    private func convertSelfLocalizedString()
    {
        switch self
        {
            case let label as UILabel:
                if let str = label.text, str.length > 0
                {
                    label.text = NSLocalizedString(str, comment: "")
                }
                break
            
            case let button as UIButton:
                if let str = button.titleLabel?.text, str.length > 0
                {
                    button.setTitle(NSLocalizedString(str, comment: ""), for: UIControl.State.normal)
                }
                break
            
            case let field as UITextField:
                if let str = field.placeholder, str.length > 0
                {
                    field.placeholder = NSLocalizedString(str, comment: "")
                }
                break
            
            case let segment as UISegmentedControl:
                for i in 0 ..< segment.numberOfSegments
                {
                    if let str = segment.titleForSegment(at: i), str.length > 0
                    {
                        segment.setTitle(NSLocalizedString(str, comment: ""), forSegmentAt: i)
                    }
                }
                break
            
            default:
                break
        }
    }
}


extension UIView // border related
{
    @IBInspectable public var layerBorderColor: UIColor?
    {
        get
        {
            return self.layer.borderColor?.toUIColor()
        }
        set
        {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable public var layerBorderWidth: CGFloat
    {
        get
        {
            return self.layer.borderWidth
        }
        set
        {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable public var layerCornerRadius: CGFloat
    {
        get
        {
            return self.layer.cornerRadius
        }
        set
        {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = newValue > 0 //屬性若被設置為true，會將超過邊筐外的sublayers裁切掉
        }
    }

    public func enableCircleRound()
    {
        self.layer.cornerRadius = self.frame.size.width/2
        self.layer.masksToBounds = true //屬性若被設置為true，會將超過邊筐外的sublayers裁切掉
    }
    
    public func setLayerCorner(
    topLeft: Bool = true,
    topRight: Bool = true,
    bottomLeft: Bool = true,
    bottomRight: Bool = true)
    {
        if #available(iOS 11.0, *)
        {
            var corners: CACornerMask = []
            
            if topLeft
            {
                corners.insert(.layerMinXMinYCorner)
            }
            
            if topRight
            {
                corners.insert(.layerMaxXMinYCorner)
            }
            
            if bottomLeft
            {
                corners.insert(.layerMinXMaxYCorner)
            }
            
            if bottomRight
            {
                corners.insert(.layerMaxXMaxYCorner)
            }
            
            self.layer.maskedCorners = corners
        }
        else
        {
            var corners: UIRectCorner = []
            
            if topLeft
            {
                corners.insert(.topLeft)
            }
            
            if topRight
            {
                corners.insert(.topRight)
            }
            
            if bottomLeft
            {
                corners.insert(.bottomLeft)
            }
            
            if bottomRight
            {
                corners.insert(.bottomRight)
            }
            
            let radius = self.layerCornerRadius
            self.layerCornerRadius = 0
            
            let path = UIBezierPath(
                        roundedRect: self.bounds,
                        byRoundingCorners: corners,
                        cornerRadii: CGSize(width: radius, height: radius))
            
            let maskLayer = CAShapeLayer()
            maskLayer.strokeColor = self.layerBorderColor?.cgColor
            maskLayer.lineWidth = self.layerBorderWidth
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        }
    }
}


extension UIView
{
    @IBInspectable public var shadowColor: UIColor?
    {
        get
        {
            return self.layer.shadowColor?.toUIColor()
        }
        set
        {
            self.layer.shadowColor = newValue?.cgColor
        }
    }
    
    @IBInspectable public var shadowOffset: CGSize
    {
        get
        {
            return self.layer.shadowOffset
        }
        set
        {
            self.layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable public var shadowOpacity: Float
    {
        get
        {
            return self.layer.shadowOpacity
        }
        set
        {
            self.layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable public var shadowRadius: CGFloat
    {
        get
        {
            return self.layer.shadowRadius
        }
        set
        {
            self.layer.shadowRadius = newValue
            self.layer.masksToBounds = newValue == 0 //屬性若被設置為true，會將超過邊筐外的sublayers裁切掉
        }
    }
}
