//
//  GradeRecorder.swift
//  Bingo
//
//  Created by xattacker on 2020/7/14.
//  Copyright © 2020 xattacker. All rights reserved.
//

import Foundation


protocol GradeRecord
{
    var winCount: Int { get }
    var loseCount: Int { get }
}


struct GradeRecorder : GradeRecord
{
    private (set) var winCount: Int = 0
    private (set) var loseCount: Int = 0
    
    init()
    {
    }
    
    mutating func addWin()
    {
        self.winCount += 1
    }

    mutating func addLose()
    {
        self.loseCount += 1
    }
    
    mutating func reset()
    {
        self.winCount = 0
        self.loseCount = 0
    }
}
