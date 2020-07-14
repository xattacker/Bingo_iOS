//
//  ConfigureSetting.swift
//  ShrChiuan
//
//  Created by xattacker on 2015/6/28.
//  Copyright (c) 2015年 xattacker. All rights reserved.
//

import UIKit

class ConfigureSetting
{
    private static var inst: ConfigureSetting?
    
    var updateTime: String = ""
    
    static func initial()
    {
        if inst == nil
        {
            inst = ConfigureSetting()
            inst?.importValue()
        }
    }
    
    static func instance() -> ConfigureSetting?
    {
        return inst
    }
    
    static func releaseInstance()
    {
        if inst != nil
        {
            inst = nil
        }
    }
    
    func export()
    {
        let defaults = UserDefaults.standard
        defaults.set(self.updateTime, forKey: "UPDATE_TIME")
        
        defaults.synchronize()
    }
    
    private func importValue()
    {
        let defaults = UserDefaults.standard
        
        if let str = defaults.object(forKey: "UPDATE_TIME") as? String
        {
            self.updateTime = str
        }
    }
}
