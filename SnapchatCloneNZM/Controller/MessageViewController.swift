//
//  MessageViewController.swift
//  SnapchatCloneNZM
//
//  Created by Nazim Asadov on 19.02.22.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

class MessageViewController: UIViewController {
    
    var messages : [Message] = []
    
    
    let db = Firestore.firestore()
    @IBOutlet weak var writeTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
   //     tabBarController?.tabBar.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        readData ()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false

    }
    
    
    
    // 2. save data in DB, when user clicked send button
    @IBAction func sendPressed(_ sender: UIButton) {
        
        db.collection(K.FStore.collectionName)
            .addDocument(data: [K.FStore.senderField : Auth.auth().currentUser?.email!,
                                K.FStore.bodyField : writeTextField.text,
                                K.FStore.dateField : FieldValue.serverTimestamp()]) { err in
                if err != nil {
                    print(err?.localizedDescription ?? "The user message can`t save to Database")
                }else{
                    print("Save succesfully")
                    DispatchQueue.main.async {
                        self.writeTextField.text = ""
                    }
                }
            }
    }
    
    // 3. Read data
    func readData() {
        
        //   self.message.removeAll(keepingCapacity: false)
        
        
        db.collection(K.FStore.collectionName).order(by: K.FStore.dateField, descending: false).addSnapshotListener { querySnapshots, error in
            
            self.messages = [] // there will be a problem
            
            if error != nil {
                print("error")
            }else {
                if let queryDocuments = querySnapshots?.documents {
                    for document in queryDocuments {
                        //   let docID = document.documentID
                        
                        let data = document.data()
                        guard let messageSender = data[K.FStore.senderField] as? String,
                              let messageField = data[K.FStore.bodyField] as? String else { return }
                        let newMessage = Message(sender: messageSender, body: messageField)
                        self.messages.append(newMessage)
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            // 5. Scroll messages
                            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        
        do{
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toWelcomeVC", sender: nil)
        }catch{
            print("error")
        }
        
    }
    
}

// firs we created table view and add all elements there. then created a cell with .xib file and register it. be careful with identifier.
extension MessageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        let message = messages[indexPath.row]
        cell.label.text = message.body
        
        // 4. Message and Sender section
        if message.sender == Auth.auth().currentUser?.email {
            cell.rightImageView.isHidden = false
            cell.leftImageView.isHidden = true
            cell.messageBubble.backgroundColor = K.BrandColors.lightBlue
            cell.label.textColor = #colorLiteral(red: 0.1098039216, green: 0.3960784314, blue: 0.5490196078, alpha: 1)
        }else {
            cell.rightImageView.isHidden = true
            cell.leftImageView.isHidden = false
            cell.messageBubble.backgroundColor = K.BrandColors.darkBlue
            cell.label.textColor = UIColor.white
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    
}
