//
//  TimeInterval+formattedString.swift
//  Stopwatch
//
//  Created by Yusuke Takahashi on 2020/06/11.
//  Copyright © 2020年 usk. All rights reserved.
//

import UIKit

extension TimeInterval {
    func formattedString() -> String {
        let integralTime = Int(floor(self))
        let hours = integralTime / 60 / 60
        let minutes = integralTime / 60 % 60
        let seconds = integralTime % 60
        let ohSeconds = Int(floor(self * 100)) % 100
        return "\(hours != 0 ? "\(hours):" : "")\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds)).\(String(format: "%02d", ohSeconds))"
    }
}
