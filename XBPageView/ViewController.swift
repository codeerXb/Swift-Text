//
//  ViewController.swift
//  XBPageView
//
//  Created by 谢斌 on 2017/10/13.
//  Copyright © 2017年 lianluohudong.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    fileprivate lazy var xbView : UIView = {
        let XBView = UIView()
        XBView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        XBView.backgroundColor = UIColor.red
        return XBView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

