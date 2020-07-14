//
//  BingoViewController.swift
//  Bingo
//
//  Created by xattacker on 2020/7/14.
//  Copyright © 2020年 xattacker. All rights reserved.
//

import UIKit


class BingoViewController: UIViewController
{
    private enum GameStatus
    {
        case prepare
        case playing
        case end
    }
    

    private weak var versionLabel: UILabel!
    
    private var logic: BingoLogic?
    private var numberDoneCount = 0 // 佈子數, 當玩家把25個數字都佈完後 開始遊戲
    private var status = GameStatus.prepare
    private var recorder = GradeRecorder()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.logic = BingoLogic(delegate: self)
    }
    
    @IBAction func onRefreshAction(_ sender: AnyObject)
    {
    }
    
    deinit
    {
        self.logic = nil
    }
}


extension BingoViewController: BingoLogicDelegate
{
    func onLineConnected(turn: PlayerType, count: Int)
    {
    }
    
    func onWon(winner: PlayerType)
    {
    }  
}
