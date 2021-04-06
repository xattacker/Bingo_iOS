//
//  MockBingoGridView.swift
//  BingoUnitTests
//
//  Created by xattacker on 2021/4/6.
//  Copyright © 2021 xattacker. All rights reserved.
//

import Foundation
@testable import Bingo
@testable import RxSwift
@testable import RxCocoa


internal class MockBingoGridView: BingoGridView
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
