//
//  AddUserViewController.swift
//  Fitness
//
//  Created by Jiacheng Li on 4/29/21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AddUserViewController: UIViewController {
    
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    let usersRef = Database.database().reference(withPath: "users")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.isHidden = true
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if let u = user {
                print(u.email)
                print("next")
                self.usersRef.child("\(u.uid)/email").setValue(u.email)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createUser(_ sender: Any) {
        let email = emailText.text!
        let password = passwordText.text!
        Auth.auth().createUser(withEmail: email, password: password, completion: {(result, err) in
            if err != nil {
                self.errorLabel.isHidden = false
                print(err!)
            } else {
                print("created user")
                
                self.dismiss(animated: true, completion: nil)
            }
        })
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
