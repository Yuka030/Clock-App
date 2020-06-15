//
//  AddRegistrationTableViewController.swift
//  alarm
//
//  Created by Diego Espinosa on 2020-06-01.
//  Copyright © 2020 Diego Espinosa. All rights reserved.
//

import UIKit

class AddRegistrationTableViewController: UITableViewController, SelectSoundTableViewControllerDelegate, SelectDaysTableViewControllerDelegate {
    
    
    // Estas son cada una de las filas
    private let datePicker = DatePickerTableViewCell()
    
    private let repeatCell : RightDetailTableViewCell = {
        let cell = RightDetailTableViewCell(title: "Repeat")
        cell.accessoryType = .disclosureIndicator
        cell.detailTextLabel?.text = "Never"
        cell.backgroundColor = .darkGray
        return cell
    }()
    
    private let alarmName : RightDetailTableViewCell = {
        let cell = RightDetailTableViewCell(title: "Label")
        cell.accessoryType = .disclosureIndicator
        cell.detailTextLabel?.text = "Alarm"
        cell.backgroundColor = .darkGray
        return cell
    }()
    
    private let nametxt = AlarmNameTableViewCell ()
    
    private let soundCell : RightDetailTableViewCell = {
        let cell = RightDetailTableViewCell(title: "Sound")
        cell.accessoryType = .disclosureIndicator
        cell.detailTextLabel?.text = "Radar"
        cell.backgroundColor = .darkGray
        return cell
    }()
    
    
    private let snoozeCell : SwitchTableViewCell = {
        let cell = SwitchTableViewCell(category: "Snooze")
        cell.backgroundColor = .darkGray
        return cell
    }()
    
    //Este es el Delegate para almacenar la informacion
    var addRegistration: ((Registration) -> ())?
    private var sound: Sound?
    private var day: [String]?
    
    // Este es el ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.backgroundColor = .darkText
        let nav = self.navigationController?.navigationBar
        nav?.tintColor = .orange
        nav?.backgroundColor = .black
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.title = "Add Alarm"
        navigationItem.leftBarButtonItem =  UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped(_:)))
        navigationItem.rightBarButtonItem =  UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(doneTapped(_:)))
        updateSound()
        updateDays()
    }
    
    private func updateSound(){
        if let sound = self.sound {
            soundCell.detailTextLabel?.text = sound.soundName
        } else {
            soundCell.detailTextLabel?.text = "Radar"
        }
    }
    
    private func updateDays(){
        if let day = self.day {
            if day.count == 0 {
                repeatCell.detailTextLabel?.text = "Never"
            } else if day.count == 7{
                repeatCell.detailTextLabel?.text = "Every Day"
            } else if day.count == 5 && !day.contains("Sat") && !day.contains("Sun"){
                repeatCell.detailTextLabel?.text = "WeekDays"
            } else if day.count == 3 && day.contains("Fri") && day.contains("Sat") && day.contains("Sun"){
                repeatCell.detailTextLabel?.text = "Weekends"
            } else {
                repeatCell.detailTextLabel?.text = day.joined(separator: " ")
            }
        }
    }
        
        func didSelect(day: [String]) {
            self.day = day
            updateDays()
        }
         
        func didSelect(sounds: Sound) {
            self.sound = sounds
            updateSound()
        }
        
        // Funcion cuando se presiona el boton de Cancelar
        @objc func cancelTapped(_ sender: UIBarButtonItem){
            dismiss(animated: true, completion: nil)
        }
        
        // Fucion cuando se presiona el boton de Save
        @objc func doneTapped(_ sender: UIBarButtonItem){
            let time = datePicker.datePicker.date
            let snooze = snoozeCell.isOn
            //let name = alarmName.textInput.text!
            let name = nametxt.textInput.text!
            let soundObj = Sound(soundName: "Radar")
            
            let registration = Registration(time:time,
                                            day: day ?? [],
                                            name:  name ,
                                            sound: sound ?? soundObj,
                                            snooze: snooze)
            addRegistration?(registration)
            dismiss(animated: true, completion: nil)
            print(registration)
            print("")
//            print("Time: \(time)")
//            print("Days: \(day ?? [])")
//            print("Name: \(name)")
//            print(sound ?? soundObj)
//            print("Snooze: \(snooze)")
        }
        
        // Aca va el numero de secciones en el TableView
        override func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        // Aca va el numero de filas por seccion
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 5
        }
        
        // Aca va lo que pasa cada que se selecciona una fila en el TableView
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            switch (indexPath.section, indexPath.row) {
            case (0,1):
                let selectDaysTVC =  SelectDaysTableViewController()
                selectDaysTVC.delegate = self
                selectDaysTVC.daysArray = day ?? [""]
                navigationController?.pushViewController(selectDaysTVC, animated: true)
            case(0,2):
                let alarmNameTVC = AlarmNameTableViewController()
                navigationController?.pushViewController(alarmNameTVC, animated: true)
            case (0,3):
                let selectSoundTVC =  SelectSoundTableViewController()
                selectSoundTVC.delegate = self
                selectSoundTVC.sound = sound
                navigationController?.pushViewController(selectSoundTVC, animated: true)
            default:
                break
            }
        }
        
        // Esto es lo que se va a mostrar por fila
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            switch (indexPath.section, indexPath.row) {
            case (0,0):
                return datePicker
            case (0,1):
                return repeatCell
            case (0,2):
                return alarmName
            case (0,3):
                return soundCell
            case (0,4):
                return snoozeCell
            default:
                return UITableViewCell()
            }
        }
        
        // Aca se establecen las alturas de las filas del TableView
        override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            switch indexPath.row {
            case 0:
                return 230
            default:
                return  44
            }
        }
}
