//
//  FeedViewController.swift
//  InstaCloneFirebase3
//
//  Created by Yunus İçmen on 17.01.2024.
//

import UIKit
import SDWebImage
import Firebase

class FeedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    var dateArray = [String]()
    ///7 kapsamında ekeldik.DocmentID'leri çekip bu diziye atacağız.Sonrasında hangi postun documentID'si dizideyse o postun like sayısını artıracağız
    var documentIdArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        ///6'da yazığımız verileri çekmek için olan fonksiyonu didLoad altında çağırmamız gerekli
        getDataFromFirestore()
    }
    
    ///5.1 kapsamında eklendi
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    ///5.1 kapsamında eklendi
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        ///Burada tableview cell'inin FeedCell'deki cell olacağını belirttik
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCelll
        cell.emailLabel.text = userEmailArray[indexPath.row]
        cell.likeLabel.text = String(likeArray[indexPath.row])
        cell.commentLabel.text = userCommentArray[indexPath.row]
        cell.dateLabel.text = dateArray[indexPath.row]
        cell.userImageView.sd_setImage(with: URL(string: userImageArray[indexPath.row]))
        ///7'de eklendi
        cell.doucmentIdLabel.text = documentIdArray[indexPath.row]
        
        return cell
    }
    //6 burada verileri çekip FeedCell'e basıp göstereceğiz
    func getDataFromFirestore(){
        let firestoreDatabase = Firestore.firestore()
        firestoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { snapshot, error in ///Burada snapshot verilerin hepsini dizi olarak tutar
            if error != nil {
                print(error?.localizedDescription)
            }else{
                if snapshot?.isEmpty != true && snapshot != nil {
                    ///Burada arrayarin içlerini boşaltıyoruz ki eklenen veriyle birlikte önceki veriler de eklenmesin. Çoklmayı önlüyoruz
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    self.dateArray.removeAll(keepingCapacity: false)
                    ///7 kapsamında eklendi
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    
                    ///Burada verileri döngüye alıp tek tek içeriden çekeceğiz
                    for document in snapshot!.documents{
                        let documentID = document.documentID
                        ///7'de eklendi
                        self.documentIdArray.append(documentID)
                        
                        if let postedBy = document.get("postedBy") as? String{
                            self.userEmailArray.append(postedBy)
                        }
                        if let postComment = document.get("postComment") as? String{
                            self.userCommentArray.append(postComment)
                        }
                        if let postDate = document.get("date") as? String{
                            self.dateArray.append(postDate)
                        }
                        if let likes = document.get("likes") as? Int{
                            self.likeArray.append(likes)
                        }
                        if let image = document.get("imageUrl") as? String{
                            self.userImageArray.append(image)
                        }
                    }
                }
                self.tableView.reloadData()

            }
        }
    }
    


}
