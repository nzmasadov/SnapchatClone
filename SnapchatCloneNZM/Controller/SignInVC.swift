//
//  ViewController.swift
//  SnapchatCloneNZM
//
//  Created by Nazim Asadov on 06.02.22.
//

import UIKit
import Firebase

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorAdditions()
        let gestRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestRecognizer)
        
    }
    
    @IBAction func signinPressed(_ sender: Any) {
        
        if emailText.text != "" && passwordText.text != "" {
            
            Firebase.Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { data, error in
                if error != nil {
                    self.showAlert(title: "Error", message: error?.localizedDescription ?? "Something wrong", handler: nil)
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }else {
            self.showAlert(title: "Error", message: "Please fill in the blanks", handler: nil)
        }
        
    }
    
    @IBAction func signupPressed(_ sender: Any) {
        performSegue(withIdentifier: "toSignupVC", sender: nil)
    }
    
    
    
    func colorAdditions() {
        emailText.layer.cornerRadius = 15
        passwordText.layer.cornerRadius = 15
        
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

