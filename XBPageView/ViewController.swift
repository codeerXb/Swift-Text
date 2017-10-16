//
//  ViewController.swift
//  XBPageView
//
//  Created by 谢斌 on 2017/10/13.
//  Copyright © 2017年 lianluohudong.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = UIColor.armacdColor()
        automaticallyAdjustsScrollViewInsets = false
        installhomePage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func installhomePage() -> Void {
        let pageViewFrame = CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height - 64)
        
        let titles = ["推荐", "手游玩法大全", "娱乐手", "游戏游戏", "美女", "游戏游戏", "趣玩"]
        
        let titleStyle = XBStayle()
        titleStyle.titleViewHeight = 44
        titleStyle.isScrollEnable = true
        titleStyle.isShowCoverView = true
        titleStyle.isShowBottomLine = true
        
        var childVCs = [UIViewController]()
        for _ in 0 ..< childVCs.count {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.armacdColor()
            childVCs.append(vc)
        }
        
        let parentVC = self
        
        let pageView = XBPageView(frame: pageViewFrame, titles: titles, titleStyle: titleStyle, childVCS: childVCs, parentVC: parentVC)
        // 将pageView添加到控制器的view中
        view.addSubview(pageView)
    }
}

