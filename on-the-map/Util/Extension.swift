//
//  Extension.swift
//  on-the-map
//
//  Created by Jerry Hanks on 08/08/2019.
//  Copyright © 2019 Jerry. All rights reserved.
//

import UIKit

extension UIViewController {
    func showError(_ message:String){
        let alert =  UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { action in
            
        }
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}
