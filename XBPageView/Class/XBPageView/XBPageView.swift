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
// MARK:设置UI
extension XBPageView {
    fileprivate func setUpUI() -> Void {
        // 1.添加titleView到pageView中
        let titleViewFrame = CGRect(x: 0, y: 0, width: bounds.width, height: titletyle.titleViewHeight)
        
        let titleView : XBTitleView = XBTitleView(frame: titleViewFrame, titles: titles, style: titletyle)
        
        addSubview(titleView)
        titleView.backgroundColor = UIColor.armacdColor()
        // 2.添加contentView到pageView中
        let contentFrame = CGRect(x: 0, y: titleViewFrame.maxY, width: bounds.width, height: frame.height - titleViewFrame.height)
        
        let contentView = XBContentView(frame: contentFrame, childsVC: childVCs, presentVC: parentVC)
        
        addSubview(contentView)
        contentView.backgroundColor = UIColor.armacdColor()
        // 3.设置contentView&titleView关系
        titleView.delegate = contentView
        contentView.delegate = titleView
    }
    
}
