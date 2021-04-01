//
//  BingoUnitTests.swift
//  BingoUnitTests
//
//  Created by xattacker on 2021/4/1.
//  Copyright © 2021 xattacker. All rights reserved.
//

import XCTest
@testable import Bingo
@testable import RxSwift
@testable import RxCocoa


class BingoUnitTests: XCTestCase
{
    private let GRID_DIMENSION: Int = 5
    private var viewModel: BingoViewModel?
    private var playerGirds: [[MockBingoGridView]]?
    private let disposeBag = DisposeBag()
    
    override func setUpWithError() throws
    {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws
    {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testViewModel() throws
    {
        self.viewModel = BingoViewModel(dimension: GRID_DIMENSION)
        self.setupGrid(.computer)
        self.playerGirds = self.setupGrid(.player)
        
        var got_status: GameStatus?
        var got_winner: PlayerType?
        var connected_count = 0
        
        // data binding
        self.viewModel?.record.drive(
            onNext: {
                (record: GradeRecord?) in
                
            }).disposed(by: self.disposeBag)
        
        self.viewModel?.status
             .drive(onNext: {
                 (status: GameStatus) in
                got_status = status
              }).disposed(by: self.disposeBag)
        
        self.viewModel?.lineConnected.drive(onNext: {
            (connected: (trun: PlayerType, count: Int)) in
            connected_count = connected.count
        }).disposed(by: self.disposeBag)

        self.viewModel?.onWon.drive(onNext: {
            (winner: PlayerType) in
            got_winner = winner
        }).disposed(by: self.disposeBag)
        
        
        self.viewModel?.fillNumber()
        assert(got_status == .playing, "GameStatus is wrong")
        
        
        guard let grids = self.playerGirds else
        {
            assertionFailure("play grids is nil")
            
            return
        }
        
        // flip card
        repeat
        {
            for sub in grids
            {
                for grid in sub
                {
                    if !grid.isSelected
                    {
                        grid.click()
                        if got_status == .end
                        {
                            break
                        }
                    }
                }
                
                if got_status == .end
                {
                    break
                }
            }
        } while got_status != .end
        
        
        assert(got_winner != nil && connected_count == GRID_DIMENSION, "Winner is nil")
        
        
        self.viewModel?.restart()
        assert(got_status == .prepare, "GameStatus is wrong")
    }
    
    @discardableResult
    private func setupGrid(_ type: PlayerType) -> [[MockBingoGridView]]
    {
        var grids = [[MockBingoGridView]]()
        
        for i in 0 ... GRID_DIMENSION - 1
        {
            var sub_grids = [MockBingoGridView]()
            
            for j in 0 ... GRID_DIMENSION - 1
            {
                let grid = MockBingoGridView()
                grid.locX = i
                grid.locY = j
                grid.type = type
                sub_grids.append(grid)
                self.viewModel?.addGrid(grid)
            }
            
            grids.append(sub_grids)
        }
        
        return grids
    }
}


class MockBingoGridView: BingoGridView
{
    var type: PlayerType = PlayerType.none
    var value: Int = -1
    var isSelected: Bool = false
    var isConnected: Bool = false
    
    func initial()
    {
        for i in 0 ..< self.directions.count
        {
            self.directions[i] = false
        }

        self.isConnected = false
        self.isSelected = false
        self.value = 0
    }
    
    func isLineConnected(direction: ConnectedDirection) -> Bool
    {
        return self.directions[direction.rawValue]
    }
    
    func setConnectedLine(direction: ConnectedDirection, connected: Bool)
    {
        self.directions[direction.rawValue] = connected

        if !connected
        {
            self.isConnected = self.directions.first(
                                    where: { (existed: Bool) -> Bool in
                                    return existed
                                }) == true
        }
        else
        {
            self.isConnected = connected
        }
    }
    
    var locX: Int = 0
    var locY: Int = 0
    
    var clicked: Observable<BingoGridView>
    {
        return self.clickedSubject.asObservable()
    }
    
    func click()
    {
        self.clickedSubject.onNext(self)
    }
    
    private var directions: [Bool] = [false, false, false, false]
    private var clickedSubject: PublishSubject<BingoGridView> = PublishSubject()
}
