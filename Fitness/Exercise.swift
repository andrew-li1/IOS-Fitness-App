//
//  Exercise.swift
//  Fitness
//
//  Created by Jiacheng Li on 4/1/21.
//

import Foundation
import UIKit

struct Exercise {
    var name = ""
    var time: Int
    var distance: Double
    
    init (_ n: String, _ t: Int, _ d: Double) {
        name = n
        time = t
        distance = d
    }
}
