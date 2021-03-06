//
//  ChatViewController.swift
//  RealSungsu
//
//  Created by Yundong Lee on 2021/07/08.
//

import UIKit
import Firebase

class ChatViewController: UIViewController{
    
    @IBOutlet var messageTableView: UITableView!
    @IBOutlet var messageTextField: UITextField!
    
    var messages : [MessageModel] = []{
        didSet{
            messageTableView.reloadData()
        }
    }
   
    let db = Firestore.firestore()
    var postOwner : String?
    var postTitle : String?
    
    var documentName : String?
    
    @IBAction func sendButton(_ sender: UIButton) {
        if let title = postTitle, let currentUser = Auth.auth().currentUser?.email, let postUser = postOwner, let messageBody = messageTextField.text, let docName = documentName{
            
            db.collection(Constants.FireStoreChatRoomCollectionName).document(docName).setData(
                [
                    "sender" : currentUser,
                    "opponent" : postUser,
                    "title" : title
                ]) { e in
                if let error = e{
                    print(error)
                }else{
                    print("good")
                }
            }
            
            db.collection(Constants.FireStoreChatRoomCollectionName).document(docName).collection("messages").addDocument(
                data: [
                    "sender" : currentUser,
                    "body" : messageBody,
                    "timeSent" : Date().timeIntervalSince1970
                ]
            ) { error in
                if let e = error{
                    print(e)
                }else{
                    print("sent")
                }
            }
        }
        
        messageTextField.text = ""
    }
    
    private func getCollectionName(){
        if let currentUser = Auth.auth().currentUser?.email, let postUser = postOwner, let title = postTitle {
            
            if currentUser > postUser{
                documentName = currentUser + "&" + postUser + "&" + title
            }else{
                documentName = postUser + "&" + currentUser + "&" + title
            }
        }
    }
    
    private func loadMessages(){
        getCollectionName()
        
        db.collection(Constants.FireStoreChatRoomCollectionName)
            .document(documentName!)
            .collection("messages")
            .order(by: "timeSent")
            .addSnapshotListener{ querySnapshot, error in
            if let e = error{
                print(e)
            }else{
                self.messages = []
                if let snapShot = querySnapshot?.documents{
                    for doc in snapShot{
                        if let messageSender = doc["sender"] as? String, let body = doc["body"] as? String{
                            let newMessage = MessageModel(sender: messageSender, body: body)
                            self.messages.append(newMessage)
                        }
                        
                        DispatchQueue.main.async {
                            self.messageTableView.reloadData()
                            print("not")
                            let index = IndexPath(row: self.messages.count - 1, section: 0)
                            self.messageTableView.scrollToRow(at: index, at: .bottom, animated: false)
                            print(self.messages.count)
                        }
                        
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTableView.dataSource = self
        messageTableView.delegate = self
        loadMessages()
    }
    
}

extension ChatViewController:  UITableViewDataSource, UITableViewDelegate{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ChatViewController.messeageCellId, for: indexPath) as! MessageTableViewCell
        cell.messageBody.text = messages[indexPath.row].body
        if let currentUser = Auth.auth().currentUser?.email{
            if messages[indexPath.row].sender == currentUser{
                cell.youAvatar.isHidden = true
                cell.meAvatar.isHidden = false
                cell.messageBackground.backgroundColor = UIColor(named: Constants.ChatViewController.meColor)
            }else{
                cell.meAvatar.isHidden = true
                cell.youAvatar.isHidden = false
                cell.messageBackground.backgroundColor = UIColor(named: Constants.ChatViewController.youColor)
                
            }
        }
        
        
        return cell
    }
}
