//
//  BingoLogic.swift
//  Bingo
//
//  Created by xattacker on 2020/7/14.
//  Copyright © 2020 xattacker. All rights reserved.
//

import Foundation


enum PlayerType: Int
{
    case computer = 0
    case player = 1
    
    func opposite() -> PlayerType
    {
        return self == .computer ? .player : .computer
    }
}


class BingoLogic
{
    private class GridRecord
    {
        var connection: Int = 0 // 連棋數
        var grids: [[BingoGrid]] = [[BingoGrid]]()
    }
    
    
    var winner: PlayerType
    {
        return self.turn
    }
    
    private weak var delegate: BingoLogicDelegate?
    
    /* 下棋位置 */
    private var locX: Int = 0
    private var locY: Int = 0
    private var connected: Int = 0 // 連棋數
    private var weight: [Int] = [0, 0, 0] // 權重
    
    private var turn: PlayerType = PlayerType.player
    private var isGameOver: Bool = false
    private var grids: [GridRecord] = [GridRecord(), GridRecord()]
    
    private var gridLength: Int
    {
        return self.grids[0].grids.count
    }
    
    init(delegate: BingoLogicDelegate)
    {
        self.delegate = delegate
    }
    
    func restart()
    {
        self.connected = 0
        self.weight[2] = 0
        self.isGameOver = false

        let grid_length = self.gridLength - 1
        
        for i in 0 ... self.grids.count - 1
        {
            let record = self.grids[i]
            record.connection = 0

            for j in 0 ... grid_length
            {
                let grid_row = record.grids[j]
                for k in 0 ... grid_length
                {
                    grid_row[k].initial()
                }
            }
        }
    }
    
    func addGrid(_ type: PlayerType, grid: BingoGrid, x: Int, y: Int)
    {
        if self.grids[type.rawValue].grids.count <= x
        {
            self.grids[type.rawValue].grids.append([BingoGrid]())
        }
        
        if self.grids[type.rawValue].grids[x].count <= y
        {
            self.grids[type.rawValue].grids[x].append(grid)
        }
        else
        {
            self.grids[type.rawValue].grids[x][y] = grid
        }
    }
    
    func getConnectionCount(_ type: PlayerType) -> Int
    {
        return self.grids[type.rawValue].connection
    }
    
    func fillNumber(_ type: PlayerType = PlayerType.computer)
    {
        let tag = type.rawValue
        let grid_length = self.gridLength - 1
        var temp_value = 0
        var x = 0
        var y = 0

        for i in 0 ... grid_length
        {
            for j in 0 ... grid_length
            {
                self.grids[tag].grids[i][j].value = i * 5 + (j + 1)
            }
        }

        for i in 0 ... grid_length
        {
            for j in 0 ... grid_length
            {
                temp_value = self.grids[tag].grids[i][j].value

                x = Int.random(in: 0...grid_length)
                y = Int.random(in: 0...grid_length)

                self.grids[tag].grids[i][j].value = self.grids[tag].grids[x][y].value
                self.grids[tag].grids[x][y].value = temp_value
            }
        }
    }
    
    func winCheck(_ x: Int, y: Int)
    {
        self.winCheck(PlayerType.player, x: x, y: y, redo: true)
    }
    
    deinit
    {
        self.delegate = nil
    }
}


extension BingoLogic
{
    private func winCheck(_ type: PlayerType, x: Int, y: Int, redo: Bool)
    {
        if !self.isGameOver
        {
            self.turn = type
            self.locX = x
            self.locY = y

            self.winCheck(ConnectedDirection.leftTop_rightBottom)

            if !self.isGameOver && redo
            {
                self.redo(self.grids[type.rawValue].grids[x][y].value)

                if type == PlayerType.player && !self.isGameOver
                {
                    self.runAI()
                }
            }
        }
    }

