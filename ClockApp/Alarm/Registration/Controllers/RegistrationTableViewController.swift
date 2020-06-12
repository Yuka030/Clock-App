//
//  RegistrationTableViewController.swift
//  alarm
//
//  Created by Diego Espinosa on 2020-06-01.
//  Copyright © 2020 Diego Espinosa. All rights reserved.
//


import UIKit
import UserNotifications

class RegistrationTableViewController: UITableViewController {
    private let cellId = "RegistrationCell"
    private var registrations = [Registration]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {didAlow, error in})
        tableView.backgroundColor = .black
        let nav = self.navigationController?.navigationBar
        nav?.tintColor = .orange
        nav?.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Alarm"
        navigationItem.rightBarButtonItem =  UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewRegistrationTVC(_:)))
        tableView.register(RegistrationTableViewCell.self, forCellReuseIdentifier: cellId)
        navigationItem.leftBarButtonItem = editButtonItem
        tableView.tableFooterView = UIView() // only divisors to cells in use 
    }
    
    @objc func addNewRegistrationTVC(_ sender: UIBarButtonItem){
        let addRegistrationTVC = AddRegistrationTableViewController(style: .grouped) //static table view
        addRegistrationTVC.addRegistration  = addNew
        let embedNav = UINavigationController(rootViewController: addRegistrationTVC)
        present(embedNav, animated: true, completion: nil) // modally (Bottom to Top)
    }
    
    func addNew(registration:Registration){
        registrations.append(registration)
        tableView.insertRows(at: [IndexPath(row: registrations.count - 1 , section: 0)], with: .automatic)
    }
    
    @objc func switchChanged(_ sender : UISwitch!){
        if sender.isOn {
        let content = UNMutableNotificationContent()
        content.title = "Alarm"
        content.sound = .default
        
            
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: false)
        let request = UNNotificationRequest(identifier: "timmerDone", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return registrations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RegistrationTableViewCell
        let registration = registrations[indexPath.row]
        let dateFormatter =  DateFormatter()
        dateFormatter.timeStyle = .short
        cell.textLabel?.text = "\(dateFormatter.string(from: registration.time))"
        cell.textLabel?.font = UIFont.systemFont(ofSize: 60, weight: UIFont.Weight.thin)
        cell.textLabel?.textColor = .white
        
        if registration.day == []{
            cell.detailTextLabel?.text = "\(registration.name)"
        } else {
            var shorterDays = ""
            if registration.day == ["Sun", "Fri", "Sat"]{
                shorterDays = "every weekend"
                cell.detailTextLabel?.text = " \(registration.name), \(shorterDays)"
            } else if registration.day == ["Mon", "Tue", "Wed", "Thu", "Fri"]{
                shorterDays = "every weekday"
                cell.detailTextLabel?.text = " \(registration.name), \(shorterDays)"
            } else {
                cell.detailTextLabel?.text = " \(registration.name), \(registration.day.joined(separator: " "))"
            }
        }
        
        cell.detailTextLabel?.textColor = .white
        cell.backgroundColor = .black
        
        let switchView = UISwitch(frame: .zero)
        switchView.setOn(false, animated: true)
        switchView.tag = indexPath.row // for detect which row switch Changed
        switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        cell.accessoryView = switchView
                
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        registrations.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
