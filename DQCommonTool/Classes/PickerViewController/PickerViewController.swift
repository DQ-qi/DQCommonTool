//
//  PickerViewController.swift
//  DQCommonTool
//
//  Created by HXSMac on 2019/12/11.
//

import Foundation

public extension UIAlertController {
    
    func addPickerView(values: PickerViewController.Values,
                       initialSelection: PickerViewController.Index? = nil,
                       action: PickerViewController.Action?) {
        let pickerViewVc = PickerViewController.init(values: values, initialSelection: initialSelection, action: action)
        var max_num = 0
        
        values.forEach { (array) in
            max_num = max(max_num, array.count)
        }
        var height:Int = max_num * 30
        height = max(height, 100)
        height = min(height, 217)
        set(vc: pickerViewVc,height: CGFloat(height))
    }
    
}

public class PickerViewController: UIViewController {
    
    public typealias Values = [[String]]
    
    public typealias Index = (column: Int, row: Int)
    
    public typealias Action = (_ vc: UIViewController, _ picker: UIPickerView, _ index: Index, _ values: Values) -> ()
    
    fileprivate var action: Action?
    fileprivate var values: Values = [[]]
    fileprivate var initialSelection: Index?
    
    fileprivate lazy var pickerView: UIPickerView = {
      return $0
    }(UIPickerView())
    
    init(values: Values, initialSelection: Index? = nil, action: Action?) {
        super.init(nibName: nil, bundle: nil)
        self.values = values
        self.initialSelection = initialSelection
        self.action = action
    }
    
    public override func loadView() {
        view = pickerView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let initialSelection = initialSelection, values.count > initialSelection.column,
        values[initialSelection.column].count>initialSelection.row {
            pickerView.selectRow(initialSelection.row, inComponent: initialSelection.column, animated: true)
        }
    }
    
    deinit {
        DQPrint("has deinitialized")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PickerViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return values.count
    }
    
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return values[component].count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return values[component][row]
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        action?(self,pickerView,Index(column: component, row: row),values)
    }
    
}
