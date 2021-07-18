//
//  SuccessViewController.swift
//  RealSungsu
//
//  Created by Yundong Lee on 2021/07/06.
//

import UIKit

class SuccessViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.navigationController?.popToRootViewController(animated: true)
        }
        
    }
}
