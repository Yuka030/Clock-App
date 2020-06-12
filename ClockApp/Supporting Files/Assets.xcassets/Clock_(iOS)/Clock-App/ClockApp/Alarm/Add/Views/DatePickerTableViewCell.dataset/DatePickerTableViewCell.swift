//
//  DatePickerTableViewCell.swift
//  alarm
//
//  Created by Diego Espinosa on 2020-06-01.
//  Copyright © 2020 Diego Espinosa. All rights reserved.
//

import UIKit

class DatePickerTableViewCell: UITableViewCell {

    
    let datePicker: UIDatePicker  = {
        let dp = UIDatePicker()
        dp.datePickerMode = .time
        dp.backgroundColor = .black
        dp.setValue(UIColor.white, forKey: "textColor")
        let dateFormatter =  DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = .none
//        dateFormatter.timeStyle = .full
        dp.translatesAutoresizingMaskIntoConstraints = false
        return dp
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(datePicker)
        datePicker.matchParent()
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_ :)), for: .valueChanged)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        //print("Time Changed")
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

}
