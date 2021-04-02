//
//  AddStrengthViewController.swift
//  Fitness
//
//  Created by Jiacheng Li on 4/1/21.
//

import UIKit

protocol AddExerciseDelegate: class {
    func didCreate(_ exercise: Exercise)
}

class AddStrengthViewController: UIViewController {
    
    @IBOutlet weak var workoutName: UITextField!
    weak var delegate: AddExerciseDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        if let exercise = createNewExercise(){
            self.delegate?.didCreate(exercise)
        }
    }
    
    func createNewExercise() -> Exercise? {
        if workoutName.text == "" {
            return nil
        } else {
            print(workoutName.text!)
            return Exercise(workoutName.text!)
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
