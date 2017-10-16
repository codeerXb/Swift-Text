//
//  XBContentView.swift
//  XBPageView
//
//  Created by 谢斌 on 2017/10/13.
//  Copyright © 2017年 lianluohudong.com. All rights reserved.
//

import UIKit

private let cellIdent = "cell"

protocol XBContentViewDelegate : class {
    func contentview(contentView : XBContentView,targetIndex :Int,progress : CGFloat)
    func contentview(contentView : XBContentView, endIndex: Int)
}
class XBContentView: UIView {

    //MARK:  定义代理属性
    weak var delegate : XBContentViewDelegate?
    // MARK: 定义属性
    fileprivate var childsVC : [UIViewController] = [UIViewController]()
    fileprivate var parentVC : UIViewController = UIViewController()
    fileprivate lazy var startOffset : CGFloat = 0.0
    fileprivate lazy var isForbigeDelegate : Bool = false
    fileprivate lazy var mainCollectionView : UICollectionView = {
        let collectionLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionLayout.minimumLineSpacing = 0
        collectionLayout.minimumInteritemSpacing = 0
        collectionLayout.scrollDirection = .horizontal
        collectionLayout.itemSize = self.bounds.size
        
        let mainCollectionV = UICollectionView(frame: self.bounds, collectionViewLayout: collectionLayout)
        // 注册cell
        mainCollectionV.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdent)
        mainCollectionV.backgroundColor = UIColor.clear
        mainCollectionV.isPagingEnabled = true
        mainCollectionV.showsVerticalScrollIndicator = true
        mainCollectionV.bounces = true
        mainCollectionV.delegate = self
        mainCollectionV.dataSource = self
        return mainCollectionV
    }()
    
    init(frame: CGRect,childsVC : [UIViewController],presentVC : UIViewController) {
        self.childsVC = childsVC
        self.parentVC = presentVC
        super.init(frame: frame)
        setUpUI()
    }
    required init?(coder aDecoder: NSCoder) {
         fatalError("不能从XIB中加载")
    }
}

extension XBContentView {
   fileprivate func setUpUI() -> Void {
    // 1.将childVc添加到父控制器中
    for vc in childsVC {
        parentVC.addChildViewController(vc)
       }
    // 添加显示的View
    addSubview(mainCollectionView)
    }
}
extension XBContentView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childsVC.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdent, for: indexPath)
        // 清空cell子控件数组
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        // 往cell中添加内容
        let vc = childsVC[indexPath.item]
        vc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(vc.view)
        return cell
    }
}

extension XBContentView :UICollectionViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewEndSroll()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewEndSroll()
        }
    }
    private func scrollViewEndSroll() -> Void {
        // 1.获取结束时，对应的indexPath
        let indx = Int(mainCollectionView.contentOffset.x / mainCollectionView.bounds.width)
        // 2.通知titleView改变下标
        delegate?.contentview(contentView: self, endIndex: indx)
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 记录开始的位置
        isForbigeDelegate = false
        startOffset = mainCollectionView.contentOffset.x
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
    }
    // scrollView滚动时调用
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == startOffset || isForbigeDelegate {
            return
        }
        
        var targetIndex : Int = 0
        var targetProgress : CGFloat = 0.0
        // 判断用户是左滑还是右滑
        if scrollView.contentOffset.x > startOffset {// 左滑
            targetIndex = Int(startOffset / scrollView.bounds.width) + 1
            if targetIndex > childsVC.count {
                targetIndex = childsVC.count - 1
            }
            targetProgress = (scrollView.contentOffset.x - startOffset) / scrollView.bounds.width
        }else {
            // 右滑
            targetIndex = Int(startOffset / scrollView.bounds.width) - 1
            if targetIndex < 0 {
                targetIndex = 0
        }
        targetProgress = (scrollView.contentOffset.x - startOffset) / scrollView.bounds.width
    }
        //将数据传递给titleView
        delegate?.contentview(contentView: self, targetIndex: targetIndex, progress: targetProgress)
  }
    
}
extension XBContentView : titleViewDelegate {
    func titleView(titleView: XBTitleView, selctedIndex: Int) {
        isForbigeDelegate = true
        let indexPath = IndexPath(item: selctedIndex, section: 0)
        print(indexPath)
        mainCollectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    
    }
}

