//
//  LapTableViewCell.swift
//  ClockApp
//
//  Created by Yusuke Takahashi on 2020/06/11.
//  Copyright © 2020年 usk. All rights reserved.
//

import UIKit

class LapTableViewCell: UITableViewCell {
    var titleLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = .white
        return lb
    }()

    var timeLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = .white
        lb.font = UIFont(name: "HelveticaNeue", size: 16)
        return lb
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .black
        selectionStyle = .none
        separatorInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)

        contentView.addSubview(titleLabel)
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true

        contentView.addSubview(timeLabel)
        timeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
