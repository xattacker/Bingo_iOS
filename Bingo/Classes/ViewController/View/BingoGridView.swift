//
//  BingoGridView.swift
//  Bingo
//
//  Created by xattacker on 2020/12/10.
//  Copyright © 2020 xattacker. All rights reserved.
//

import Foundation
import RxSwift


protocol BingoGridView: BingoGrid
{
    var locX: Int { get set }
    var locY: Int { get set }
    
    var clicked: Observable<BingoGridView?> { get }
}
