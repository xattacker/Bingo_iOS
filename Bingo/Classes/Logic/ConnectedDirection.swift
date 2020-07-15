//
//  ConnectedDirection.swift
//  Bingo
//
//  Created by xattacker on 2020/7/14.
//  Copyright © 2020 xattacker. All rights reserved.
//

import Foundation


// 連線方向定義
enum ConnectedDirection: Int
{
    case null  = -1 // 無方向

    case leftTop_rightBottom = 0 // 左上向右下
    case rightTop_leftBottom = 1 // 右上向左下
    case horizontal = 2 // 橫向
    case vertical = 3 // 直向
    
    func next() -> ConnectedDirection
    {
        return ConnectedDirection.init(rawValue: self.rawValue + 1) ?? .null
    }
    
    var offset: (x: Int, y: Int)
    {
        var x = 0, y = 0
        
        switch self
        {
            case .leftTop_rightBottom:
                x = 1
                y = -1
                break
            
            case .rightTop_leftBottom:
                x = 1
                y = 1
                break
            
            case .horizontal:
                x = 1
                y = 0
                break
            
            case .vertical:
                x = 0
                y = 1
                break
            
            default:
                break
        }

        return (x, y)
    }
}
