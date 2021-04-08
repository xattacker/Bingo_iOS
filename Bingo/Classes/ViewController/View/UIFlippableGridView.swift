//
//  UIFlippableGridView.swift
//  Bingo
//
//  Created by xattacker on 2020/12/10.
//  Copyright © 2020 xattacker. All rights reserved.
//

import UIKit
import RxSwift


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
        
        self.setupFlipView(back_frame, back: self.gridView)
        
        self.backgroundColor = .gray
    }
}


extension UIFlippableGridView: BingoGridView
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
                self.flip(duration: 0.35)
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

    subscript(direction: ConnectedDirection) -> Bool
    {
        get
        {
            return self.gridView[direction]
        }
        set
        {
            self.gridView[direction] = newValue
        }
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
    
    var clicked: Observable<BingoGridView>
    {
        return self.gridView.clicked
    }
    
    func initial()
    {
        self.gridView.initial()
        
        if self.isFlipped
        {
            self.flip(false)
        }
    }
}
