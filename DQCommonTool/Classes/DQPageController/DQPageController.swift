//
//  DQPageController.swift
//  DQCommonTool
//
//  Created by dengqi on 2020/3/24.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

// MARK: 通知的名字
let DQPageBaseScrollStateNotification = "DQPageBaseScrollStateNotification"
let DQPageBaseEndHeaderRefreshNotification = "DQPageBaseEndHeaderRefreshNotification"

// MARK: 定义一个协议
protocol DQPageBaseChildViewProtocol  {
    
    func scrollToTop()
    
    func beginHeaderRefresh()
    
}

// MARK: 滚动视图支持 多个手势
class DQPageScrollView: UIScrollView,UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

public class DQPageController: UIViewController {
    
    var scrollView:DQPageScrollView = DQPageScrollView.init()
    
    lazy var setTitltView:DQPageSegTitleView = {
        let setTitltView = DQPageSegTitleView.init(["标题1","标题2","标题3","标题4"], frmame: CGRect.init(x: 0, y: 200, width: self.view.frame.size.width, height: 40))
        return setTitltView
    }()
    
    lazy var pageController: UIPageViewController = {
        let pageController = UIPageViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        return pageController
    }()
    
    lazy var headerView: UIView = {
        let headerView = UIView.init()
        headerView.backgroundColor = UIColor.orange
        return headerView
    }()
    
    var muArrCtl:[DQPageChildViewController] = [DQPageChildViewController]()
    
    var canContentContainerScroll = true
    
    var selectIndex = 0
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        var muArr = [DQPageChildViewController]()
        for i in 0..<4 {
            let pageChildVc = DQPageChildViewController()
            pageChildVc.index = i
            muArr.append(pageChildVc)
        }
        self.muArrCtl = muArr
        self.scrollView.delegate = self
        self.view.addSubview(self.scrollView)
        if #available(iOS 11, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        self.scrollView.backgroundColor = UIColor.lightGray
        self.scrollView.frame = CGRect.init(x: 0, y: 86, width: self.view.frame.size.width, height: self.view.frame.size.height-86)
        self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
               self.scrollView.centerXAnchor.constraint(equalTo:self.scrollView.centerXAnchor).isActive = true
               self.scrollView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(self.headerView)
        self.headerView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 200)
        self.headerView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        self.headerView.centerXAnchor.constraint(equalTo:self.scrollView.centerXAnchor).isActive = true
        self.headerView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
        self.headerView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        self.setTitltView.frame = CGRect.init(x: 0, y: 200, width: self.view.frame.self.width, height: 40)
        self.scrollView.addSubview(self.setTitltView)

        self.pageController.delegate = self
        self.pageController.dataSource = self
        self.addChild(self.pageController)
        self.scrollView.addSubview(self.pageController.view)
        self.pageController.didMove(toParent: self)
        self.pageController.view.frame = CGRect.init(x: 0, y: 240, width: self.view.frame.size.width, height: self.view.frame.size.height-40-64)
        self.pageController.view.topAnchor.constraint(equalTo: self.setTitltView.bottomAnchor).isActive = true
        self.pageController.view.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
        self.pageController.view.centerXAnchor.constraint(equalTo:self.scrollView.centerXAnchor).isActive = true
        self.pageController.view.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init(DQPageBaseScrollStateNotification), object: nil, queue: nil) { (notifi) in
            self.canContentContainerScroll = true
            self.muArrCtl.forEach { (vc) in
                vc.isCanContentScroll = false
                vc.scrollToTop()
            }
        }
        
        dq_showChildViewControllerAtIndex(index: 0)
        self.setTitltView.selectTitleClosure = { (selectIndex) in
            self.selectIndex = selectIndex
            self.dq_showChildViewControllerAtIndex(index: selectIndex)
        }
    }
    
    func dq_showChildViewControllerAtIndex(index: Int) {
        guard index<self.muArrCtl.count  else {
            return
        }
        
        var currentVc = self.pageController.viewControllers?.last
        if (currentVc == nil) {
            currentVc = self.muArrCtl[index]
        }
        guard currentVc != nil  else {
            return
        }
        let toVC = self.muArrCtl[index]
        let currentIndex = self.muArrCtl.firstIndex { (pageVc) -> Bool in
            return pageVc == currentVc
        }
        if let currentIndex = currentIndex {
            let direction:UIPageViewController.NavigationDirection = (currentIndex>index) ? .reverse: .forward
            self.pageController.setViewControllers([toVC], direction: direction, animated: true) { (state) in
                
            }
        }
    }
    
}

extension DQPageController: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let navigationBarFrame = self.navigationController?.navigationBar.frame {
            let navigationBarHeight =  navigationBarFrame.origin.y+navigationBarFrame.size.height
            let offsetThreshold:CGFloat = 200+86-navigationBarHeight
            
            // 当固定视图滚动的区域大于自己的区域 父滚动视图固定 自己不能滚动 同时告诉子的滚动视图可以滚动
            if (scrollView.contentOffset.y >= offsetThreshold) {
                scrollView.setContentOffset(CGPoint.init(x: 0, y: offsetThreshold), animated: false)
                canContentContainerScroll = false
                self.muArrCtl.forEach { (vc) in
                    vc.isCanContentScroll = true
                }
            } else {
                if (!canContentContainerScroll) {
                    scrollView.setContentOffset(CGPoint.init(x: 0, y: offsetThreshold), animated: false)
                }
            }
        }
    }
    
    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        self.muArrCtl.forEach { (vc) in
            vc.scrollToTop()
        }
        return true
    }
    
}

