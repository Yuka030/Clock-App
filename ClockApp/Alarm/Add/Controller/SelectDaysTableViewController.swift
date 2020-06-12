//
//  SelectDaysTableViewController.swift
//  alarm
//
//  Created by Diego Espinosa on 2020-06-02.
//  Copyright © 2020 Diego Espinosa. All rights reserved.
//

import UIKit
protocol SelectDaysTableViewControllerDelegate: class {
    func didSelect(day: [String])
}

class SelectDaysTableViewController: UITableViewController {

    weak var delegate: SelectDaysTableViewControllerDelegate?
    
    private let cellId = "DaysCell"
    var cellNum = [Int]()
    var daysArray = [String]()
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Repeat"
        tableView.register(RightDetailTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
        tableView.tintColor = .orange
        tableView.backgroundColor = .black
    }

    
//    func printr(){
//        cellNum.sort(by: <)
//        print(cellNum)
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RightDetailTableViewCell
        cell.backgroundColor = .darkGray
        cell.textLabel?.textColor = .white
        
        switch indexPath.row {
        case 1:
            cell.textLabel?.text = "Every Monday"
        case 2:
            cell.textLabel?.text = "Every Tuesday"
        case 3:
            cell.textLabel?.text = "Every Wednesday"
        case 4:
            cell.textLabel?.text = "Every Thursday"
        case 5:
            cell.textLabel?.text = "Every Friday"
        case 6:
            cell.textLabel?.text = "Every Saturday"
        case 7:
            cell.textLabel?.text = "Every Sunday"

        default:
            cell.textLabel?.text = "Every Sunday"
        }
                
        if cellNum.contains(indexPath.row){
            cell.accessoryType = .checkmark
        } else{
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    
        if cellNum.contains(indexPath.row){
            cellNum.remove(at: indexPath.row)// cambiar para buscar el numero en vez del lugar
        } else{
            cellNum.append(indexPath.row)
        }
        
        daysArray.removeAll()
        if cellNum.contains(0){ daysArray.append("Sun")}
        if cellNum.contains(1){ daysArray.append("Mon")}
        if cellNum.contains(2){ daysArray.append("Tue")}
        if cellNum.contains(3){ daysArray.append("Wed")}
        if cellNum.contains(4){ daysArray.append("Thu")}
        if cellNum.contains(5){ daysArray.append("Fri")}
        if cellNum.contains(6){ daysArray.append("Sat")}
        
        
//        printr()
        delegate?.didSelect(day: daysArray)
        tableView.reloadData()
    }

}
