//
//  XBStayle.swift
//  XBPageView
//
//  Created by 谢斌 on 2017/10/13.
//  Copyright © 2017年 lianluohudong.com. All rights reserved.
//

import UIKit

class XBStayle {
    
    var titleViewHeight : CGFloat = 44
    var titleFont : UIFont = UIFont.systemFont(ofSize: 14)
    var isScrollEnable : Bool = false
    var titleMargin : CGFloat = 10
    
    var isShowBottomLine : Bool = false
    var bottomLineColor : UIColor = UIColor.orange
    var bottomLineHeight : CGFloat = 2
    
    var isShowCoverView : Bool = false
    var coverBgColor : UIColor = UIColor.black
    var coverAlpha : CGFloat = 0.4
    var coverMargin : CGFloat = 8
    var coverHeight : CGFloat = 25
    
    var textSeclectedColor : UIColor = UIColor(r: 255, g: 127, b: 0)
    var textNormalColor : UIColor = UIColor(r: 255, g: 255, b: 255)
    
    var isTitleScale : Bool = false
    var scaleRange : CGFloat = 1.2

}
