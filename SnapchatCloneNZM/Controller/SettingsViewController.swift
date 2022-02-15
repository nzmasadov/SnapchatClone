//
//  SettingsViewController.swift
//  SnapchatCloneNZM
//
//  Created by Nazim Asadov on 06.02.22.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    @IBOutlet weak var logoutButtonOutlet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        logoutButtonOutlet.layer.cornerRadius = 15
    }
    

    @IBAction func logoutPressed(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toMainVC", sender: nil)
        }catch{
            print("error")
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
