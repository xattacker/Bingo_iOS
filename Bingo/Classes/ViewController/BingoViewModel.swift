//
//  BingoViewModel.swift
//  Bingo
//
//  Created by xattacker on 2020/7/27.
//  Copyright © 2020 xattacker. All rights reserved.
//

import Foundation
import RxSwift


enum GameStatus
{
    case prepare
    case playing
    case end
}


class BingoViewModel
{
    let record: BehaviorSubject<GradeRecord?> = BehaviorSubject(value: nil)
    let status: BehaviorSubject<GameStatus> = BehaviorSubject(value: GameStatus.prepare)

    private var logic: BingoLogic!
    private weak var logicDelegate: BingoLogicDelegate?
    private var recorder = GradeRecorder()
    private var numDoneCount = 0 // 佈子數, 當玩家把25個數字都佈完後 開始遊戲
    private let disposeBag = DisposeBag()
    
    init(delegate: BingoLogicDelegate, dimension: Int)
    {
        self.logic = BingoLogic(delegate: self, dimension: dimension)
        self.logicDelegate = delegate
    }
    
    func addGrid(_ grid: BingoGridView)
    {
        self.logic.addGrid(grid.type, grid: grid, x: grid.locX, y: grid.locY)
        
        if grid.type == PlayerType.player
        {
            grid.clicked
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: {
                      [weak self]
                      (grid: BingoGridView?) in
                    
                        if let grid = grid
                        {
                            var temp = grid
                            self?.handleGridClick(&temp)
                        }
                      }).disposed(by: self.disposeBag)
        }
    }
    
    func fillNumber(_ type: PlayerType)
    {
        self.logic.fillNumber(type)
    }

    func restart()
    {
        self.status.onNext(GameStatus.prepare)
        self.numDoneCount = 0
        self.logic.restart()
    }
    
    func startPlaying()
    {
        self.logic?.fillNumber()
        self.status.onNext(GameStatus.playing)
    }
    
    private func handleGridClick(_ grid: inout BingoGridView)
    {
        switch try? self.status.value()
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
                    self.logic.winCheck(grid.locX, y: grid.locY)
                }
                break
            
            case .end:
                self.restart()
                break
                
            default:
                break
        }
    }
    
    deinit
    {
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

        self.record.onNext(self.recorder)
        self.status.onNext(GameStatus.end)
        
        // bypass to another delegate
        self.logicDelegate?.onWon(winner: winner)
    }
}
