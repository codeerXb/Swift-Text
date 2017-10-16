//
//  XBTitleView.swift
//  XBPageView
//
//  Created by 谢斌 on 2017/10/13.
//  Copyright © 2017年 lianluohudong.com. All rights reserved.
//

import UIKit

protocol titleViewDelegate : class {
    func titleView(titleView : XBTitleView,selctedIndex : Int)
}
class XBTitleView: UIView {
   weak var delegate : titleViewDelegate?
    var titleArrs : [String] = [String]()
    fileprivate var titleStyle : XBStayle = XBStayle()
    fileprivate var titleLabs : [UILabel] = [UILabel]()
    fileprivate var currentIndex : Int = 0
    fileprivate lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView(frame:bounds)
        scrollView.scrollsToTop = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    fileprivate lazy var bottomLine : UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = self.titleStyle.bottomLineColor
        bottomLine.frame.size.height = self.titleStyle.bottomLineHeight
        return bottomLine
    }()
    fileprivate lazy var coverView : UIView = {
        let coverView = UIView()
        coverView.backgroundColor = self.titleStyle.coverBgColor
        coverView.alpha = self.titleStyle.coverAlpha
        return coverView
    }()
    // MARK: 构造函数
    init(frame : CGRect,titles : [String],style : XBStayle) {
        self.titleArrs = titles
        self.titleStyle = style
        super.init(frame:frame)
        // 创建UI
        setUpUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("不能从Xib加载")
    }
}
// MARK:- 设置UI界面
extension XBTitleView {
    fileprivate func setUpUI() -> Void {
        // 添加scrollow
        addSubview(scrollView)
        // 设置tile
        setupTitleLabels()
        // 设置frame
        setUpTitleViewFrame()
        // 设置遮盖
        showCoverView()
    }
   private func setupTitleLabels() -> Void {
       // 设置lable的属性
       for (i ,text) in titleArrs.enumerated() {
        let titleLable = UILabel()
        titleLable.text = text
        titleLable.tag = i
        titleLable.font = self.titleStyle.titleFont
        titleLable.textAlignment = .center
        titleLable.textColor = i == 0 ? self.titleStyle.textSeclectedColor : self.titleStyle.textNormalColor
        
        scrollView.addSubview(titleLable)
        
        titleLabs.append(titleLable)
        
        let tapGres = UITapGestureRecognizer(target: self, action: #selector(XBTitleView.titleLabelClick(tapGrp:)))
        titleLable.addGestureRecognizer(tapGres)
        titleLable.isUserInteractionEnabled = true
        }
    
    }
    private func setUpTitleViewFrame() -> Void {
        let count = titleArrs.count
        for (i,lable) in titleLabs.enumerated() {
            let h : CGFloat = bounds.height
            var w : CGFloat = 0
            var x : CGFloat = 0
            let y : CGFloat = 0
            
            if !titleStyle.isScrollEnable {
                w = bounds.width / CGFloat(count)
                x = w * CGFloat(i)
            }else {
                w = (titleArrs[i] as NSString).boundingRect(with: CGSize(width :CGFloat.greatestFiniteMagnitude,height:0), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: titleStyle.titleFont], context: nil).width
                if i == 0 {
                    x = titleStyle.titleMargin * 0.5
                }else {
                    let preLable = titleLabs[i - 1]
                    x = preLable.frame.maxX + titleStyle.titleMargin
                    
                }
            }
            lable.frame = CGRect(x: x, y: y, width: w, height: h)
            
            if titleStyle.isTitleScale && i == 0 {
                lable.transform = CGAffineTransform(scaleX: titleStyle.scaleRange, y: titleStyle.scaleRange)
                
            }
        }
        if titleStyle.isScrollEnable {
            scrollView.contentSize.width = titleLabs.last!.frame.maxX + titleStyle.titleMargin * 0.5
        }
    }
    
    private func showBottomLine() ->Void {
        guard titleStyle.isShowBottomLine else {
            return
        }
        scrollView.addSubview(bottomLine)
        
        // 设置底部线的frame
        bottomLine.frame.origin.x = titleLabs.first!.frame.origin.x
        bottomLine.frame.origin.y = bounds.height - titleStyle.bottomLineHeight
        bottomLine.frame.size.width = titleLabs.first!.frame.size.width
        
    }
    
