//
//  BingoViewController.swift
//  Bingo
//
//  Created by xattacker on 2020/7/14.
//  Copyright © 2020年 xattacker. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BingoViewController: UIViewController
{
    private let GRID_DIMENSION: Int = 5

    @IBOutlet private weak var comGridStackView: UIStackView!
    @IBOutlet private weak var playerGridStackView: UIExtendedStackView!
    
    @IBOutlet private weak var comCountView: UIAnimatedCountView?
    @IBOutlet private weak var playerCountView: UIAnimatedCountView?
    
    @IBOutlet private weak var recordLabel: UILabel!
    @IBOutlet private weak var versionLabel: UILabel!
    
    @IBOutlet private weak var autoFillButton: UIButton!
    @IBOutlet private weak var restartButton: UIButton!
    
    private var viewModel: BingoViewModel?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.convertLocalizedString()

        self.initViewModel()
        
        self.setupGridLayout(self.comGridStackView, type: .computer)
        self.setupGridLayout(self.playerGridStackView, type: .player)
            
        self.versionLabel.text = String(format: "v %@", AppProperties.getAppVersion())
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
        self.viewModel?.fillNumber()
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
        self.delay(0.4) {
            (mySelf: BingoViewController?) in
            
            let message = winner == .computer ? "YOU_LOSE" : "YOU_WIN"
            mySelf?.showAlertController(AlertTitleType.notification, message: String.localizedString(message))
        }
    }  
}


extension BingoViewController
{
    private func initViewModel()
    {
        self.viewModel = BingoViewModel(delegate: self, dimension: GRID_DIMENSION)
        
        // data binding
        self.viewModel?.record
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {
                  [weak self]
                  (record: GradeRecord?) in
                
                  self?.updateRecordView(record)
              }).disposed(by: self.disposeBag)
        
        self.viewModel?.status
             .observeOn(MainScheduler.instance)
             .subscribe(onNext: {
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
                      }).disposed(by: self.disposeBag)
    }
    
    private func showHintAnimation()
    {
        self.playerGridStackView.isUserInteractionEnabled = false
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
                
                self?.playerGridStackView.isUserInteractionEnabled = true
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
                let grid = self.createGridView(CGRect(x: 0, y: 0, width: width, height: width), type: type)
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
                
                if let g2 = grid as? BingoGridView
                {
                    var temp = g2
                    temp.locX = i
                    temp.locY = j
                    temp.type = type
                    self.viewModel?.addGrid(g2)
                }
            }
            
            gridLayout.addArrangedSubview(row_layout)
        }
    }
    
    //private func createGridView<T: UIView>(_ frame: CGRect, type: PlayerType) -> T where T : BingoGridViewProtocol
    private func createGridView(_ frame: CGRect, type: PlayerType) -> UIView
    {
        var grid: UIView
        
        if type == PlayerType.player
        {
            grid = UIGridView(frame: frame)
        }
        else
        {
            let flip = UIFlippableGridView(frame: frame)
            flip.delegate = self
            grid = flip
        }
        
        return grid
    }
    
    private func resetLineCountView()
    {
        self.comCountView?.reset()
        self.playerCountView?.reset()
    }

    private func updateRecordView(_ record: GradeRecord?)
    {
        self.recordLabel.text = String.localizedString(
                                "WIN_COUNT",
                                record?.winCount ?? 0,
                                record?.loseCount ?? 0)
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


extension BingoViewController: UIFlippableViewDelegate
{
    func onFlipStarted(flipped: UIFlippableView)
    {
        self.playerGridStackView.isUserInteractionEnabled = false
    }
    
    func onFlipEnded(flipped: UIFlippableView)
    {
        self.playerGridStackView.isUserInteractionEnabled = true
    }
}
