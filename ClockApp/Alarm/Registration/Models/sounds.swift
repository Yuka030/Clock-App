//
//  sounds.swift
//  alarm
//
//  Created by Diego Espinosa on 2020-06-03.
//  Copyright © 2020 Diego Espinosa. All rights reserved.
//

import Foundation

struct Sound: Equatable{
    var soundName: String
    
    static var all: [Sound]{
        return [
            Sound(soundName: "Radar"),
            Sound(soundName: "Apex"),
            Sound(soundName: "Beacon"),
            Sound(soundName: "Bulletin"),
            Sound(soundName: "By the Seaside"),
            Sound(soundName: "Chismes"),
            Sound(soundName: "Circuit"),
            Sound(soundName: "Constellation"),
            Sound(soundName: "Cosmic"),
            Sound(soundName: "Crystals")]
    }
    
//    static func == (lhs: sounds, rhs: sounds) -> Bool{
//        return lhs.id == rhs.id
//    }
}
