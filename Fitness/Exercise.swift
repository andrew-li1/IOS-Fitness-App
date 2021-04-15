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
    
    init (_ n: String, _ t: Int) {
        name = n
        time = t
    }
}
