//
//  Alert.swift
//  SnapchatCloneNZM
//
//  Created by Nazim Asadov on 06.02.22.
//

import UIKit

extension UIViewController {

    func showAlert(title:String, message:String, handler:((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: handler)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    }


