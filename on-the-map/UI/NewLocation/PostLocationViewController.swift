//
//  PostLocationViewController.swift
//  on-the-map
//
//  Created by Jerry Hanks on 05/08/2019.
//  Copyright © 2019 Jerry. All rights reserved.
//

import UIKit
import MapKit

class PostLocationViewController: UIViewController {
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.hidesBottomBarWhenPushed = true
        self.navigationItem.title = "Add Location"
        
        
        self.addressTextField.delegate = self
        self.linkTextField.delegate = self
        
        self.linkTextField.keyboardType = .URL
        
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAddLocation(_:)))
        self.navigationItem.leftBarButtonItems = [cancelBtn]
    }
    
    
    @objc
    private func cancelAddLocation(_ sender:AnyObject){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onTapFindLocationBtn(_ sender: Any) {
        self.view.endEditing(true)
        
        do{
            guard  let address = addressTextField.text, !address.isEmpty else {throw ValidationError(message: "Address is required")}
            guard let link = linkTextField.text, !link.isEmpty else {throw ValidationError(message: "Link is required")}
            
            self.activityIndicator.startAnimating()
            //carry out reverse geocoding
            
            CLGeocoder().geocodeAddressString(address) { (placemarkes, error) in
                self.activityIndicator.stopAnimating()
                
                if let error = error{
                    print(error)
                    self.showError(error.localizedDescription)
                    return
                }
                
                
                if let placemark = placemarkes?[0]{
                    FindLocationViewController.launch(self, placeMark: placemark,mediaUrl: link)
                }
            }
            
            
        }catch{
            let errorMsg = (error as! ValidationError).message!
            self.showError(errorMsg)
        }
    }
    
    class func launch(_ caller:UIViewController){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: PostLocationViewController.self))
        vc.hidesBottomBarWhenPushed = true
        
        caller.present(vc, animated: true)
    }

}

extension PostLocationViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