    private func showCoverView() -> Void {
       // 1.判断是否需要显示
        guard titleStyle.isShowCoverView else {
            return
        }
        scrollView.addSubview(coverView)
        // 3.设置frame
        var coverW : CGFloat = titleLabs.first!.frame.width - 2 * titleStyle.titleMargin
        if titleStyle.isScrollEnable {
            coverW = titleLabs.first!.frame.width - 0.5 * titleStyle.titleMargin
        }
        let coverH : CGFloat = titleStyle.coverHeight
        coverView.bounds = CGRect(x: 0, y: 0, width: coverW, height: coverH)
        coverView.center = titleLabs.first!.center
        
        coverView.layer.cornerRadius = titleStyle.coverHeight * 0.5
        coverView.layer.masksToBounds = true
    }
   
}
// MARK:- 事件处理函数
extension XBTitleView {
    @objc fileprivate func titleLabelClick(tapGrp : UITapGestureRecognizer) -> Void {
        guard let newLable = tapGrp.view as? UILabel else {
            return
        }
        // 点击标签切换
        let oldLable = titleLabs[currentIndex]
        oldLable.textColor = titleStyle.textNormalColor
        newLable.textColor = titleStyle.textSeclectedColor
        currentIndex = newLable.tag

        delegate?.titleView(titleView: self, selctedIndex: currentIndex)
        
        // 调整底部的线
        if titleStyle.isShowBottomLine {
            bottomLine.frame.origin.x = newLable.frame.origin.x
            bottomLine.frame.size.width = newLable.frame.size.width
        }
        
        // 4.调整缩放比例
        if titleStyle.isTitleScale {
            newLable.transform = oldLable.transform
            oldLable.transform = CGAffineTransform.identity
        }
        //  调整位置
        adjustPosition(newLable: newLable)
        // 调整CoverView的位置
        if titleStyle.isShowCoverView {
            let coverW = titleStyle.isShowCoverView ? (newLable.frame.width + titleStyle.titleMargin) : (newLable.frame.width - 2 * titleStyle.coverMargin)
            coverView.frame.size.width = coverW
            coverView.center = newLable.center
        }
    }
}

extension XBTitleView : XBContentViewDelegate {
    
    func contentview(contentView: XBContentView, endIndex: Int) {
        
    }
    
    func titleView(titleView: XBTitleView, selctedIndex: Int) {
        // 取出lable
        let oldLable = titleLabs[currentIndex]
        let newLable = titleLabs[selctedIndex]
        // lable颜色设置
        oldLable.textColor = titleStyle.textNormalColor
        newLable.textColor = titleStyle.textSeclectedColor
        // 记录最新的index
        currentIndex = selctedIndex
        // 判断是否可以滚动
        adjustPosition(newLable: newLable)
    }
    
    fileprivate func adjustPosition(newLable : UILabel) -> Void {
        guard titleStyle.isScrollEnable else {
            return
        }
        // 设定偏移
        var offsetX = newLable.center.x - scrollView.frame.width * 0.5
        if offsetX < 0 {
            offsetX = 0
        }
        let maxOffset = scrollView.contentSize.width - bounds.width
        if offsetX > maxOffset {
            offsetX = maxOffset
        }
        scrollView.setContentOffset(CGPoint(x:offsetX,y:0), animated: true)
    }
    
     func contentview(contentView : XBContentView,targetIndex :Int,progress : CGFloat) -> Void {
        // 取出lable
        let oldLable = titleLabs[currentIndex]
        let newLable = titleLabs[targetIndex]
        
        // 2.渐变文字颜色
        let selectRGB = getGRBValue(titleStyle.textSeclectedColor)
        let normalRGB = getGRBValue(titleStyle.textNormalColor)
        let deltaRGB = (selectRGB.0 - normalRGB.0, selectRGB.1 - normalRGB.1, selectRGB.2 - normalRGB.2)
        oldLable.textColor = UIColor(r: selectRGB.0 - deltaRGB.0 * progress, g: selectRGB.1 - deltaRGB.1 * progress, b: selectRGB.2 - deltaRGB.2 * progress)
        newLable.textColor = UIColor(r: normalRGB.0 + deltaRGB.0 * progress, g: normalRGB.1 + deltaRGB.1 * progress, b: normalRGB.2 + deltaRGB.2 * progress)
        
        // 调整底部的线
        if titleStyle.isShowBottomLine {
            let deltaX = newLable.frame.origin.x - oldLable.frame.origin.x
            let deltaW = newLable.frame.width - oldLable.frame.width
            
            bottomLine.frame.origin.x = oldLable.frame.origin.x + deltaX * progress
            bottomLine.frame.size.width = oldLable.frame.width + deltaW * progress
        }
        // 调整缩放
        if titleStyle.isTitleScale {
            let deltaCale = titleStyle.scaleRange - 1.0
            oldLable.transform = CGAffineTransform(scaleX: titleStyle.scaleRange - deltaCale * progress, y: titleStyle.scaleRange - deltaCale * progress)
            newLable.transform = CGAffineTransform(scaleX: 1.0 + deltaCale * progress, y: 1.0 + deltaCale * progress)
        }
        
        // 5.调整coverView
        if titleStyle.isShowCoverView {
            let oldW = titleStyle.isScrollEnable ? (oldLable.frame.width + titleStyle.titleMargin) : (oldLable.frame.width - 2 * titleStyle.coverMargin)
            let newW = titleStyle.isScrollEnable ? (newLable.frame.width + titleStyle.titleMargin) : (newLable.frame.width - 2 * titleStyle.coverMargin)
            let deltaW = newW - oldW
            let deltaX = newLable.center.x - oldLable.center.x
            coverView.frame.size.width = oldW + deltaW * progress
            coverView.center.x = oldLable.center.x + deltaX * progress
        }
    }
    private func getGRBValue(_ color : UIColor) -> (CGFloat, CGFloat, CGFloat) {
        guard  let components = color.cgColor.components else {
            fatalError("文字颜色请按照RGB方式设置")
        }
        
        return (components[0] * 255, components[1] * 255, components[2] * 255)
    }
}
