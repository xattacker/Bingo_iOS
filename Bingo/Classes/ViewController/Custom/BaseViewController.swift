//
//  BaseViewController.swift
//  Bingo
//
//  Created by TCCI MACKBOOK PRO on 2020/4/6.
//  Copyright © 2020 xattacker. All rights reserved.
//

import UIKit


class BaseViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = String.localizedString(self.title ?? "")
        self.convertLocalizedString()
        
        if self.isReallyWhiteStyle
        {
            self.view.backgroundColor = UIColor(hexString: "FFE63655")
        }
    }
}
