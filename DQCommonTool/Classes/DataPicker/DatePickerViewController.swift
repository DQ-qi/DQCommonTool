//
//  DatePickerViewController.swift
//  DQCommonTool
//
//  Created by dengqi on 2019/12/10.
//

import UIKit

public extension UIAlertController {
    
    func addDatePicker(model: UIDatePicker.Mode,date: Date?, minimunDate: Date? = nil,
                       maximunDate: Date? = nil, action: DatePickerViewController.Action?) {
        let datePicker = DatePickerViewController.init(model: model, date: date, minimunDate: minimunDate, maximunDate: maximunDate, action: action)
        set(vc: datePicker, height: 217)
    }
    
}

public class DatePickerViewController : UIViewController {
    
    public typealias Action = (_ date: Date)->()
    
    fileprivate var action: Action?
    
    lazy var datePicker: UIDatePicker = { [unowned self] in
        $0.addTarget(self, action: #selector(actionForDatePicker), for: .valueChanged)
        return $0
    }(UIDatePicker())
    
    required init(model: UIDatePicker.Mode, date: Date? = nil, minimunDate: Date? = nil,
                  maximunDate: Date? = nil,action: Action?) {
        super.init(nibName: nil, bundle: nil)
        datePicker.datePickerMode = model
        datePicker.date = date ?? Date()
        datePicker.minimumDate = minimunDate
        datePicker.maximumDate = maximunDate
        let locale = Locale.current
        datePicker.locale = locale
        self.action = action
        view = datePicker
    }
    
    override public func loadView() {
        view = datePicker
    }
    
    @objc func actionForDatePicker() {
        action?(datePicker.date)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        DQPrint("has deinitialized")
    }
    
}
