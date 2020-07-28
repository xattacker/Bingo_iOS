//
//  BingoViewModel.swift
//  Bingo
//
//  Created by xattacker on 2020/7/27.
//  Copyright © 2020 xattacker. All rights reserved.
//

import Foundation


enum GameStatus
{
    case prepare
    case playing
    case end
}


class BingoViewModel
{
    private(set) var recorder = GradeRecorder()
    
    var onStatusChanged: ((_ status: GameStatus) -> Void)? = nil
    
    private var logic: BingoLogic!
    private var numDoneCount = 0 // 佈子數, 當玩家把25個數字都佈完後 開始遊戲
    private var status = GameStatus.prepare
    private weak var logicDelegate: BingoLogicDelegate?
 
    init(delegate: BingoLogicDelegate, dimension: Int)
    {
        self.logic = BingoLogic(delegate: self, dimension: dimension)
        self.logicDelegate = delegate
    }
    
    func addGrid(_ type: PlayerType, grid: BingoGrid, x: Int, y: Int)
    {
        self.logic.addGrid(type, grid: grid, x: x, y: y)
    }
    
    func fillNumber(_ type: PlayerType)
    {
        self.logic.fillNumber(type)
    }
    
    func handleGridClick(_ grid: inout BingoGrid, x: Int, y: Int)
    {
        switch self.status
        {
            case .prepare:
                if grid.value <= 0
                {
                    self.numDoneCount += 1
                    grid.value = self.numDoneCount

                    if grid.value >= self.logic.maxGridValue
                    {
                        self.startPlaying()
                    }
                }
                break
             
            case .playing:
                if !grid.isSelected
                {
                    grid.isSelected = true
                    self.logic.winCheck(x, y: y)
                }
                break
            
            case .end:
                self.restart()
                break
        }
    }
    
    func restart()
    {
        self.status = GameStatus.prepare
        self.numDoneCount = 0
        self.logic.restart()
        self.onStatusChanged?(self.status)
    }
    
    func startPlaying()
    {
        self.logic?.fillNumber()
        self.status = GameStatus.playing
        self.onStatusChanged?(self.status)
    }
    
    deinit
    {
        self.onStatusChanged = nil
        self.logic = nil
        self.logicDelegate = nil
    }
}


extension BingoViewModel: BingoLogicDelegate
{
    func onLineConnected(turn: PlayerType, count: Int)
    {
        // bypass to another delegate
        self.logicDelegate?.onLineConnected(turn: turn, count: count)
    }
    
    func onWon(winner: PlayerType)
    {
        if winner == .computer
        {
            self.recorder.addLose()
        }
        else // player won
        {
            self.recorder.addWin()
        }
        
        self.status = GameStatus.end
        self.onStatusChanged?(self.status)
        
        // bypass to another delegate
        self.logicDelegate?.onWon(winner: winner)
    }
}
