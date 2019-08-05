//
//  LoginViewController.swift
//  on-the-map
//
//  Created by Jerry Hanks on 03/08/2019.
//  Copyright © 2019 Jerry. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onLoginBtn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: String(describing: TabBarController.self))
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func onSignUpBtn(_ sender: Any) {
    }
}
 
