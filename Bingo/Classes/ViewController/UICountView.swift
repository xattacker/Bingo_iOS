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
        
        
        let offset = rect.size.width / 10
        
        context.setStrokeColor(UIColor.blue.cgColor)
        context.setLineWidth(offset)
        context.setLineJoin(CGLineJoin.round)
        
        if self.count >= 1
        {
            context.beginPath()
            context.move(to: CGPoint(x: offset, y: offset))
            context.addLine(to: CGPoint(x: rect.width - offset, y: offset))
            context.closePath()
            context.drawPath(using: CGPathDrawingMode.stroke)
        }

        if self.count >= 2
        {
            context.beginPath()
            context.move(to: CGPoint(x: rect.width/2, y: offset))
            context.addLine(to: CGPoint(x: rect.width/2, y: rect.height - offset))
            context.closePath()
            context.drawPath(using: CGPathDrawingMode.stroke)
        }

        if self.count >= 3
        {
            context.beginPath()
            context.move(to: CGPoint(x: rect.width/2, y: rect.height/2))
            context.addLine(to: CGPoint(x: rect.width - offset, y: rect.height/2))
            context.closePath()
            context.drawPath(using: CGPathDrawingMode.stroke)
        }

        if self.count >= 4
        {
            context.beginPath()
            context.move(to: CGPoint(x: rect.width/4, y: (rect.height/2) - offset))
            context.addLine(to: CGPoint(x: rect.width/4, y: rect.height - offset))
            context.closePath()
            context.drawPath(using: CGPathDrawingMode.stroke)
        }

        if self.count >= 5
        {
            context.beginPath()
            context.move(to: CGPoint(x: offset/2, y: rect.height - offset))
            context.addLine(to: CGPoint(x: rect.width - offset/2, y: rect.height - offset))
            context.closePath()
            context.drawPath(using: CGPathDrawingMode.stroke)
        }
    }
}
