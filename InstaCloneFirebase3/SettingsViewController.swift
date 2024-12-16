//
//  SettingsViewController.swift
//  InstaCloneFirebase3
//
//  Created by Yunus İçmen on 17.01.2024.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toViewController", sender: nil)
        }catch{
            self.makeAlert(titleInput: "Error", messageInput: "Error when logout!")
        }
        
    }
    
    func makeAlert(titleInput:String,messageInput:String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButon = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButon)
        self.present(alert, animated: true,completion: nil)
    }
}
