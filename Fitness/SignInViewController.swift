//
//  SignInViewController.swift
//  Fitness
//
//  Created by Jiacheng Li on 4/29/21.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    
    @IBOutlet weak var errorMessage: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorMessage.isHidden = true
        emailText.text = ""
        passwordText.text = ""
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            errorMessage.isHidden = true
            emailText.text = ""
            passwordText.text = ""
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        let email = emailText.text!
        let password = passwordText.text!
        
        Auth.auth().signIn(withEmail: email, password: password, completion: {(result, err) in
            if err != nil {
                self.errorMessage.isHidden = false
                print(err!)
            } else {
                print("Successful Login")
                self.performSegue(withIdentifier: "tableViewSegue", sender: self)
            }
        })
        
        
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "addUserSeque", sender: self)
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
