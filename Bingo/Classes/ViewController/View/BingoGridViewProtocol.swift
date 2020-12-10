//
//  BingoGridViewProtocol.swift
//  Bingo
//
//  Created by xattacker on 2020/12/10.
//  Copyright © 2020 xattacker. All rights reserved.
//

import Foundation


protocol BingoGridViewProtocol: BingoGrid
{
    var locX: Int { get set }
    var locY: Int { get set }
    var clicked: ((_ grid: BingoGrid, _ x: Int, _ y: Int) -> Void)? { get set }
}
