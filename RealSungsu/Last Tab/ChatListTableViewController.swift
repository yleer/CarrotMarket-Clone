//
//  ChatListTableViewController.swift
//  RealSungsu
//
//  Created by Yundong Lee on 2021/07/09.
//

import UIKit
import Firebase

class ChatListTableViewController: UITableViewController {
    
    let db = Firestore.firestore()
    
    var messageCellData : [MessageCellData] = []{
        didSet{
            print(messageCellData)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadRooms()
    }
    
    // MARK: - Table view data source
    

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageCellData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatListCell", for: indexPath) as! ChatListTableViewCell
    
        cell.cellTitle.text = messageCellData[indexPath.row].lastMessage
        cell.textOpponet.text = messageCellData[indexPath.row].opponent
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "select a chat", sender: self)
    }
    
    var selectedIndex = 0
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "select a chat"{
            let destinationVC = segue.destination as! ChatViewController
            destinationVC.postOwner = messageCellData[selectedIndex].opponent
            destinationVC.postTitle = messageCellData[selectedIndex].title
        }
    }
    
    private func loadRooms(){
        if let currentUser = Auth.auth().currentUser?.email{
            
            // current user is the seller
            db.collection("rooms").whereField("opponent", isEqualTo: currentUser).getDocuments { querySnapshot, error in
                if let e = error{
                    print(e)
                }else{
                    if let snapShot = querySnapshot?.documents{
                        for doc in snapShot{
                            if let buyer = doc["sender"] as? String{
                                doc.reference.collection("messages").getDocuments { querySnapshot2, error in
                                    
                                    if let e = error{
                                        print(e)
                                    }else{
                                        if let snapShot2 = querySnapshot2?.documents, let body = snapShot2[snapShot2.count - 1]["body"] as? String{
                                            let newCellData = MessageCellData(opponent: buyer, date: "0", lastMessage: body, title: doc.data()["title"] as! String)
                                            self.messageCellData.append(newCellData)
                                            
                                            DispatchQueue.main.async {
                                                self.tableView.reloadData()
                                            }
                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                }
            }
            
            
            // current user is the buyer
            db.collection("rooms").whereField("sender", isEqualTo: currentUser).getDocuments { querySnapshot, error in
                if let e = error{
                    print(e)
                }else{
                    if let snapShot = querySnapshot?.documents{
                        for doc in snapShot{
                            if let seller = doc["opponent"] as? String{
                                doc.reference.collection("messages").getDocuments { querySnapshot2, error in
                                    
                                    if let e = error{
                                        print(e)
                                    }else{
                                        if let snapShot2 = querySnapshot2?.documents, let body = snapShot2[snapShot2.count - 1]["body"] as? String{
                                            let newCellData = MessageCellData(opponent: seller, date: "0", lastMessage: body, title: doc.data()["title"] as! String)
                                            self.messageCellData.append(newCellData)
                                        }
                                        
                                        DispatchQueue.main.async {
                                            self.tableView.reloadData()
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
//if let snapShot = querySnapshot?.documents{
//    for doc in snapShot{
//        if let messageSender = doc["sender"] as? String, let body = doc["body"] as? String{
//            let newMessage = MessageModel(sender: messageSender, body: body)
//            self.messages.append(newMessage)
//        }
//
//        DispatchQueue.main.async {
//            self.messageTableView.reloadData()
//        }
//
//    }
//}

// 상대방 이름, 날짜, 마지막 대화 글.
