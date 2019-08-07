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
    @IBOutlet var networkIndicator: UIActivityIndicatorView!
    @IBOutlet weak var createAccountBtn: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.emailTextField.text = "jerry.okafor.171858@unn.edu.ng"
        self.passwordTextField.text = "don13@udacity"
    }

    @IBAction func onLoginBtn(_ sender: Any) {
        
        do{
            guard let email = emailTextField.text, !email.isEmpty else { throw ValidationError(message: "Email is required")}
            guard let password = passwordTextField.text, !password.isEmpty else {throw ValidationError(message: "Password id required")}
            
            let requestData = CreatSession(udacity: Credential(userName: email, password: password))
            
            self.toggleNetworkIndicator(true)
            ApiClient.request(request: ApiRouter.createSession.toUrlRequest(), requestType: CreatSession.self,responseType: CreatSessionResponse.self, body: requestData) { (response, error) in
                self.toggleNetworkIndicator(false)
                
                if let error  = error{
                    self.showError(error.localizedDescription)
                    return
                }
                
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
                    appDelegate.account = response?.account
                    appDelegate.session = response?.session
                    
                    self.completeLogin()
                    
                }
                
            }
        }catch{
            if let errorMessage = (error as! ValidationError).message{
                 self.showError(errorMessage)
            }
        }
    }
    
    private func completeLogin(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: String(describing: TabBarController.self))
        self.present(vc!, animated: true, completion: nil)

    }
    private func showError(_ message:String){
        let alert =  UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { action in
            
        }
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    private func toggleNetworkIndicator(_ show:Bool){
        if show{
            self.networkIndicator.startAnimating()
            self.emailTextField.isEnabled  = false
            self.passwordTextField.isEnabled = false
            self.loginBtn.isEnabled = false
        }else{
             self.networkIndicator.stopAnimating()
            self.emailTextField.isEnabled  = true
            self.passwordTextField.isEnabled = true
            self.loginBtn.isEnabled = true
        }
    }
    
    @IBAction func onSignUpBtn(_ sender: Any) {
        let url = URL(string: "https://www.udacity.com/")!
        UIApplication.shared.open(url)
    }
}
 
