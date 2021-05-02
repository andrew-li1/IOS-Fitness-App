//
//  AddStrengthViewController.swift
//  Fitness
//
//  Created by Jiacheng Li on 4/1/21.
//

import UIKit
import Firebase


class AddStrengthViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    let minutesArray = Array(0...59)
    let secondsArray = Array(0...59)
    
    var minutes: Int = 0
    var seconds: Int = 0
    var time = 0
    var test = 0
    var userUID : String? = nil
    var activeUser: User? = nil
    let usersRef = Database.database().reference(withPath: "users")

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return minutesArray.count
        } else {
            return secondsArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return String(minutesArray[row])
        } else {
            return String(secondsArray[row])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            minutes = minutesArray[row]
        } else {
            seconds = secondsArray[row]
        }
        time = 60 * minutes + seconds
        print(time)
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 100.0
    }
    
    
    @IBOutlet weak var workoutName: UITextField!
    @IBOutlet weak var workoutDistance: UITextField!
    @IBOutlet weak var timePicker: UIPickerView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        timePicker.delegate = self
        timePicker.dataSource = self
        // Do any additional setup after loading the view.
        
        self.activeUser = Auth.auth().currentUser
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        if let exercise = createNewExercise(){
            if let user = self.activeUser {
                self.usersRef.child(user.uid).child("currentRuns").childByAutoId().setValue(exercise.toAnyObject())
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func createNewExercise() -> Exercise? {
        if workoutName.text == "" || workoutDistance.text == "" || time == 0 {
            return nil
        } else {
            if let workoutDistance = Double(workoutDistance.text!) {
                return Exercise(workoutName.text!, time, workoutDistance)
            } else {
                return nil
            }
            
        }
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
