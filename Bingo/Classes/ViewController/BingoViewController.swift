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
    
    @IBOutlet private weak var comCountView: UICountView?
    @IBOutlet private weak var playerCountView: UICountView?
    
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
        
        self.setupGridLayout(self.comGridStackView, type: .computer)
        self.setupGridLayout(self.playerGridStackView, type: .player)
            
        self.versionLabel.text = String(format: "v %@", AppProperties.getAppVersion())
        self.updateRecordView()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        self.showToast(String.localizedString("FILL_NUMBER"))
        self.restart()
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
        if turn == .computer
        {
            self.comCountView?.count = count
        }
        else
        {
            self.playerCountView?.count = count
        }
    }
    
    func onWon(winner: PlayerType)
    {
        self.status = GameStatus.end
        self.updateButtonWithStatus()
        
        var message = ""
        
        if winner == .computer
        {
            self.recorder.addLose()
            message = "YOU_LOSE"
        }
        else // player won
        {
            self.recorder.addWin()
            message = "YOU_WIN"
        }

        self.showAlertController(AlertTitleType.notification, message: message.localizedString())
        self.updateRecordView()
    }  
}


extension BingoViewController
{
    private func setupGridLayout(_ gridLayout: UIStackView, type: PlayerType)
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
                
                if type == .player
                {
                    grid.clicked = {
                                        [weak self]
                                        (grid: UIGridView) in
                        
                                        switch self?.status
                                        {
                                            case .prepare:
                                                if grid.value <= 0
                                                {
                                                    self?.numDoneCount += 1
                                                    grid.value = self?.numDoneCount ?? 0

                                                    if grid.value >= 25
                                                    {
                                                        self?.startPlaying()
                                                    }
                                                }
                                                break
                                             
                                            case .playing:
                                                if !grid.isSelected
                                                {
                                                    grid.isSelected = true
                                                    self?.logic?.winCheck(grid.locX, y: grid.locY)
                                                }
                                                break
                                            
                                            case .end:
                                                self?.restart()
                                                break
                                            
                                            default:
                                                break
                                        }
                                    }
                }
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
        self.logic?.fillNumber()
        self.status = GameStatus.playing
        self.updateButtonWithStatus()

        self.showToast(String.localizedString("GAME_START"))
    }

    private func updateRecordView()
    {
        self.recordLabel.text = AppUtility.getString(
                                "WIN_COUNT",
                                parameters: self.recorder.winCount.toString(), self.recorder.lostCount.toString())
    }
    
    private func updateButtonWithStatus()
    {
        switch self.status
        {
            case .prepare:
                self.autoFillButton.isHidden = false
                self.restartButton.isHidden = true
                break
                
            case .playing:
                self.autoFillButton.isHidden = true
                self.restartButton.isHidden = true
                break
                
            case .end:
                self.autoFillButton.isHidden = true
                self.restartButton.isHidden = false
                break
        }
    }
}
