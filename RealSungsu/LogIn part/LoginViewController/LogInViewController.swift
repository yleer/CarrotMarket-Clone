//
//  LogInViewController.swift
//  RealEstate
//
//  Created by Yundong Lee on 2021/06/19.
//

import UIKit
import Firebase
//import Alamofire
//import NaverThirdPartyLogin

class LogInViewController: UIViewController{
    
    @IBOutlet var idHelpLabel: UILabel!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet var idBorderLine: UIView!
    
    @IBOutlet var passwordHelpLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet var passwordBorderLine: UIView!
    
    
    @IBOutlet var errorLabel: UILabel!
    
    
    private func configTextField(){
        idTextField.delegate = self
        idTextField.tag = 1
        idHelpLabel.isHidden = true
        passwordTextField.delegate = self
        passwordTextField.tag = 2
        passwordHelpLabel.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTextField()
    }
    
    // MARK: Login part.
    @IBAction func LogIn(_ sender: UIButton) {
        if let email = idTextField.text, let password = passwordTextField.text{
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error{
                    self.errorLabel.text = e.localizedDescription
                }else{
                    self.performSegue(withIdentifier: "show tabBar", sender: self)
                }
            }
        }
    }
}


// MARK: TextFieldDelegate
extension LogInViewController : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1{
            idHelpLabel.isHidden = false
            if textField.text == ""{
                textField.placeholder = ""
            }
        }else{
            passwordHelpLabel.isHidden = false
            if textField.text == ""{
                textField.placeholder = ""
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1{
            if textField.text == ""{
                idHelpLabel.isHidden = true
            }
            
        }else{
            if textField.text == ""{
                passwordHelpLabel.isHidden = true
            }
        }
    }
}
