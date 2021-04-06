//
//  BingoViewModelUnitTests.swift
//  BingoUnitTests
//
//  Created by xattacker on 2021/4/1.
//  Copyright © 2021 xattacker. All rights reserved.
//

import XCTest
@testable import Bingo
@testable import RxSwift
@testable import RxTest
@testable import RxCocoa


class BingoViewModelUnitTests: XCTestCase
{
    private let GRID_DIMENSION: Int = 5
    private var viewModel: BingoViewModel?
    private let disposeBag = DisposeBag()
    private let scheduler = TestScheduler(initialClock: 0)
    
    override func setUpWithError() throws
    {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws
    {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        self.viewModel = nil
    }

    func testViewModel() throws
    {
        self.viewModel = BingoViewModel(dimension: GRID_DIMENSION)
        self.setupGrid(.computer)
        let grids = self.setupGrid(.player)
        
        // data binding
        let record_observer = self.scheduler.createObserver(GradeRecord?.self)
        self.viewModel?.record.drive(record_observer).disposed(by: self.disposeBag)

        let status_observer = self.scheduler.createObserver(GameStatus.self)
        self.viewModel?.status
             .drive(status_observer)
             .disposed(by: self.disposeBag)
        
        
        let connetedLine_observer = self.scheduler.createObserver((turn: PlayerType, count: Int).self)
        self.viewModel?.lineConnected.drive(connetedLine_observer).disposed(by: self.disposeBag)

        
        let winner_observer = self.scheduler.createObserver(PlayerType.self)
        self.viewModel?.onWon.drive(winner_observer).disposed(by: self.disposeBag)
        
        
        self.viewModel?.fillNumber()
        XCTAssertEqual(status_observer.events, [.next(0, .prepare), .next(0, .playing)], "GameStatus is wrong")
 
        
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
                        if status_observer.events.last?.value.element == .end
                        {
                            break
                        }
                    }
                }
                
                if status_observer.events.last?.value.element == .end
                {
                    break
                }
            }
        } while status_observer.events.last?.value.element != .end
        
        
        assert(winner_observer.events.last != nil && connetedLine_observer.events.last?.value.element?.count == GRID_DIMENSION, "Winner is nil")
        
        
        self.viewModel?.restart()
        XCTAssertEqual(status_observer.events.last, .next(0, .prepare), "GameStatus is wrong")
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
