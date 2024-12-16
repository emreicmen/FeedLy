//
//  UploadViewController.swift
//  InstaCloneFirebase3
//
//  Created by Yunus İçmen on 17.01.2024.
//

import UIKit
import Firebase
import FirebaseStorage

class UploadViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    
    let firebaseStorage = Storage.storage()

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(gestureRecognizer)
        
        uploadButton.isHidden = true
        uploadButton.isEnabled = false
        
    }
    
    @IBAction func uploadClicked(_ sender: Any) {
        let storage = Storage.storage()
        let storegeReference = storage.reference()
        let mediaFolder = storegeReference.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data, metadata: nil) { metadata, error in
                if error != nil {
                    DispatchQueue.main.async {
                        self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                    }
                }
                else{
                    imageReference.downloadURL { url, error in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            ///postlar burada kayıt ediliyor
                            let currentDate = Date()
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "dd-MM-yy HH:mm"
                            let dateString = dateFormatter.string(from: currentDate)
                            let firestoreDatabase = Firestore.firestore()

                            do{
                                try firestoreDatabase.collection("Posts").addDocument(data: ["imageUrl": imageUrl,"postedBy": Auth.auth().currentUser!.email,
                                                                             "postComment": self.commentText.text,"date": dateString,"likes": 0]) { error in
                                    if error != nil{
                                        self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                                    }else{
                                        self.imageView.image = UIImage(named: "selectImage")
                                        self.commentText.text = ""
                                        self.tabBarController?.selectedIndex = 0
                                    }
                                }
                                
                                self.tabBarController?.selectedIndex = 0
                            }catch{
                                self.makeAlert(titleInput: "Error!", messageInput: error.localizedDescription ?? "Post yüklenirken Hata!")
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func selectImage(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController,animated: true,completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        picker.dismiss(animated: true)
        uploadButton.isHidden = false
        uploadButton.isEnabled = true
    }
    
    func makeAlert(titleInput:String, messageInput:String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
}

/*

 
 */
