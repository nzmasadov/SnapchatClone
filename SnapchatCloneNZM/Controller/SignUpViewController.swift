//
//  SignUpViewController.swift
//  SnapchatCloneNZM
//
//  Created by Nazim Asadov on 10.02.22.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        colorAdditions()
        
        let gestRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestRecognizer)
    }
    
    
    @IBAction func registerPressed(_ sender: Any) {
        
        if emailTextField.text != "" && passwordTextField.text != "" && usernameTextField.text != "" {
            Firebase.Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { data, error in
                if error != nil {
                    self.showAlert(title: "Error", message: error?.localizedDescription ?? "Something wrong", handler: nil)
                }else{
                    let firestore = Firestore.firestore()
                    let newUsername = ["email": self.emailTextField.text!, "username":self.usernameTextField.text!] as [String:Any]
                    firestore.collection("UserInfo").addDocument(data: newUsername) { error in
                        if error != nil {
                            self.showAlert(title: "Error", message: "Something gets wrong" , handler: nil )
                        }
                    }
                    self.showAlert(title: "Congratulations", message: "Sign up process is succesfull") { UIAlertAction in
                        self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                    }
                }
            }
        }else {
            showAlert(title: "Error", message: "Something wrong", handler: nil)
        }
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func colorAdditions() {
        emailTextField.layer.cornerRadius = 15
        usernameTextField.layer.cornerRadius = 15
        passwordTextField.layer.cornerRadius = 15
        
    }
    
    
}
