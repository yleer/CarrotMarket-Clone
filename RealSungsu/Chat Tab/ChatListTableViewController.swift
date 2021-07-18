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
    
    var messageCellData : [MessageCellData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadRooms()
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageCellData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ChatListTableViewController.chatListCellId, for: indexPath) as! ChatListTableViewCell
        
        if messageCellData.count > 0{
            cell.cellTitle.text = messageCellData[indexPath.row].lastMessage
            cell.textOpponet.text = messageCellData[indexPath.row].opponent
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = Date(timeIntervalSince1970: TimeInterval(messageCellData[indexPath.row].date)!)
        let dateString = dateFormatter.string(from: date)
        cell.dateLabel.text = dateString
                
    

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: Constants.ChatListTableViewController.selectChatRoomSegue, sender: self)
    }
    
    var selectedIndex = 0
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.ChatListTableViewController.selectChatRoomSegue{
            let destinationVC = segue.destination as! ChatViewController
            destinationVC.postOwner = messageCellData[selectedIndex].opponent
            destinationVC.postTitle = messageCellData[selectedIndex].title
        }
    }
    
    private func loadRooms(){
        messageCellData = []
        if let currentUser = Auth.auth().currentUser?.email{
            
            // current user is the seller
            db.collection(Constants.FireStoreChatRoomCollectionName).whereField("opponent", isEqualTo: currentUser).getDocuments { querySnapshot, error in
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
                                        if let snapShot2 = querySnapshot2?.documents {
                                            if snapShot2.count > 0{
                                                if let body = snapShot2[snapShot2.count - 1]["body"] as? String{
                                                    let newCellData = MessageCellData(
                                                        opponent: buyer,
                                                        date: "0",
                                                        lastMessage: body,
                                                        title: doc.data()["title"] as! String
                                                    )
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
                }
            }
            
            // current user is the buyer
            db.collection(Constants.FireStoreChatRoomCollectionName).whereField("sender", isEqualTo: currentUser).getDocuments { querySnapshot, error in
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
                                        if let snapShot2 = querySnapshot2?.documents {
                                            if snapShot2.count > 0{
                                                if let body = snapShot2[snapShot2.count - 1]["body"] as? String,
                                                   let time = snapShot2[snapShot2.count - 1]["timeSent"] as? Double{
                                                    let newCellData = MessageCellData(
                                                        opponent: seller,
                                                        date: String(time),
                                                        lastMessage: body,
                                                        title: doc.data()["title"] as! String
                                                    )
                                                    self.messageCellData.append(newCellData)
                                                }
                                            }
                                            
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
