//
//  CountViewProtocol.swift
//  Bingo
//
//  Created by xattacker on 2020/12/10.
//  Copyright © 2020 xattacker. All rights reserved.
//

import UIKit


protocol CountViewProtocol
{
    var count: Int { get set }
    var countColor: UIColor { get set }
}


extension CountViewProtocol
{
    var maxCount: Int
    {
        get
        {
            return 5
        }
    }
    
    mutating func reset()
    {
        self.count = 0
    }
}
