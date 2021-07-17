//
//  ViewController.swift
//  RealEstate
//
//  Created by Yundong Lee on 2021/06/19.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet var idHelpLabel: UILabel!
    @IBOutlet var idBorderLine: UIView!
    @IBOutlet weak var idTextField: UITextField!
    
    @IBOutlet var passwordHelpLabel: UILabel!
    @IBOutlet var passwordBorderLine: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet var passwordDoubleHelpLabel: UILabel!
    @IBOutlet var passwordDoubleBorderCheck: UIView!
    @IBOutlet var psaswordDoubleCheckTextField: UITextField!
    
    @IBOutlet var doubleCheckLabel: UILabel!
    
    private func configTextField(){
        idTextField.delegate = self
        passwordTextField.delegate = self
        psaswordDoubleCheckTextField.delegate = self
        idTextField.tag = 1
        passwordTextField.tag = 2
        psaswordDoubleCheckTextField.tag = 3
        
        idHelpLabel.isHidden = true
        passwordHelpLabel.isHidden = true
        passwordDoubleHelpLabel.isHidden = true
        doubleCheckLabel.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTextField()
    }

    @IBAction func signIn(_ sender: UIButton) {
        if let email = idTextField.text, let password = passwordTextField.text{
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error{
                    print(e.localizedDescription)
                }else{
                    print("succesfully made an account.")
                }
            }
        }
        // 새로운 아이디 만들면 로그인 창으로 가기.
        navigationController?.popViewController(animated: true)
    }
}

// MARK: TextFieldDelegate part.
extension RegisterViewController : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.placeholder = ""
        if textField.tag == 1{
            idHelpLabel.isHidden = false
        }else if textField.tag == 2{
            passwordHelpLabel.isHidden = false
        }else{
            passwordDoubleHelpLabel.isHidden = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1{
            if textField.text == ""{
                idHelpLabel.isHidden = true
                textField.placeholder = "이메일"
            }
        }else if textField.tag == 2{
            if textField.text == ""{
                passwordHelpLabel.isHidden = true
                textField.placeholder = "비밀번호"
            }
        }else{
            if passwordTextField.text == psaswordDoubleCheckTextField.text{
                doubleCheckLabel.text = "비밀 번호가 같습니다"
                doubleCheckLabel.textColor = .green
            }
            
            if textField.text == ""{
                doubleCheckLabel.isHidden = true
                textField.placeholder = "비밀번호 확인"
            }
        }
    }
}
