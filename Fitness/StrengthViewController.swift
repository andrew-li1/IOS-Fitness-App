//
//  StrengthViewController.swift
//  Fitness
//
//  Created by Jiacheng Li on 4/1/21.
//

import UIKit

class StrengthViewController: UIViewController {
    
    @IBOutlet weak var exerciseName: UILabel!
    var exercise : Exercise?

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
    var seconds: Int = 60
    var timer = Timer()
 
    var isTimerRunning = false
    var resumeTapped = false
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        if isTimerRunning == false {
            runTimer()
            self.startButton.isEnabled = false
        }
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(StrengthViewController.updateTimer)), userInfo: nil, repeats: true)
        isTimerRunning = true
        pauseButton.isEnabled = true
    }
    
    @IBAction func pauseButtonPressed(_ sender: UIButton) {
        if self.resumeTapped == false {
            timer.invalidate()
            isTimerRunning = false
            self.resumeTapped = true
            self.pauseButton.setTitle("Resume",for: .normal)
        } else {
            runTimer()
            self.resumeTapped = false
            isTimerRunning = true
            self.pauseButton.setTitle("Pause",for: .normal)
        }
    }
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        timer.invalidate()
        seconds = exercise?.time ?? 60
        timerLabel.text = timeString(time: TimeInterval(seconds))
        isTimerRunning = false
        resumeTapped = false
        self.pauseButton.setTitle("Pause",for: .normal)
        pauseButton.isEnabled = false
        startButton.isEnabled = true
    }
    
    @objc func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
            //Send alert to indicate time's up.
        } else {
            seconds -= 1
            timerLabel.text = timeString(time: TimeInterval(seconds))
//            timerLabel.text = String(seconds)
        }
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exerciseName.text = exercise?.name
        seconds = exercise?.time ?? 60
        timerLabel.text = timeString(time: TimeInterval(seconds))
        // Do any additional setup after loading the view.
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
