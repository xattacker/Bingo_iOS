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
                self.resetAnimated()
            }
            else
            {
                let line = self.lineLayers[self.count - 1]
                line.animateStrokeEnd(0, to: 1)
            }
        }
    }
    
    @IBInspectable var countColor: UIColor = UIColor.blue
    {
        didSet
        {
            self.lineLayers.forEach { $0.strokeColor = self.countColor.cgColor }
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
    
    private func resetAnimated()
    {
        self.alpha = 1
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: [],
            animations:
            {
                [weak self] in
                self?.alpha = 0
            },
            completion:
            {
                [weak self]
                (finished: Bool) in
                self?.lineLayers.forEach { $0.animateStrokeEnd(0, to: 0, animated: false) }
                self?.alpha = 1
            })
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
    func animateStrokeEnd(_ from: CGFloat, to: CGFloat, animated: Bool = true)
    {
        CATransaction.begin()
        CATransaction.setDisableActions(!animated)
        
        self.strokeEnd = from
        self.strokeEnd = to
        
        CATransaction.commit()
    }
}
