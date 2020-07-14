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
    
    @IBOutlet private weak var recordLabel: UILabel!
    @IBOutlet private weak var versionLabel: UILabel!
    
    private var logic: BingoLogic?
    private var numberDoneCount = 0 // 佈子數, 當玩家把25個數字都佈完後 開始遊戲
    private var status = GameStatus.prepare
    private var recorder = GradeRecorder()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.convertLocalizedString()
        
        self.logic = BingoLogic(delegate: self)
        
        self.setupGrid(self.comGridStackView, clickable: false)
        self.setupGrid(self.playerGridStackView, clickable: true)
            
        self.versionLabel.text = String(format: "v %@", AppProperties.getAppVersion())
        self.updateRecordView()
    }
    
    @IBAction func onAutoFillNumAction(_ sender: AnyObject)
    {
    }
    
    @IBAction func onRestartAction(_ sender: AnyObject)
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


extension BingoViewController
{
    private func setupGrid(_ gridLayout: UIStackView, clickable: Bool)
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
                grid.backgroundColor = UIColor.yellow
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
            }
            
            gridLayout.addArrangedSubview(row_layout)
        }
    }

    private func updateRecordView()
    {
        self.recordLabel.text = AppUtility.getString(
                                "WIN_COUNT",
                                parameters: self.recorder.winCount.toString(), self.recorder.lostCount.toString())
    }
}
