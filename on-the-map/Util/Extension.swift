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


extension Notification.Name{
    static let doneLoading = Notification.Name("doneLoading")
    static let refresh = Notification.Name("refrsh_data")
    static let logout = Notification.Name("logout")
    
    //network activity
    static let networkActivityStarted = Notification.Name("network_activity_staretd")
    static let networkActivityStoped = Notification.Name("network_activity_stoped")
}
