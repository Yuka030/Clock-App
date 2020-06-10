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
        navigationItem.title = "Add Alarm"
        tableView.tableFooterView = UIView()

    }


    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return alarmName
    }
    
}