    private func winCheck(_ direction: ConnectedDirection)
    {
        if direction == ConnectedDirection.null
        {
            return
        }


        let offset = direction.offset
        var x = self.locX + offset.x
        var y = self.locY + offset.y

        self.connected = 1

        while x >= 0 && x < 5 && y >= 0 && y < 5 && self.grids[self.turn.rawValue].grids[x][y].isSelected == true
        {
            self.connected = self.connected + 1
            x = x + offset.x
            y = y + offset.y
        }

        x = self.locX - offset.x
        y = self.locY - offset.y

        while x >= 0 && x < 5 && y >= 0 && y < 5 && self.grids[self.turn.rawValue].grids[x][y].isSelected == true
        {
            self.connected = self.connected + 1
            x = x - offset.x
            y = y - offset.y
        }


        if self.connected >= 5
        {
            x = self.locX
            y = self.locY

            while x >= 0 && x < 5 && y >= 0 && y < 5 && self.grids[self.turn.rawValue].grids[x][y].isSelected == true
            {
                self.grids[self.turn.rawValue].grids[x][y].setConnectedLine(direction: direction, connected: true)
                x = x + offset.x
                y = y + offset.y
            }

            x = self.locX - offset.x
            y = self.locY - offset.y

            while x >= 0 && x < 5 && y >= 0 && y < 5 && self.grids[self.turn.rawValue].grids[x][y].isSelected == true
            {
                self.grids[self.turn.rawValue].grids[x][y].setConnectedLine(direction: direction, connected: true)
                x = x - offset.x
                y = y - offset.y
            }

            self.grids[self.turn.rawValue].connection = self.grids[self.turn.rawValue].connection + 1

            self.delegate?.onLineConnected(turn: self.turn, count: self.grids[self.turn.rawValue].connection)

            if self.grids[self.turn.rawValue].connection >= 5 && !self.isGameOver
            {
                self.delegate?.onWon(winner: self.turn)
                self.isGameOver = true
            }
        }

        if !self.isGameOver
        {
            self.winCheck(direction.next())
        }
    }
    
    // after the one side done, the other side do the same value
    private func redo(_ value: Int)
    {
        self.turn = self.turn.opposite()

        let grid_length = self.gridLength - 1
        
        for i in 0 ... grid_length
        {
            for j in 0 ... grid_length
            {
                if self.grids[self.turn.rawValue].grids[i][j].value == value
                {
                    self.grids[self.turn.rawValue].grids[i][j].isSelected = true
                    self.winCheck(self.turn, x: i, y: j, redo: false)

                    break
                }
            }
        }
    }
    
    private func runAI()
    {
        self.turn = PlayerType.computer
        
        let grid_length = self.gridLength - 1
          
        for i in 0 ... grid_length
        {
            for j in 0 ... grid_length
            {
                if self.grids[self.turn.rawValue].grids[i][j].isSelected == false
                {
                    self.runAI2(i, y: j)
                }
            }
        }

        if self.weight[2] > 1
        {
            self.weight[2] = 0
            self.grids[self.turn.rawValue].grids[self.weight[0]][self.weight[1]].isSelected = true
            self.winCheck(self.turn, x: self.weight[0], y: self.weight[1], redo: true)
        }
        else
        {
            self.randomAI()
        }
    }
    
    private func runAI2(_ x: Int, y: Int)
    {
        self.locX = x
        self.locY = y
        var w = 0
        var dir = ConnectedDirection.leftTop_rightBottom

        repeat
        {
            let offset = dir.offset
            w = w + self.calculateWeight(offset.x, offsetY: offset.y)
            dir = dir.next()

        } while dir != ConnectedDirection.null

        if w > self.weight[2]
        {
            self.weight[0] = self.locX
            self.weight[1] = self.locY
            self.weight[2] = w
        }
    }
    
    private func randomAI()
    {
        let grid_length = self.gridLength - 1
        var x = 0
        var y = 0

        if self.grids[self.turn.rawValue].grids[2][2].isSelected == false // the first priority is center
        {
            y = 2
            x = y
        }
        else
        {
            repeat
            {
                x = Int.random(in: 0...grid_length)
                y = Int.random(in: 0...grid_length)

            } while self.grids[self.turn.rawValue].grids[x][y].isSelected == true
        }

        self.grids[self.turn.rawValue].grids[x][y].isSelected = true
        self.winCheck(self.turn, x: x, y: y, redo: true)
    }
    
    private func calculateWeight(_ offsetX: Int, offsetY: Int) -> Int
    {
        var w = 0
        var x = self.locX
        var y = self.locY
        let tag = PlayerType.computer.rawValue
        let grid_length = self.gridLength
        
        self.connected = 0

        while x >= 0 && x < grid_length && y >= 0 && y < grid_length
        {
            if self.grids[tag].grids[x][y].isSelected == true
            {
                w = w + 1
            }

            self.connected = self.connected + 1
            x = x + offsetX
            y = y + offsetY
        }

        x = self.locX - offsetX
        y = self.locY - offsetY

        while x >= 0 && x < grid_length && y >= 0 && y < grid_length
        {
            if self.grids[tag].grids[x][y].isSelected == true
            {
                w = w + 1
            }

            self.connected = self.connected + 1
            x = x - offsetX
            y = y - offsetY
        }

        if w == 4 // 加重已有四個被選擇的行列權重
        {
            w = w + 1
        }

        return self.connected == 5 ? w * w : 0
    }
}
