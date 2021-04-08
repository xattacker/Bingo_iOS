//
//  BingoGrid.swift
//  Bingo
//
//  Created by xattacker on 2020/7/14.
//  Copyright © 2020 xattacker. All rights reserved.
//

import Foundation


protocol BingoGrid
{
    var type: PlayerType { get set }
    var value: Int { get set }
    var isSelected: Bool { get set }
    var isConnected: Bool { get set }
  
    subscript(direction: ConnectedDirection) -> Bool { get set }
    
    func initial()
}
