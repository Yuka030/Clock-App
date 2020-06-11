import UIKit

class WorldClockTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dayDiffLabel: UILabel!
    @IBOutlet weak var timeDiffLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    var worldClock: WorldClock!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(setTime), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode:RunLoop.Mode.default)
    }
    
    @objc func setTime() {
        if (timeLabel?.text) != nil {
            timeLabel.text = getTime()
        }
    }
    
    func getTime() -> String? {
        var timeString = ""
        
        if timeLabel.text != "" {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            formatter.dateFormat = "h:mm"
            formatter.timeZone = TimeZone(identifier: "\(worldClock.country)/\(worldClock.city)")
            
            let timeNow = Date()
            timeString = formatter.string(from: timeNow)
        }
        
        return timeString
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateUI(with worldClock: WorldClock){
        self.worldClock = worldClock
        dayDiffLabel.text = worldClock.dayDiff
        timeDiffLabel.text = worldClock.timeDiff
        cityLabel.text = worldClock.city
        timeLabel.text = worldClock.time
    }
    
}
