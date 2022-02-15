//
//  UploadVC.swift
//  SnapchatCloneNZM
//
//  Created by Nazim Asadov on 06.02.22.
//

import UIKit
import Firebase

class UploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var uploadButtonOutlet: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(choosePhoto))
        imageView.addGestureRecognizer(gestureRecognizer)
        uploadButtonOutlet.layer.cornerRadius = 18
        uploadButtonOutlet.isEnabled = false
    }
    
    @objc func choosePhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
     //   picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        uploadButtonOutlet.isEnabled = true
    }
    
    @IBAction func uploadPressed(_ sender: Any) {
        
        // Storage
        let storage = Storage.storage()
        let reference = storage.reference()
        
        let mediaFolder = reference.child("Media")
        
        guard let data = imageView.image?.jpegData(compressionQuality: 0.5) else {return}
        let uuid = UUID().uuidString
        
        // Firestore
        
        let imageReference = mediaFolder.child("\(uuid).jpg")
        
        imageReference.putData(data, metadata: nil) { metadata, error in
            if error != nil {
                self.showAlert(title: "Error", message: "Error 404 not found", handler: nil)
            }else {
                imageReference.downloadURL { (url, error) in
                    if error == nil {
                        let imageUrl = url?.absoluteString
                        let fireStore = Firestore.firestore()
                        
                        
                        fireStore.collection("Snaps").whereField("snapOwner", isEqualTo: UserSingleton.sharedUserInfo.username).getDocuments { snapshot, error in
                            if error != nil {
                                self.showAlert(title: "Error", message: error?.localizedDescription ?? "error", handler: nil)
                            }else {
                                if snapshot?.isEmpty == false && snapshot != nil {
                                    for document in snapshot!.documents {
                                        
                                        let documentId = document.documentID
                                        
                                        if var imageUrlArray = document.get("imageUrlArray") as? [String] {
                                            imageUrlArray.append(imageUrl!)
                                            
                                            let additionalDictionary = ["imageUrlArray": imageUrlArray] as [String:Any]
                                            
                                            fireStore.collection("Snaps").document(documentId).setData(additionalDictionary, merge: true) { error in
                                                if error == nil {
                                                    self.tabBarController?.selectedIndex = 0
                                                    self.imageView.image = UIImage(named: "choosePhoto")
                                                    self.uploadButtonOutlet.isEnabled = false

                                                }
                                            }
                                        }
                                    }
                                    
                                
                                }else {
                                    let snapDictionary = ["snapOwner": UserSingleton.sharedUserInfo.username, "imageUrlArray": [imageUrl!], "date": FieldValue.serverTimestamp()] as [String:Any]
                                    fireStore.collection("Snaps").addDocument(data: snapDictionary) { error in
                                        if error != nil {
                                            self.showAlert(title: "Error", message: error?.localizedDescription ?? "Error 404 not found", handler: nil)
                                        }else{
                                            self.tabBarController?.selectedIndex = 0
                                            self.imageView.image = UIImage(named: "choosePhoto")
                                            self.uploadButtonOutlet.isEnabled = false
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
