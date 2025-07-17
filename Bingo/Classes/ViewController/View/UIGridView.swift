//
//  UIGridView.swift
//  Bingo
//
//  Created by xattacker on 2020/7/14.
//  Copyright © 2020 xattacker. All rights reserved.
//

import UIKit
import RxSwift


final class UIGridView: UILabel, BingoGridView
{
    var type: PlayerType = PlayerType.none
    
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
    
    var clicked: Observable<BingoGridView>
    {
        return self.clickedSubject.asObservable()
    }
    
    private var clickedSubject: PublishSubject<BingoGridView> = PublishSubject()
    
    private var directions: [Bool] = [false, false, false, false]
    private var directionLayer = CAShapeLayer()
    
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
    
    public override func layoutSubviews()
    {
        super.layoutSubviews()
        
        self.directionLayer.frame = self.bounds
        self.updateDirLayerPath()
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let _ = touches.first else
        {
            return
        }
        
        self.clickedSubject.onNext(self)
    }
    
    subscript(direction: ConnectedDirection) -> Bool
    {
        get
        {
            return self.directions[direction.rawValue]
        }
        set
        {
            self.directions[direction.rawValue] = newValue

            if !newValue
            {
                self.isConnected = self.directions.first(
                                        where: { (existed: Bool) -> Bool in
                                        return existed
                                    }) == true
            }
            else
            {
                self.isConnected = newValue
            }
            
            self.updateDirLayerPath()
        }
    }
    
    func initial()
    {
        for i in 0 ..< self.directions.count
        {
            self.directions[i] = false
        }

        self.isConnected = false
        self.isSelected = false
        self.value = 0
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
        
        self.directionLayer.strokeColor = UIColor(hexString: "#400000FF").cgColor
        self.directionLayer.lineWidth = 2.4
        self.directionLayer.fillColor = nil
        self.directionLayer.lineCap = .square
        self.layer.addSublayer(self.directionLayer)
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
    
    private func updateDirLayerPath()
    {
        let path = UIBezierPath()
        let w = self.bounds.width
        let h = self.bounds.height
        let offset: CGFloat = 1.8
        let angle_offset: CGFloat = 2.2
        
        for (index, connected) in directions.enumerated()
        {
            guard connected, let dir = ConnectedDirection(rawValue: index) else
            {
                continue
            }
            
            
            switch dir
            {
                case .leftTop_rightBottom:
                    path.move(to: CGPoint(x: -angle_offset, y: -angle_offset))
                    path.addLine(to: CGPoint(x: w + angle_offset, y: h + angle_offset))
                    
                case .rightTop_leftBottom:
                    path.move(to: CGPoint(x: w + angle_offset, y: -angle_offset))
                    path.addLine(to: CGPoint(x: -angle_offset, y: h + angle_offset))
                    
                case .horizontal:
                    path.move(to: CGPoint(x: -offset, y: h / 2))
                    path.addLine(to: CGPoint(x: w + offset, y: h / 2))
                    
                case .vertical:
                    path.move(to: CGPoint(x: w / 2, y: -offset))
                    path.addLine(to: CGPoint(x: w / 2, y: h + offset))
                    
                default:
                    break
            }
        }
        
        self.directionLayer.path = path.cgPath
    }
}
