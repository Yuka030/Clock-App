import UIKit
import AVFoundation

enum TimerStatus: String {
    case Start = "Start"
    case Pause = "Pause"
    case Resume = "Resume"
}

class TimerViewController: UIViewController {
    
    var hmsTimer: HMSTimer?
    var timer: Timer?
    var timerStatus = TimerStatus.Start
    private var hoursDataSource = TimeDataSource.hoursDataSource
    private let minutesDataSource = TimeDataSource.minutesDataSource
    private let secondsDataSource = TimeDataSource.secondsDataSource
    var soundIdRing:SystemSoundID?
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scheduledTimeLabel: UILabel!
    @IBOutlet weak var timerLabelStackView: UIStackView!
    @IBOutlet weak var hourPickerView: UIPickerView!
    @IBOutlet weak var minutePickerView: UIPickerView!
    @IBOutlet weak var secondPickerView: UIPickerView!
    @IBOutlet weak var hmsPickerStackView: UIStackView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var timerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hmsTimer = HMSTimer()
        updateScheduledTimeLabelUI()
        hourPickerView.dataSource = self
        hourPickerView.delegate = self
        hourPickerView.setValue(UIColor.white, forKeyPath: "textColor")
        minutePickerView.dataSource = self
        minutePickerView.delegate = self
        minutePickerView.setValue(UIColor.white, forKeyPath: "textColor")
        secondPickerView.dataSource = self
        secondPickerView.delegate = self
        secondPickerView.setValue(UIColor.white, forKeyPath: "textColor")
        updateUI()
        soundIdRing = 1000
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateUI() {
        switch timerStatus {
        case TimerStatus.Start:
            updateTimerLabelUI()
            hmsPickerStackView.isHidden = false
            timerLabelStackView.isHidden = true
            timerButton.setTitle("Start", for: .normal)
            cancelButton.isEnabled = false
            timerButton.setTitleColor(.green, for: .normal)
            cancelButton.setTitleColor(.darkGray, for: .disabled)
            updateTimerButtonUI()
            
        case TimerStatus.Pause:
            hmsPickerStackView.isHidden = true
            timerLabelStackView.isHidden = false
            timerButton.setTitle("Pause", for: .normal)
            cancelButton.isEnabled = true
            timerButton.setTitleColor(.orange, for: .normal)
            cancelButton.setTitleColor(.white, for: .disabled)
            
        case TimerStatus.Resume:
            updateTimerLabelUI()
            hmsPickerStackView.isHidden = true
            timerLabelStackView.isHidden = false
            timerButton.setTitle("Resume", for: .normal)
            cancelButton.isEnabled = true
            timerButton.setTitleColor(.green, for: .normal)
            cancelButton.setTitleColor(.white, for: .disabled)
        }
    }
    
    func updateTimerButtonUI(){
        if hmsTimer!.totalTimeInSec == 0 {
            timerButton.isEnabled = false
        } else {
            timerButton.isEnabled = true
        }
    }
    
    func updateTimerLabelUI() {
        let(h, m, s) = hmsTimer!.calcSecondsToHMS()
        let hString = h < 10 ? "0" + String(h) : String(h)
        let mString = m < 10 ? "0" + String(m) : String(m)
        let sString = s < 10 ? "0" + String(s) : String(s)
        timerLabel.text = "\(h <= 0 ? "" : hString + " : ")\(mString) : \(sString)"
    }
    
    func updateScheduledTimeLabelUI() {
        let curDate = Date()
        let calendar = Calendar.current
        let scheduledDate = curDate.addingTimeInterval(TimeInterval(hmsTimer!.totalTimeInSec))
        let curTimeH = calendar.component(.hour, from: scheduledDate)
        let curTimeM = calendar.component(.minute, from: scheduledDate)
        scheduledTimeLabel.text = "\(curTimeH) : \(curTimeM < 10 ? "0" + String(curTimeM) : String(curTimeM))"
    }
    
    func initializeTimer(){
        timer!.invalidate()
        hmsTimer!.setTimer()
        timerStatus = TimerStatus.Start
        updateUI()
    }
    
    @IBAction func timerButtonTapped(_ sender: UIButton) {
        timerStatus = TimerStatus(rawValue: sender.titleLabel!.text!)!
        
        switch timerStatus {
        case TimerStatus.Start:
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            timerStatus = TimerStatus.Pause
            
        case TimerStatus.Pause:
            timer!.invalidate()
            timerStatus = TimerStatus.Resume
            
        case TimerStatus.Resume:
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            timerStatus = TimerStatus.Pause
        }
        
        updateUI()
        updateScheduledTimeLabelUI()
    }
    
    @objc func updateTimer(){
        hmsTimer!.timerCountDown()
        updateTimerLabelUI()
        
        if hmsTimer!.isTimerEnded {
            initializeTimer()
            AudioServicesPlaySystemSound(soundIdRing!)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        initializeTimer()
    }
    
    @IBAction func unwindToTimerController(sague: UIStoryboardSegue){
        if sague.identifier == AddRingtoneTableViewController.unwindSagueId {
            let sourceVC = sague.source as! AddRingtoneTableViewController
            soundIdRing = SystemSoundID(sourceVC.ringtone!.id)
        }
    }
}

extension TimerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 0:
            return hoursDataSource.count
        case 1:
            return minutesDataSource.count
        default:
            return secondsDataSource.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 0:
            return hoursDataSource[row]
        case 1:
            return minutesDataSource[row]
        default:
            return secondsDataSource[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 0:
            hmsTimer!.hour = Int(hoursDataSource[row])!
        case 1:
            hmsTimer!.minute = Int(minutesDataSource[row])!
        default:
            hmsTimer!.second = Int(secondsDataSource[row])!
        }
        
        hmsTimer!.setTimer()
        updateTimerLabelUI()
        updateTimerButtonUI()
    }
}
