//
//  LogInViewController.swift
//  RealEstate
//
//  Created by Yundong Lee on 2021/06/19.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGesture()
    }
    
    
    @IBAction func LogIn(_ sender: UIButton) {
        if let email = idTextField.text, let password = passwordTextField.text{
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error{
                    print(e.localizedDescription)
                }else{
                    self.performSegue(withIdentifier: "show table view", sender: self)
                }
            }
        }
    }
    
    
    // MARK: keyboard part.
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func addGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
}
