//
//  FeedCelll.swift
//  InstaCloneFirebase3
//
//  Created by Yunus İçmen on 17.01.2024.
//

import UIKit
import Firebase

class FeedCelll: UITableViewCell {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var doucmentIdLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    
    let firestoreDatabase = Firestore.firestore()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    @IBAction func likeButtonClicked(_ sender: Any) {
        if let likeCount = Int(likeLabel.text!){
            let likeStore = ["likes" : likeCount + 1] as [String : Any]
            firestoreDatabase.collection("Posts").document(doucmentIdLabel.text!).setData(likeStore, merge: true)
        }
    }
}
