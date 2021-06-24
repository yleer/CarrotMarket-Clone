//
//  UploadViewController.swift
//  RealEstate
//
//  Created by Yundong Lee on 2021/06/19.
//

import UIKit
import PhotosUI
import Firebase


class UploadViewController: UIViewController, PHPickerViewControllerDelegate{
    
    
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var locationTextfield: UITextField!
    @IBOutlet weak var titleTextfield: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    
    var images : [UIImage] = []{
        didSet{
            DispatchQueue.main.async {
                self.uploadButton.setBackgroundImage(self.images[0], for: .normal)
            }
        }
    }
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    
    @IBAction func uploadData(_ sender: UIBarButtonItem) {
        if let title = titleTextfield.text, let location = locationTextfield.text, let cont = content.text{
            
            // Host url starting part.
            
            var num = 1
            let restUrl = "photos/\(title)/\(num).jpeg"
            for img in images{
                let storageRef = Storage.storage().reference(withPath: restUrl)
                num += 1
                guard let imageData = img.jpegData(compressionQuality: 0.1) else {return}
                
                let uploadMetaData = StorageMetadata.init()
                uploadMetaData.contentType = "image/jpeg"
                
                storageRef.putData(imageData, metadata: uploadMetaData) { downloadMetaData, error in
                    if let er = error{
                        print(er)
                    }else{
                        print(downloadMetaData)
                    }
                }
            }
            
            
            
            db.collection("realestate data").addDocument(data: [
                "title" : title,
                "location" : location,
                "content" : cont
            ]) { error in
                if let e = error{
                    print(e)
                }else{
                    print("succ")
                }
            }
            
           
            
            navigationController?.popViewController(animated: true)
            
            
        }
    }
    
    // MARK: image picker part.
    
    @IBAction func uploadImage(_ sender: UIButton) {
        presentPickerView()
        
    }
    
    func presentPickerView(){
        var config : PHPickerConfiguration = PHPickerConfiguration()
        config.filter = PHPickerFilter.images
        config.selectionLimit = 10
        
        let picker : PHPickerViewController = PHPickerViewController(configuration: config)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        for item in results{
            item.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                if let img = image as? UIImage{
                    self.images.append(img)
                }
            }
        }
    }
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}

    


// 이미지 파이어스토어에 저장하기.
