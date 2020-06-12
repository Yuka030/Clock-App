import Foundation
struct HMSTimer {
    
    var hour = 0
    var minute = 0
    var second = 0
    var hms = [0, 0, 0]
    var totalTimeInSec = 0
    var currentTimeInSec = 0
    var intCounter = 0
    var isTimerEnded = false
    
    mutating func setTimer() {
        if isTimerEnded {
            hour = hms[0]
            minute = hms[1]
            second = hms[2]
        } else {
            hms[0] = hour
            hms[1] = minute
            hms[2] = second
        }
        totalTimeInSec = calcHMSToSeconds(h: hour, m: minute, s: second)
        intCounter = 0
        currentTimeInSec = totalTimeInSec - intCounter
        isTimerEnded = false
    }
    
    func calcSecondsToHMS()-> (Int, Int, Int) {
        return (currentTimeInSec / 3600, (currentTimeInSec % 3600) / 60, (currentTimeInSec % 3600) % 60)
    }
    
    mutating func timerCountDown(){
        intCounter += 1
        currentTimeInSec = totalTimeInSec - intCounter
        
        if currentTimeInSec == 0 {
            isTimerEnded = true
        }
    }
    
    private func calcHMSToSeconds(h: Int, m: Int, s:Int)->Int {
        return h * 3600 + m * 60 + s
    }
}
