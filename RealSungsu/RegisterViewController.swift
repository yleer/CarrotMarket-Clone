//
//  ViewController.swift
//  RealEstate
//
//  Created by Yundong Lee on 2021/06/19.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGesture()
    }

    @IBAction func signIn(_ sender: UIButton) {
        if let email = idTextField.text, let password = passwordTextField.text{
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error{
                    print(e.localizedDescription)
                }else{
                    self.performSegue(withIdentifier: "show tavleView", sender: self)
                }
            }
        }
        
        // 새로운 아이디 만들면 로그인 창으로 가기.
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: keyboard part.
    private func addGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}

