//
//  UIFlippableGridView.swift
//  Bingo
//
//  Created by xattacker on 2020/12/10.
//  Copyright © 2020 xattacker. All rights reserved.
//

import UIKit


class UIFlippableGridView: UIFlippableView
{
    private let gridView: UIGridView = UIGridView()
    
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
        let back_frame = UIView()
        back_frame.backgroundColor = UIColor.gray
        
        self.setupFlipView(back_frame, opposite: self.gridView)
        
        self.backgroundColor = .gray
    }
}


extension UIFlippableGridView: BingoGridViewProtocol
{
    var type: PlayerType
    {
        get
        {
            return self.gridView.type
        }
        set
        {
            self.gridView.type = newValue
        }
    }
    
    var value: Int
    {
        get
        {
            return self.gridView.value
        }
        set
        {
            self.gridView.value = newValue
        }
    }
    
    var isSelected: Bool
    {
        get
        {
            return self.gridView.isSelected
        }
        set
        {
            if self.gridView.isSelected != newValue && newValue == true
            {
                self.flip()
            }
            
            self.gridView.isSelected = newValue
        }
    }
    
    var isConnected: Bool
    {
        get
        {
            return self.gridView.isConnected
        }
        set
        {
            self.gridView.isConnected = newValue
        }
    }
    
    func initial()
    {
        self.gridView.initial()
        
        if self.isFlipped
        {
            self.flip(false)
        }
        
        //print("x: \(self.locX), y:\(self.locY) isFlipped \(self.isFlipped)")
    }
    
    func isLineConnected(direction: ConnectedDirection) -> Bool
    {
        self.gridView.isLineConnected(direction: direction)
    }
    
    func setConnectedLine(direction: ConnectedDirection, connected: Bool)
    {
        self.gridView.setConnectedLine(direction: direction, connected: connected)
    }

    var locX: Int
    {
        get
        {
            return self.gridView.locX
        }
        set
        {
            self.gridView.locX = newValue
        }
    }
    
    var locY: Int
    {
        get
        {
            return self.gridView.locY
        }
        set
        {
            self.gridView.locY = newValue
        }
    }
    
    var clicked: ((BingoGrid, Int, Int) -> Void)?
    {
        get
        {
            return self.gridView.clicked
        }
        set
        {
            self.gridView.clicked = newValue
        }
    }
}