extension DQPageController: UIPageViewControllerDelegate,UIPageViewControllerDataSource {
    
    // MARK: 左滑
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = self.muArrCtl.firstIndex { (pageVc) -> Bool in
            return pageVc == viewController
        }
        if let index = index {
            if (index<=0) {
                return nil
            }
            return self.muArrCtl[index-1]
        }
        return viewController
    }
    
    // MARK: 右滑
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = self.muArrCtl.firstIndex { (pageVc) -> Bool in
            return pageVc == viewController
        }
        if let index = index {
            if (index>=self.muArrCtl.count-1) {
                return nil
            }
            return self.muArrCtl[index+1]
        }
        return viewController
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let currentVc = self.pageController.viewControllers?.last  else {
            return
        }
        let currentIndex = self.muArrCtl.firstIndex { (pageVc) -> Bool in
            return pageVc == currentVc
        }
        if let currentIndex = currentIndex {
            self.selectIndex = currentIndex
            self.setTitltView.dq_setSelectFunction(index: currentIndex)
        }
    }
}

class DQPageChildViewController: DQPageBaseChildViewController,UITableViewDataSource,UITableViewDelegate {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        return tableView
    }()
    
    var index = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
        self.tableView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: UIScreen.main.bounds.size.height-86-40)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (index==0) {
            return 3
        }
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell")
        if (cell == nil) {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = "view: "+"\(index)"+" cell indexPath.row: "+"\(indexPath.row)"
        return cell!
    }
    
}

extension DQPageChildViewController: DQPageBaseChildViewProtocol {
    
    func scrollToTop() {
           
    }
       
    func beginHeaderRefresh() {
        NotificationCenter.default.post(name: NSNotification.Name.init(DQPageBaseEndHeaderRefreshNotification), object: nil)
    }
    
}


class DQPageSegTitleView: UIView {
    
    var titles: [String]?
    
    var muButtonArr = [UIButton]()
    
    var lineV = UIView()
    
    var selectTitleClosure: ((_ index:Int)->())?
    
    init(_ titles:[String],frmame:CGRect) {
        self.titles = titles
        super.init(frame: frmame)
        self.backgroundColor = UIColor.white
        dq_setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        dq_setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    private func dq_setup() {
        guard let titles = self.titles else {
            return;
        }
        let btn_height:Double = 40
        let width:Double = Double(self.frame.size.width)
        let space:Double = 5
        let count:Double = Double(titles.count)
        let btn_width = Double(width-count*space)/count
        for i in 0..<titles.count {
            let title = titles[i]
            let btn = UIButton(type: .custom)
            btn.frame = CGRect.init(x: space*Double(i+1)+btn_width*Double(i), y: 0, width: btn_width, height: btn_height)
            btn.setTitle(title, for: .normal)
            btn.setTitleColor(UIColor.black, for: .selected)
            btn.setTitleColor(UIColor.lightGray, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 17);
            btn.tag = 1000+i
            self.addSubview(btn)
            self.muButtonArr.append(btn)
            btn.addTarget(self, action: #selector(dq_clickButtonAction(sender:)), for: .touchUpInside)
            
        }
        self.lineV.backgroundColor = UIColor.black
        self.lineV.frame = CGRect.init(x: 0, y: Double(self.frame.size.height-4), width: btn_width*0.6, height: 3);
        self.addSubview(self.lineV)
        dq_setSelectFunction(index: 0)
        
    }
    
    @objc func dq_clickButtonAction(sender:UIButton) {
        let index = sender.tag-1000
        guard index<self.titles?.count ?? 0 else {
            return
        }
        dq_setSelectFunction(index: index)
        if (self.selectTitleClosure != nil) {
            self.selectTitleClosure?(index)
        }
        
    }
    
    public func dq_setSelectFunction(index:Int) {
        self.muButtonArr.forEach { (btn) in
            btn.isSelected = false
        }
        let btn = self.muButtonArr[index]
        btn.isSelected = true
        UIView.animate(withDuration: 0.2) {
            self.lineV.center = CGPoint.init(x: btn.center.x, y: self.lineV.center.y)
        }
    }
}

// MARK: 滚动的基类
class DQPageBaseChildViewController: UIViewController {
    
    var isCanContentScroll: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isCanContentScroll = false
    }
    
}

extension DQPageBaseChildViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!self.isCanContentScroll) {//不能滚动定在原始位置
            scrollView.setContentOffset(CGPoint.zero, animated: false)
        }
        if (scrollView.contentOffset.y<=0) {
            self.isCanContentScroll = false
            // 滚动到超过了自己的滚动区域 发送通知给父的滚动视图 同时自己固定在0,0
            scrollView.setContentOffset(CGPoint.zero, animated: false)
            NotificationCenter.default.post(name: NSNotification.Name.init(DQPageBaseScrollStateNotification), object: nil)
        }
    }
}

