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
}


class BingoLogic
{
    var winner: PlayerType
    {
        return self.turn
    }
    
    private weak var delegate: BingoLogicDelegate?
    
    /* 下棋位置 */
    private var locX: Int = 0
    private var locY: Int = 0
    private var connected: Int = 0 /* 連棋數 */
    private var connects: [Int] = [0, 0] // 雙方連線數
    private var weight: [Int] = [0, 0, 0] // 權重
    private var turn: PlayerType = PlayerType.player
    private var isGameOver: Bool = false
    private var grids: [[[BingoGrid]]] = [[[BingoGrid]](), [[BingoGrid]]()]
    
    init(delegate: BingoLogicDelegate)
    {
        self.delegate = delegate
    }
    
    func restart()
    {
        self.connected = 0
        self.weight[2] = 0
        self.isGameOver = false

        for i in 0 ... self.grids.count
        {
            let grids_layer_1 = self.grids[i]
            self.connects[i] = 0

            for j in 0 ... grids_layer_1.count
            {
                let grids_layer_2 = grids_layer_1[j]
                
                for k in 0 ... grids_layer_2.count
                {
                    grids_layer_2[k].initial()
                }
            }
        }
    }
    
    func addGrid(_ type: PlayerType, grid: BingoGrid, x: Int, y: Int)
    {
        self.grids[type.rawValue][x][y] = grid
        self.grids[type.rawValue][x][y].type = type
    }
    
    func getConnectionCount(_ type: PlayerType) -> Int
    {
        return self.connects[type.rawValue]
    }
    
    func fillNumber(_ type: PlayerType = PlayerType.computer)
    {
        let tag = type.rawValue
        var temp_value = 0
        var x = 0
        var y = 0

        for i in 0 ... 4
        {
            for j in 0 ... 4
            {
                self.grids[tag][i][j].value = i * 5 + (j + 1)
            }
        }

        for i in 0 ... 4
        {
            for j in 0 ... 4
            {
                temp_value = self.grids[tag][i][j].value

                x = Int.random(in: 1...4)
                y = Int.random(in: 1...4)

                self.grids[tag][i][j].value = self.grids[tag][x][y].value
                self.grids[tag][x][y].value = temp_value
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

            self.winCheck(ConnectedDirection.oblique_1)

            if !self.isGameOver && redo
            {
                self.redo(self.grids[type.rawValue][x][y].value)

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

        while x >= 0 && x < 5 && y >= 0 && y < 5 && self.grids[self.turn.rawValue][x][y].isSelected == true
        {
            self.connected = self.connected + 1
            x = x + offset.x
            y = y + offset.y
        }

        x = self.locX - offset.x
        y = self.locY - offset.y

        while x >= 0 && x < 5 && y >= 0 && y < 5 && self.grids[self.turn.rawValue][x][y].isSelected == true
        {
            self.connected = self.connected + 1
            x = x - offset.x
            y = y - offset.y
        }


        if self.connected >= 5
        {
            x = self.locX
            y = self.locY

            while x >= 0 && x < 5 && y >= 0 && y < 5 && self.grids[self.turn.rawValue][x][y].isSelected == true
            {
                self.grids[self.turn.rawValue][x][y].setConnectedLine(direction: direction, connected: true)
                x = x + offset.x
                y = y + offset.y
            }

            x = self.locX - offset.x
            y = self.locY - offset.y

            while x >= 0 && x < 5 && y >= 0 && y < 5 && self.grids[self.turn.rawValue][x][y].isSelected == true
            {
                self.grids[self.turn.rawValue][x][y].setConnectedLine(direction: direction, connected: true)
                x = x - offset.x
                y = y - offset.y
            }

            self.connects[self.turn.rawValue] = self.connects[self.turn.rawValue] + 1

            self.delegate?.onLineConnected(type: self.turn, count: self.connects[self.turn.rawValue])

            if self.connects[self.turn.rawValue] >= 5 && !self.isGameOver
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
    
    private func redo(_ value: Int)
    {
    }
    
    private func runAI()
    {
    }
    
    private func calculateWeight(_ offsetX: Int, offsetY: Int) -> Int
    {
        var w = 0
        var x = self.locX
        var y = self.locY
        let tag = PlayerType.computer.rawValue
        
        self.connected = 0

        while x >= 0 && x < 5 && y >= 0 && y < 5
        {
            if self.grids[tag][x][y].isSelected == true
            {
                w = w + 1
            }

            self.connected = self.connected + 1
            x = x + offsetX
            y = y + offsetY
        }

        x = self.locX - offsetX
        y = self.locY - offsetY

        while x >= 0 && x < 5 && y >= 0 && y < 5
        {
            if self.grids[tag][x][y].isSelected == true
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
