//
//  FeedVC.swift
//  SnapchatCloneNZM
//
//  Created by Nazim Asadov on 06.02.22.
//

import UIKit
import Firebase
import SDWebImage

class FeedVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let firestoreDatabase = Firestore.firestore()
    
    var snapArray = [SnapModel]()
    var choosenSnap: SnapModel?
    var timeLeft: Int?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getSnapsFromFirestore()
        getUserInfo()
    }
    
    
    @IBAction func toMessage(_ sender: Any) {
        performSegue(withIdentifier: K.messageSegue, sender: nil)
    }
    
    func getUserInfo() {
        
        firestoreDatabase.collection("UserInfo").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { snapshot, error in
            if error != nil {
                self.showAlert(title: "Error", message: error?.localizedDescription ?? "Something got wrong", handler: nil)
            }else{
                if snapshot?.isEmpty == false && snapshot != nil {
                    
                    for document in snapshot!.documents {
                        if let username = document.get("username") as? String {
                            UserSingleton.sharedUserInfo.email = Auth.auth().currentUser!.email!
                            UserSingleton.sharedUserInfo.username = username
                        }
                    }
                }else {
                    self.showAlert(title: "Error", message: "Error 404 not found", handler: nil)
                }
            }
        }
    }
    
    
    func getSnapsFromFirestore() {
        
        firestoreDatabase.collection("Snaps").order(by: "date", descending: true).addSnapshotListener{ (snapshot, error) in
            if error != nil {
                self.showAlert(title: "Error", message: error?.localizedDescription ?? "error", handler: nil)
            }else{
                if snapshot?.isEmpty == false && snapshot != nil {
                    self.snapArray.removeAll(keepingCapacity: false)
                    for document in snapshot!.documents {
                        
                        let documentId = document.documentID
                        
                        guard let snapOwner = document.get("snapOwner") as? String else {return}
                        guard let imageUrlArray = document.get("imageUrlArray") as? [String] else {return}
                        guard let date = document.get("date") as? Timestamp else {return}
                        if let differenceTime = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour{
                            if differenceTime >= 24 {
                                self.firestoreDatabase.collection("Snaps").document(documentId).delete { error in
                                    if error != nil {
                                        self.showAlert(title: "Error", message: error?.localizedDescription ?? "Error 403 not found", handler: nil)
                                    }
                                }
                            }else {
                                
                                let snap = SnapModel(username: snapOwner, imageUrlArray: imageUrlArray, date: date.dateValue(), timeDifference: 24 - differenceTime)
                                self.snapArray.append(snap)
                            }
                        }
                        
                        
                    
                    }
                    self.tableView.reloadData()
                }
            }
            
        }
        
    }
}

extension FeedVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        snapArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedViewCell") as! FeedViewCell
        
        
        
        
        
        cell.feedImageView.sd_setImage(with: URL(string: snapArray[indexPath.row].imageUrlArray[0])) // duzelt bunu sifirinci elemani goturur
        
        
        
        
        
        cell.feedUserNameLbl.text = snapArray[indexPath.row].username
        return cell
    }
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSnapVC" {
            let destinationVC = segue.destination as! SnapViewController
            destinationVC.selectedSnap = choosenSnap
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        choosenSnap = self.snapArray[indexPath.row]
        performSegue(withIdentifier: "toSnapVC", sender: nil)
    }
}
