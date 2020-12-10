//
//  UIAnimatedCountView.swift
//  Bingo
//
//  Created by xattacker on 2020/12/10.
//  Copyright © 2020 xattacker. All rights reserved.
//

import UIKit


class UIAnimatedCountView: UIView, CountView
{
    private var lineLayers = [CAShapeLayer]()
    
    var count: Int = 0
    {
        didSet
        {
            if self.count > self.maxCount
            {
                return
            }
            
            if (self.count == 0)
            {
                self.isHidden = true
                
                for line in self.lineLayers
                {
                    //line.removeFromSuperlayer()
                    line.animateStrokeEnd(0, to: 0)
                   // self.layer.addSublayer(line)
                }
                
                self.delay(0.5) {
                    (mySelf: UIAnimatedCountView?) in
                    mySelf?.isHidden = false
                }
            }
            else
            {
                for (i, line) in self.lineLayers.enumerated()
                {
                    if i < self.count
                    {
                        line.animateStrokeEnd(0, to: 1)
                    }
                    else
                    {
                        line.animateStrokeEnd(1, to: 0)
                    }
                }
            }
        }
    }
    
    @IBInspectable var countColor: UIColor = UIColor.blue
    {
        didSet
        {
            for line in self.lineLayers
            {
                line.strokeColor = self.countColor.cgColor
            }
        }
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.initView()
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
        
        self.initView()
    }
    
    private func initView()
    {
        let line_width = self.frame.size.width/10
        let offset = self.frame.size.width/10
        let rect = self.frame.size
        
        for i in 0 ..< self.maxCount
        {
            let line = CAShapeLayer()
            line.fillColor = UIColor.clear.cgColor
            line.strokeColor = self.countColor.cgColor
            line.lineWidth = line_width
            //line.lineJoin = .round
            line.lineCap = .round
            self.lineLayers.append(line)
            
            switch i
            {
                case 0:
                    let path = UIBezierPath()
                    path.move(to: CGPoint(x: offset, y: offset))
                    path.addLine(to: CGPoint(x: rect.width - offset, y: offset))
                    line.path = path.cgPath
                    break
                    
                case 1:
                    let path = UIBezierPath()
                    path.move(to: CGPoint(x: rect.width/2, y: offset))
                    path.addLine(to: CGPoint(x: rect.width/2, y: rect.height - offset))
                    line.path = path.cgPath
                    break
                    
                case 2:
                    let path = UIBezierPath()
                    path.move(to: CGPoint(x: rect.width/2, y: rect.height/2))
                    path.addLine(to: CGPoint(x: rect.width - offset, y: rect.height/2))
                    line.path = path.cgPath
                    break
                    
                case 3:
                    let path = UIBezierPath()
                    path.move(to: CGPoint(x: rect.width/4, y: (rect.height/2) - (offset/2)))
                    path.addLine(to: CGPoint(x: rect.width/4, y: rect.height - offset))
                    line.path = path.cgPath
                    break
                    
                case 4:
                    let path = UIBezierPath()
                    path.move(to: CGPoint(x: offset/2, y: rect.height - offset))
                    path.addLine(to: CGPoint(x: rect.width - offset/2, y: rect.height - offset))
                    line.path = path.cgPath
                    break
                    
                default:
                    break
            }

            self.layer.insertSublayer(line, at: 0)
        }
    }
    
    deinit
    {
        self.lineLayers.removeAll()
    }
}


// MARK:- CAShapeLayer Stroke animation
internal extension CAShapeLayer
{
    func animateStrokeEnd(_ from: CGFloat, to: CGFloat)
    {
        self.strokeEnd = from
        self.strokeEnd = to
    }
}
