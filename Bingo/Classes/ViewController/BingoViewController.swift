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
    
    @IBOutlet private weak var comGridStackView: UIStackView!
    @IBOutlet private weak var playerGridStackView: UIStackView!
    
    @IBOutlet private weak var comCountView: UICountView!
    @IBOutlet private weak var playerCountView: UICountView!
    
    @IBOutlet private weak var recordLabel: UILabel!
    @IBOutlet private weak var versionLabel: UILabel!
    
    @IBOutlet private weak var autoFillButton: UIButton!
    @IBOutlet private weak var restartButton: UIButton!
    
    private var logic: BingoLogic?
    private var numDoneCount = 0 // 佈子數, 當玩家把25個數字都佈完後 開始遊戲
    private var status = GameStatus.prepare
    private var recorder = GradeRecorder()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.convertLocalizedString()
        
        self.logic = BingoLogic(delegate: self)
        
        self.setupGrid(self.comGridStackView, type: .computer)
        self.setupGrid(self.playerGridStackView, type: .player)
            
        self.versionLabel.text = String(format: "v %@", AppProperties.getAppVersion())
        self.updateRecordView()
        
        self.restart()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        self.showToast(String.localizedString("FILL_NUMBER"))
    }
    
    @IBAction func onAutoFillNumAction(_ sender: AnyObject)
    {
        self.logic?.fillNumber(PlayerType.player)
        self.startPlaying()
    }
    
    @IBAction func onRestartAction(_ sender: AnyObject)
    {
        self.restart()
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


extension BingoViewController
{
    private func setupGrid(_ gridLayout: UIStackView, type: PlayerType)
    {
        let width = self.view.shortWidthRatio(0.125)
        
        for sub in gridLayout.subviews
        {
            sub.removeFromSuperview()
        }
        
        for i in 0 ... 4
        {
            let row_layout = UIStackView()
            row_layout.translatesAutoresizingMaskIntoConstraints = false // we should set it to false before add constraint
            row_layout.axis = .horizontal
            row_layout.spacing = gridLayout.spacing
            row_layout.distribution = .fillEqually

            for j in 0 ... 4
            {
                let grid = UIGridView(frame: CGRect(x: 0, y: 0, width: width, height: width))
                grid.translatesAutoresizingMaskIntoConstraints = false // we should set it to false before add constraint
                row_layout.addArrangedSubview(grid)
                
                let width_const = NSLayoutConstraint(
                                    item: grid,
                                    attribute: NSLayoutConstraint.Attribute.height,
                                    relatedBy: NSLayoutConstraint.Relation.equal,
                                    toItem: grid,
                                    attribute: NSLayoutConstraint.Attribute.width,
                                    multiplier: 1,
                                    constant: 0)
                grid.addConstraint(width_const)
                
                grid.locX = i
                grid.locY = j
                grid.type = type
                self.logic?.addGrid(type, grid: grid, x: i, y: j)
            }
            
            gridLayout.addArrangedSubview(row_layout)
        }
    }
    
    private func restart()
    {
        self.status = GameStatus.prepare
        self.numDoneCount = 0
        self.updateButtonWithStatus()

        self.logic?.restart()
    }
    
    private func startPlaying()
    {
    }

    private func updateRecordView()
    {
        self.recordLabel.text = AppUtility.getString(
                                "WIN_COUNT",
                                parameters: self.recorder.winCount.toString(), self.recorder.lostCount.toString())
    }
    
    private func updateButtonWithStatus()
    {
    }
}
