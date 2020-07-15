//
//  UICountView.swift
//  Bingo
//
//  Created by xattacker on 2020/7/14.
//  Copyright © 2020 xattacker. All rights reserved.
//

import UIKit


class UICountView: UIView
{
    var count: Int = 0
    {
        didSet
        {
            self.setNeedsDisplay()
        }
    }
    
    public override func draw(_ rect: CGRect)
    {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else
        {
            return
        }
    }
}
