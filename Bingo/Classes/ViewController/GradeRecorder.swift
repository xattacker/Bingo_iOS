//
//  GradeRecorder.swift
//  Bingo
//
//  Created by xattacker on 2020/7/14.
//  Copyright © 2020 xattacker. All rights reserved.
//

import Foundation


class GradeRecorder
{
    private (set) var winCount: Int = 0
    private (set) var loseCount: Int = 0
    
    func addWin()
    {
        self.winCount += 1
    }

    func addLose()
    {
        self.loseCount += 1
    }
    
    func reset()
    {
        self.winCount = 0
        self.loseCount = 0
    }
}
