//
//  PostLocationViewController.swift
//  on-the-map
//
//  Created by Jerry Hanks on 05/08/2019.
//  Copyright © 2019 Jerry. All rights reserved.
//

import UIKit

class PostLocationViewController: UIViewController {
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.hidesBottomBarWhenPushed = true
        self.navigationItem.title = "Add Location"
    }
    
    @IBAction func onTapFindLocationBtn(_ sender: Any) {
        FindLocationViewController.launch(self)
    }
    
    class func launch(_ caller:UIViewController){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: PostLocationViewController.self))
        vc.hidesBottomBarWhenPushed = true
        
        caller.navigationController?.pushViewController(vc, animated: true)
    }

}
