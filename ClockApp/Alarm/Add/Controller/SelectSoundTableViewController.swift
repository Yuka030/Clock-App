//
//  SelectSoundTableViewController.swift
//  alarm
//
//  Created by Diego Espinosa on 2020-06-04.
//  Copyright © 2020 Diego Espinosa. All rights reserved.
//

import UIKit
protocol SelectSoundTableViewControllerDelegate: class {
    func didSelect(sounds: Sound)
}

class SelectSoundTableViewController: UITableViewController {
    
    weak var delegate: SelectSoundTableViewControllerDelegate?
    
    var choosed = 0
    
    private let cellId = "SoundCell"
    var sound: Sound?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Select Sound"
        tableView.register(RightDetailTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  Sound.all.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let sounds = Sound.all[indexPath.row]
       
        cell.textLabel?.text = sounds.soundName
       
        if indexPath.row == choosed {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        choosed = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
        sound = Sound.all[choosed]
        delegate?.didSelect(sounds: sound!)
        tableView.reloadData()
    }
    
}
