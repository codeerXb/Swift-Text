//
//  ColorExtention.swift
//  XBPageView
//
//  Created by 谢斌 on 2017/10/13.
//  Copyright © 2017年 lianluohudong.com. All rights reserved.
//

import UIKit
extension UIColor {
    convenience init(r : CGFloat, g : CGFloat, b : CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1.0)
    }
    class func armacdColor() -> UIColor {
        return UIColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
    }
}
