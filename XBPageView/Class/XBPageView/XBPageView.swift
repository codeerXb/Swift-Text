//
//  XBPageView.swift
//  XBPageView
//
//  Created by 谢斌 on 2017/10/13.
//  Copyright © 2017年 lianluohudong.com. All rights reserved.
//

import UIKit

class XBPageView: UIView {

    // MARK: 定义属性
    fileprivate var titles : [String] = [String]()
    fileprivate var childVCs :[UIViewController] = [UIViewController]()
    fileprivate var parentVC : UIViewController = UIViewController()
    fileprivate var titletyle : XBStayle = XBStayle()
    
    // MARK: 构造函数
    init(frame : CGRect,titles : [String],titleStyle : XBStayle,childVCS : [UIViewController],parentVC : UIViewController) {
        self.titles = titles
        self.titletyle = titleStyle
        self.childVCs = childVCS
        self.parentVC = parentVC
        super.init(frame: frame)
        setUpUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension XBPageView {
    fileprivate func setUpUI() -> Void {
        
    }
}
