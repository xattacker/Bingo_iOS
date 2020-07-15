//
//  UIGridView.swift
//  Bingo
//
//  Created by xattacker on 2020/7/14.
//  Copyright © 2020 xattacker. All rights reserved.
//

import UIKit


class UIGridView: UILabel, BingoGrid
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
        }
    }
    
    var locX: Int = 0
    var locY: Int = 0
    var clicked: ((_ grid: UIGridView) -> Void)? = nil
    
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
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let _ = touches.first else
        {
            return
        }
        
        
        self.clicked?(self)
    }
    
    func initial()
    {
        self.isConnected = false
        self.isSelected = false

        for i in 0 ... self.directions.count - 1
        {
            self.directions[i] = false
        }

        self.value = self.type == .computer ? self.locX * 5 + (self.locY + 1) : 0
    }
    
    func isLineConnected(direction: ConnectedDirection) -> Bool
    {
        return false
    }
    
    func setConnectedLine(direction: ConnectedDirection, connected: Bool)
    {
        
    }
    
    deinit
    {
        self.clicked = nil
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
