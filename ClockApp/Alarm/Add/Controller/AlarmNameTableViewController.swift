//
//  AlarmNameTableViewController.swift
//  alarm
//
//  Created by Diego Espinosa on 2020-06-10.
//  Copyright © 2020 Diego Espinosa. All rights reserved.
//

import UIKit
protocol AlarmTableViewControllerDelegate: class {
    func didChanged(Registration: String)
}
class AlarmNameTableViewController: UITableViewController {
    
    weak var delegate: AlarmTableViewControllerDelegate?
    private let cellId = "AlarmNameCell"
    var name: String?

    private let alarmName : AlarmNameTableViewCell = {
        let cell = AlarmNameTableViewCell()
        return cell
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .black
        navigationItem.title = "Add Alarm"
        navigationItem.titleView?.backgroundColor = .black
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .black
        
        self.tableView.contentInset = UIEdgeInsets( top: self.view.frame.size.height/3, left: 0 , bottom: 0, right: 0)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return alarmName
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
}
