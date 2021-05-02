//
//  Exercise.swift
//  Fitness
//
//  Created by Jiacheng Li on 4/1/21.
//

import Foundation
import UIKit
import Firebase

struct Exercise {
    let ref: DatabaseReference?
    var name = ""
    var time: Int
    var distance: Double
    
    init (_ n: String, _ t: Int, _ d: Double) {
        name = n
        time = t
        distance = d
        ref = nil
    }
    
    init?(snapshot: DataSnapshot) {
      guard
        let value = snapshot.value as? [String: AnyObject],
        let name = value["name"] as? String,
        let time = value["time"] as? Int,
        let distance = value["distance"] as? Double else {
        return nil
      }
        
        self.ref = snapshot.ref
        self.name = name
        self.time = time
        self.distance = distance
    }
    
    func toAnyObject() -> Any {
      return [
        "name": name,
        "time": time,
        "distance": distance
      ]
    }
}
