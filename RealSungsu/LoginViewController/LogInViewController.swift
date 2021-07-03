//
//  LogInViewController.swift
//  RealEstate
//
//  Created by Yundong Lee on 2021/06/19.
//

import UIKit
//import NaverThirdPartyLogin
import Firebase
//import Alamofire

class LogInViewController: UIViewController{
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
//    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        loginInstance?.delegate = self
        addGesture()
    }
    
    // MARK: keyboard dismissing part.
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func addGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    
    
    // MARK: Login part.
    @IBAction func LogIn(_ sender: UIButton) {
        if let email = idTextField.text, let password = passwordTextField.text{
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let e = error{
                print(e.localizedDescription)
            }else{
                self.performSegue(withIdentifier: "show tabBar", sender: self)
            }
        }
            
//            loginInstance?.requestThirdPartyLogin()
        }
    }
    
//    func getInfo() {
//          guard let isValidAccessToken = loginInstance?.isValidAccessTokenExpireTimeNow() else { return }
//
//          if !isValidAccessToken {
//            return
//          }
//
//          guard let tokenType = loginInstance?.tokenType else { return }
//          guard let accessToken = loginInstance?.accessToken else { return }
//
//          let urlStr = "https://openapi.naver.com/v1/nid/me"
//          let url = URL(string: urlStr)!
//
//          let authorization = "\(tokenType) \(accessToken)"
//
//          let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
//
//          req.responseJSON { response in
//            guard let result = response.value as? [String: Any] else { return }
//            guard let object = result["response"] as? [String: Any] else { return }
//            guard let name = object["name"] as? String else { return }
//            guard let email = object["email"] as? String else { return }
//            guard let id = object["id"] as? String else {return}
//
//            print(email)
//
////            self.nameLabel.text = "\(name)"
////            self.emailLabel.text = "\(email)"
////            self.id.text = "\(id)"
//          }
//        }
    
    
    
    
}

//extension LogInViewController : NaverThirdPartyLoginConnectionDelegate {
//    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
//        print("Success login")
//        getInfo()
//    }
//
//    // referesh token
//    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
//        loginInstance?.accessToken
//    }
//
//    // 로그아웃
//    func oauth20ConnectionDidFinishDeleteToken() {
//        loginInstance?.requestDeleteToken()
//        print("log out")
//    }
//
//    // 모든 error
//    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
//        print("error = \(error.localizedDescription)")
//    }
//}
// https://developer-fury.tistory.com/18
