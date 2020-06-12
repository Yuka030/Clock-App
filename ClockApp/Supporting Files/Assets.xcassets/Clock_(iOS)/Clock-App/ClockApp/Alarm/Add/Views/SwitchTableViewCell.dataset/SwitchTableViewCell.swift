//
//  SwitchTableViewCell.swift
//  alarm
//
//  Created by Diego Espinosa on 2020-06-02.
//  Copyright © 2020 Diego Espinosa. All rights reserved.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {
    
    private let categoryLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return lb
    }()
    
    private let priceLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.setContentHuggingPriority(.required, for: .horizontal)
        return lb
    }()
    
    private let switchControl: UISwitch = {
        let sp = UISwitch()
        sp.translatesAutoresizingMaskIntoConstraints = false
        return sp
    }()
    
    var isOn: Bool {
        return switchControl.isOn
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    convenience init(category:String){
        self.init()
        categoryLabel.text = category
        
        let hs = HorizontalStackView(arrangedSubviews: [
        categoryLabel, priceLabel, switchControl
        ], spacing: 15, alignment: .center, distribution: .fill)
        hs.backgroundColor = .black
        contentView.addSubview(hs)
        hs.anchors(topAnchor: contentView.topAnchor, leadingAnchor: contentView.leadingAnchor, trailingAnchor: contentView.trailingAnchor, bottomAnchor: contentView.bottomAnchor, padding: .init(top: 0, left: 18, bottom: 0, right: 20))
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
