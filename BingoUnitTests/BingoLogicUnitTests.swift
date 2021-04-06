//
//  BingoLogicUnitTests.swift
//  BingoUnitTests
//
//  Created by xattacker on 2021/4/6.
//  Copyright © 2021 xattacker. All rights reserved.
//

import XCTest
@testable import Bingo


class BingoLogicUnitTests: XCTestCase
{
    private let GRID_DIMENSION: Int = 5
    
    private var logic: BingoLogic?
    private var connected_count: Int = 0
    private var winner: PlayerType?
    
    override func setUpWithError() throws
    {
        // Put setup code here. This method is called before the invocation of each test method in the class
    }

    override func tearDownWithError() throws
    {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        self.logic = nil
    }

    func testLogic() throws
    {
        self.logic = BingoLogic(delegate: self, dimension: GRID_DIMENSION)
        
        self.setupGrid(.computer)
        let grids = self.setupGrid(.player)
        
        self.logic?.fillNumber(.computer)
        self.logic?.fillNumber(.player)
        
        
        // flip card
        repeat
        {
            for sub in grids
            {
                for grid in sub
                {
                    if !grid.isSelected
                    {
                        grid.isSelected = true
                        self.logic?.winCheck(grid.locX, y: grid.locY)
  
                        if self.winner != nil
                        {
                            break
                        }
                    }
                }
                
                if self.winner != nil
                {
                    break
                }
            }
        } while self.winner == nil
        
        
        assert(self.connected_count == GRID_DIMENSION, "connected count is wrong")
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
                self.logic?.addGrid(type, grid: grid, x: i, y: j)
            }
            
            grids.append(sub_grids)
        }
        
        return grids
    }
}


extension BingoLogicUnitTests: BingoLogicDelegate
{
    func onLineConnected(turn: PlayerType, count: Int)
    {
        self.connected_count = count
    }
    
    func onWon(winner: PlayerType)
    {
        self.winner = winner
    }
}

