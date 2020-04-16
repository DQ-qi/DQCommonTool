//
//  DQMenu.swift
//  DQCommonTool
//
//  Created by HXSMac on 2020/4/15.
//

import Foundation

// MARK: 定义一个协议 用于菜单的弹出和消失的效果
protocol DQToolMenuProtocol {
  
}

extension DQToolMenuProtocol where Self: UIView {
    
    func dq_showAnimation(view: UIView) {}
    
    func dq_dissAnimation() {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }) { (state) in
            self.removeFromSuperview()
        }
    }
    
}
// MARK: 编辑工具的弹框
public class DQEditToolMenu: UIView,DQToolMenuProtocol {
    
    lazy var contentView: UIView = {
       let contentView = UIView()
       contentView.backgroundColor = UIColor.black
       contentView.layer.cornerRadius = 4
       return contentView
    }()
    
    let width:CGFloat = 120
    
    let height:CGFloat = 40
    
    let titles = ["修改","删除"]
    
    var selectItemClosure: ((_ index: Int)->())?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.contentView)
    }
    
    @objc func clickItemAction(sender: UIButton) {
        let index = sender.tag-1000
        if ((self.selectItemClosure) != nil) {
            self.selectItemClosure?(index)
        }
    }
    
    private func drawArrowLayer(location: CGPoint)->CALayer {
        let path = UIBezierPath()
        path.move(to: CGPoint.init(x: location.x+6, y: location.y))
        path.addLine(to: CGPoint.init(x: location.x, y: location.y-4))
        path.addLine(to: CGPoint.init(x: location.x, y: location.y+4))
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.black.cgColor
        layer.strokeColor = UIColor.black.cgColor
        layer.path = path.cgPath
        return layer
    }
    
    private func dq_setContentView() {
        let lineView = UIView()
        lineView.backgroundColor = .white
        self.contentView.addSubview(lineView)
        lineView.frame = CGRect.init(x: width/2.0, y: 5, width: 1, height: height-10)
        let btn_width = (width-CGFloat(titles.count+1)*5)/CGFloat(titles.count)
        for (i,item) in titles.enumerated() {
            let btn = UIButton.init(type: .custom)
            btn.setTitle(item, for: .normal)
            btn.setTitleColor(.white, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            btn.frame = CGRect.init(x: 5*CGFloat(i+1)+btn_width*CGFloat(i), y: 0, width: btn_width, height: height)
            btn.tag = 1000+i
            self.contentView.addSubview(btn)
            btn.addTarget(self, action: #selector(DQEditToolMenu.clickItemAction(sender:)), for: .touchUpInside)
        }
        
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dq_dissAnimation()
    }
    
    public func showAnimation(view: UIView) {
        dq_showAnimation(view: view)
        guard let app = UIApplication.shared.delegate  else {
            return
        }
        guard let window = app.window else {
            return
        }
        
        if let window = window {
            let loactionRect = view.convert(view.bounds, to: window)
            self.frame = window.frame
            let loaction_y = (self.height-loactionRect.size.height)/2.0
            self.addSubview(self.contentView)
            self.layer.addSublayer(drawArrowLayer(location: CGPoint.init(x: loactionRect.origin.x-10, y: loactionRect.origin.y-loaction_y+height/2.0)))
            window.addSubview(self)
            self.alpha = 0
            self.contentView.frame = CGRect.init(x:loactionRect.origin.x-10, y: loactionRect.origin.y-loaction_y+height/2.0, width: 0, height: 0)
            UIView.animate(withDuration: 0.25, animations: {
                self.alpha = 1
                self.contentView.frame = CGRect.init(x:loactionRect.origin.x-10-self.width, y: loactionRect.origin.y-loaction_y, width: self.width, height: self.height)
            }) { (state) in
                self.dq_setContentView()
            }
        }
    }
    
}
