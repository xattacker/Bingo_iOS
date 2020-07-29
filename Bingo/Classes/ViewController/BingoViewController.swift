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
    private let GRID_DIMENSION: Int = 5

    @IBOutlet private weak var comGridStackView: UIStackView!
    @IBOutlet private weak var playerGridStackView: UIExtendedStackView!
    
    @IBOutlet private weak var comCountView: UICountView?
    @IBOutlet private weak var playerCountView: UICountView?
    
    @IBOutlet private weak var recordLabel: UILabel!
    @IBOutlet private weak var versionLabel: UILabel!
    
    @IBOutlet private weak var autoFillButton: UIButton!
    @IBOutlet private weak var restartButton: UIButton!
    
    private var viewModel: BingoViewModel?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.convertLocalizedString()

        self.initViewModel()
        self.setupGridLayout(self.comGridStackView, type: .computer)
        self.setupGridLayout(self.playerGridStackView, type: .player)
            
        self.versionLabel.text = String(format: "v %@", AppProperties.getAppVersion())
        self.updateRecordView()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        self.showToast(String.localizedString("FILL_NUMBER"))
        self.showHintAnimation()
        
        self.viewModel?.restart()
    }
    
    @IBAction func onAutoFillNumAction(_ sender: AnyObject)
    {
        self.viewModel?.fillNumber(.player)
        self.viewModel?.startPlaying()
    }
    
    @IBAction func onRestartAction(_ sender: AnyObject)
    {
        self.viewModel?.restart()
    }

    deinit
    {
        self.viewModel = nil
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
        let message = winner == .computer ? "YOU_LOSE" : "YOU_WIN"
        self.showAlertController(AlertTitleType.notification, message: String.localizedString(message))
        
        self.updateRecordView()
    }  
}


extension BingoViewController
{
    private func initViewModel()
    {
        self.viewModel = BingoViewModel(delegate: self, dimension: GRID_DIMENSION)
        
        self.viewModel?.onStatusChanged = {
                                             [weak self]
                                             (status: GameStatus) in
                                              
                                              self?.updateButtonWithStatus(status)
            
                                              switch status
                                              {
                                                   case .prepare:
                                                        self?.resetLineCountView()
                                                        break
                                                     
                                                   case .playing:
                                                        self?.showToast(String.localizedString("GAME_START"))
                                                        break
                                                    
                                                   case .end:
                                                        break
                                              }
                                          }
    }
    
    private func showHintAnimation()
    {
        self.playerGridStackView.backgroundColor = UIColor.red
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: [.allowUserInteraction, .autoreverse, .repeat],
            animations:
            {
                [weak self] in
                
                UIView.setAnimationRepeatCount(2)
                self?.playerGridStackView.validBackgroundView?.alpha = 0
            },
            completion:
            {
                [weak self]
                (finished: Bool) in
                
                self?.playerGridStackView.backgroundColor = UIColor.clear
                self?.playerGridStackView.validBackgroundView?.alpha = 1
            })
    }
    
    private func setupGridLayout(_ gridLayout: UIStackView, type: PlayerType)
    {
        let width = self.view.shortWidthRatio(0.125)
        
        for sub in gridLayout.subviews
        {
            sub.removeFromSuperview()
        }
        
        for i in 0 ... GRID_DIMENSION - 1
        {
            let row_layout = UIStackView()
            row_layout.translatesAutoresizingMaskIntoConstraints = false // we should set it to false before add constraint
            row_layout.axis = .horizontal
            row_layout.spacing = gridLayout.spacing
            row_layout.distribution = .fillEqually

            for j in 0 ... GRID_DIMENSION - 1
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
                self.viewModel?.addGrid(type, grid: grid, x: i, y: j)
                
                if type == .player
                {
                    grid.clicked = {
                                        [weak self]
                                        (grid: UIGridView) in
                                        
                                        var temp = grid as BingoGrid
                                        self?.viewModel?.handleGridClick(&temp, x: grid.locX, y: grid.locY)
                                    }
                }
            }
            
            gridLayout.addArrangedSubview(row_layout)
        }
    }
    
    private func resetLineCountView()
    {
        self.comCountView?.count = 0
        self.playerCountView?.count = 0
    }

    private func updateRecordView()
    {
        self.recordLabel.text = String.localizedString(
                                "WIN_COUNT",
                                self.viewModel?.record.winCount ?? 0,
                                self.viewModel?.record.loseCount ?? 0)
    }
    
    private func updateButtonWithStatus(_ status: GameStatus)
    {
        switch status
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
