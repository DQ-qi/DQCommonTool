//
//  ViewController.swift
//  DQCommonTool
//
//  Created by 15013781186 on 12/10/2019.
//  Copyright (c) 2019 15013781186. All rights reserved.
//

import UIKit
import DQCommonTool

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        self.title = "DQCommonTool"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let viewModel = ViewModel()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: UIScreen.main.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        return tableView
    }()

}

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arr = viewModel.dataArr[section]
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        }
        let arr = viewModel.dataArr[indexPath.section]
        cell?.textLabel?.text = arr[indexPath.row]
        return cell ?? UITableViewCell.init(style: .default, reuseIdentifier: "cell")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let alertCtl = UIAlertController.init(title: "时间选择器", message: "请选择时间", preferredStyle: .alert)
                alertCtl.addDatePicker(model: .time, date: Date()) { (date) in
                    DQPrint(date)
                }
                
                alertCtl.addAction(title: "确定", style: .default, isEnabled: true) { (action) in
                    
                }
                alertCtl.show()
            case 1:
                let alertCtl = UIAlertController.init(title: "日期选择器", message: "请选择年月日", preferredStyle: .alert)
                alertCtl.addDatePicker(model: .date, date: Date()) { (date) in
                    DQPrint(date)
                }
                
                alertCtl.addAction(title: "确定", style: .default, isEnabled: true) { (action) in
                    
                }
                alertCtl.show()
            case 2:
                let alertCtl = UIAlertController.init(title: "时间选择器", message: "请选择日期时分", preferredStyle: .alert)
                alertCtl.addDatePicker(model: .dateAndTime, date: Date()) { (date) in
                    DQPrint(date)
                }
                
                alertCtl.addAction(title: "确定", style: .default, isEnabled: true) { (action) in
                    
                }
                alertCtl.show()
            case 3:
                let alertCtl = UIAlertController.init(title: "时间选择器", message: "请选择时分", preferredStyle: .alert)
                alertCtl.addDatePicker(model: .countDownTimer, date: Date()) { (date) in
                    DQPrint(date)
                }
                
                alertCtl.addAction(title: "确定", style: .default, isEnabled: true) { (action) in
                    
                }
                alertCtl.show()
            default:
                break
            }
            
        }
    }
    
}

class ViewModel {
    
    var dataArr = [
        ["请选择时间","请选择年月日","请选择日期时分","请选择时分"]]
    
}
