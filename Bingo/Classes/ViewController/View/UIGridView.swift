//
//  UIGridView.swift
//  Bingo
//
//  Created by xattacker on 2020/7/14.
//  Copyright © 2020 xattacker. All rights reserved.
//

import UIKit
import RxSwift


class UIGridView: UILabel, BingoGridView
{
    var type: PlayerType = PlayerType.computer
    
    var value: Int = -1
    {
        didSet
        {
            self.text = self.value > 0 ? self.value.toString() : ""
            self.updateBackgroundColor()
        }
    }
    
    var isSelected: Bool = false
    {
        didSet
        {
            self.updateBackgroundColor()
        }
    }
    
    var isConnected: Bool = false
    {
        didSet
        {
            self.updateBackgroundColor()
            self.setNeedsDisplay()
        }
    }
    
    var locX: Int = 0
    var locY: Int = 0
    
    var clicked: Observable<BingoGridView?>
    {
        get
        {
            return self.clickedSubject.asObservable()
        }
    }
    
    private var clickedSubject: BehaviorSubject<BingoGridView?> = BehaviorSubject(value: nil)
    private var directions: [Bool] = [false, false, false, false]
    
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
    
    public override func draw(_ rect: CGRect)
    {
        super.draw(rect)
        
        if !self.isConnected
        {
            return
        }
        
        guard let context = UIGraphicsGetCurrentContext() else
        {
            return
        }
        
        
        context.setStrokeColor(UIColor(hexString: "#400000FF").cgColor)
        context.setLineWidth(1.5)
        
        for (index, connected) in self.directions.enumerated()
        {
            if connected, let dir = ConnectedDirection(rawValue: index)
            {
                switch dir
                {
                    case .leftTop_rightBottom:
                        context.beginPath()
                        context.move(to: CGPoint.zero)
                        context.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
                        context.closePath()
                        context.drawPath(using: CGPathDrawingMode.stroke)
                        break
                        
                    case .rightTop_leftBottom:
                        context.beginPath()
                        context.move(to: CGPoint(x: self.frame.size.width, y: 0))
                        context.addLine(to: CGPoint(x: 0, y: self.frame.size.height))
                        context.closePath()
                        context.drawPath(using: CGPathDrawingMode.stroke)
                        break
                    
                    case .horizontal:
                        context.beginPath()
                        context.move(to: CGPoint(x: 0, y: self.frame.size.height/2))
                        context.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height/2))
                        context.closePath()
                        context.drawPath(using: CGPathDrawingMode.stroke)
                        break
                    
                    case .vertical:
                        context.beginPath()
                        context.move(to: CGPoint(x: self.frame.size.width/2, y: 0))
                        context.addLine(to: CGPoint(x: self.frame.size.width/2, y: self.frame.size.height))
                        context.closePath()
                        context.drawPath(using: CGPathDrawingMode.stroke)
                        break
                        
                    default:
                        break
                }
            }
        }
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let _ = touches.first else
        {
            return
        }
        
        self.clickedSubject.onNext(self)
    }
    
    func initial()
    {
        for i in 0 ... self.directions.count - 1
        {
            self.directions[i] = false
        }

        self.isConnected = false
        self.isSelected = false
        self.value = 0
    }
    
    func isLineConnected(direction: ConnectedDirection) -> Bool
    {
        return self.directions[direction.rawValue]
    }
    
    func setConnectedLine(direction: ConnectedDirection, connected: Bool)
    {
        self.directions[direction.rawValue] = connected

        if !connected
        {
            self.isConnected = self.directions.first(
                                    where: { (existed: Bool) -> Bool in
                                    return existed
                                }) == true
        }
        else
        {
            self.isConnected = connected
        }
    }
}


extension UIGridView
{
    private func initView()
    {
        self.isUserInteractionEnabled = true
        self.textColor = UIColor.black
        self.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.callout)
        self.textAlignment = .center
        
        self.layerBorderColor = UIColor.darkGray
        self.layerBorderWidth = 1
        self.layerCornerRadius = 0
    }
    
    private func updateBackgroundColor()
    {
        self.textColor = UIColor.black
        
        if self.isConnected
        {
            self.backgroundColor = .red
        }
        else if self.isSelected
        {
            self.backgroundColor = .yellow
        }
        else if self.value != 0 && self.type == PlayerType.player
        {
            self.backgroundColor = .lightGray
        }
        else
        {
            if self.type == PlayerType.computer
            {
                self.textColor = UIColor.clear
            }

            self.backgroundColor = .gray
        }
    }
}
