//
//  UIExtendedStackView.swift
//  UtilToolKit
//
//  Created by xattacker on 2020/5/30.
//  Copyright © 2020 xattacker. All rights reserved.
//

import UIKit


open class UIExtendedStackView: UIStackView
{
    var validBackgroundView: UIView?
    
    public required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.checkBackgroundColor()
    }
    
    @IBInspectable public override var backgroundColor: UIColor?
    {
        set
        {
            self.validBackgroundColor = newValue
        }
        get
        {
            return self.validBackgroundColor
        }
    }
    
    @IBInspectable public var validBackgroundColor: UIColor?
    {
        didSet
        {
            self.checkBackgroundColor()
        }
    }
    
    private func checkBackgroundColor()
    {
        if self.validBackgroundView != nil
        {
            self.validBackgroundView?.backgroundColor = self.validBackgroundColor
        }
        else if let color = self.validBackgroundColor
        {
            self.validBackgroundView = UIView(frame: self.bounds)
            self.validBackgroundView?.backgroundColor = color
            self.validBackgroundView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.setupSubView(self.validBackgroundView!)
            self.sendSubviewToBack(self.validBackgroundView!)
        }
    }
    
    deinit
    {
        self.validBackgroundView = nil
    }
}
