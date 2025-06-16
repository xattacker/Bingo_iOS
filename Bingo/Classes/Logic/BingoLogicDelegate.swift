//
//  BingoLogicDelegate.swift
//  Bingo
//
//  Created by xattacker on 2020/7/14.
//  Copyright © 2020 xattacker. All rights reserved.
//

import Foundation


protocol BingoLogicDelegate: AnyObject
{
    func onLineConnected(turn: PlayerType, count: Int)
    func onWon(winner: PlayerType)
}
