//
//  ChatViewController.swift
//  RealSungsu
//
//  Created by Yundong Lee on 2021/07/08.
//

import UIKit
import Firebase

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var messages : [MessageModel] = []
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "message cell", for: indexPath) as! MessageTableViewCell
        cell.messageBody.text = messages[indexPath.row].body
        //        cell.messageSender.t            보낸 사람 이름 처리 하기.
        
        return cell
    }
    
    let db = Firestore.firestore()
    var postOwner : String?
    var postTitle : String?
    
    
    var documentName : String?
    
    
    func getCollectionName(){
        if let messageBody = messageTextField.text, let currentUser = Auth.auth().currentUser?.email, let postUser = postOwner, let title = postTitle {
            
            if currentUser > postUser{
                documentName = currentUser + "&" + postUser + "&" + title
            }else{
                documentName = postUser + "&" + currentUser + "&" + title
            }
        }
    }
    
    @IBAction func sendButton(_ sender: UIButton) {
        if let title = postTitle, let currentUser = Auth.auth().currentUser?.email, let postUser = postOwner, let messageBody = messageTextField.text, let docName = documentName{
            db.collection("rooms").document(docName).setData(
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
            
            db.collection("rooms").document(docName).collection("messages").addDocument(
                data: [
                    "sender" : currentUser,
                    "body" : messageBody
                ]
            ) { error in
                if let e = error{
                    print(e)
                }else{
                    print("good")
                }
            }
        }
    }
    
    @IBOutlet var messageTableView: UITableView!
    @IBOutlet var messageTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTableView.dataSource = self
        messageTableView.delegate = self
        
        getCollectionName()
        loadMessages()
    }
    
    private func loadMessages(){
        db.collection("rooms").document(documentName!).collection("messages").getDocuments { querySnapshot, error in
            if let e = error{
                print(e)
            }else{
                if let snapShot = querySnapshot?.documents{
                    for doc in snapShot{
                        if let messageSender = doc["sender"] as? String, let body = doc["body"] as? String{
                            let newMessage = MessageModel(sender: messageSender, body: body)
                            self.messages.append(newMessage)
                        }
                        
                        DispatchQueue.main.async {
                            self.messageTableView.reloadData()
                        }
                        
                    }
                }
            }
        }
    }
}
