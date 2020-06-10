//
//  SwitchTableViewCell.swift
//  alarm
//
//  Created by Diego Espinosa on 2020-06-02.
//  Copyright © 2020 Diego Espinosa. All rights reserved.
//

import UIKit

class AlarmNameTableViewCell: UITableViewCell {
    
    let textInput: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.isScrollEnabled = false
        textView.text = "Alarm"
        return textView
    }()
    
    var textStr: String {
      return textInput.text!
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(textInput)
        textInput.matchParentText()
    }

    

    required init?(coder: NSCoder) {
        fatalError()
    }
}
