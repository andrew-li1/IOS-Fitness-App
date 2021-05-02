//
//  ExerciseTableViewController.swift
//  Fitness
//
//  Created by Jiacheng Li on 4/1/21.
//

import UIKit
import Firebase

class ExerciseTableViewController: UITableViewController {
//    func didCreate(_ exercise: Exercise) {
//        dismiss(animated: true, completion: nil)
//        print(exercise.name)
//        exercises.append(exercise)
//        exercises = exercises.sorted {$0.name.lowercased() < $1.name.lowercased()}
//        self.tableView.reloadData()
//    }
    
    
    var user: User?
    var exercises = [Exercise]()
    var currentExercise: Exercise?
    let usersRef = Database.database().reference(withPath: "users")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let user = Auth.auth().currentUser {
            let exercisesRef = usersRef.child(user.uid).child("currentRuns")
            exercisesRef.observe(.value, with: { snapshot in
                for child in snapshot.children {
                    if let exercise = Exercise(snapshot: child as! DataSnapshot){
                        self.exercises.append(exercise)
                        self.exercises = self.exercises.sorted {$0.name.lowercased() < $1.name.lowercased()}
                    }
                }
                self.tableView.reloadData()
            })
        }
        
    }

    @IBAction func segueToAddStrength(_ sender: Any) {
        self.performSegue(withIdentifier: "addStrength", sender: self)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // TODO: How many sections? (Hint: we have 1 section and x rows)
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: How many rows in our section?
        return exercises.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: Deque a cell from the table view and configure its UI. Set the label and star image by using cell.viewWithTag(..)
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as UITableViewCell
        if let label = cell.viewWithTag(1) as? UILabel {
            print("isRunning")
            label.text = exercises[indexPath.row].name
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Deselect the cell, and toggle the "favorited" property in your model
        currentExercise = exercises[indexPath.row]
        self.performSegue(withIdentifier: "showStrength", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let svc = segue.destination as? StrengthViewController {
            svc.exercise = currentExercise!
        }
//        if let nvc = segue.destination as? UINavigationController {
//            let asvc = nvc.topViewController as? AddStrengthViewController
//            if let vc = asvc {
//                vc.delegate = self
//            }
//        }
    }
    
    // MARK: - Swipe to delete functionality
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // TODO: If the editing style is deletion, remove the newsItem from your model and then delete the rows. CAUTION: make sure you aren't calling tableView.reloadData when you update your model -- calling both tableView.deleteRows and tableView.reloadData will make the app crash.
        if editingStyle == .delete {
            exercises.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}
