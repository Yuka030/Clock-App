
//
//  RightDetailTableViewCell.swift
//  alarm
//
//  Created by Diego Espinosa on 2020-06-01.
//  Copyright © 2020 Diego Espinosa. All rights reserved.
//

import UIKit

class RightDetailTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    convenience init(title: String){
        self.init(style: .value1, reuseIdentifier: nil)
        textLabel?.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
