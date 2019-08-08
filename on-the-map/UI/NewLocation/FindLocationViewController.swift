//
//  FindLocationViewController.swift
//  on-the-map
//
//  Created by Jerry Hanks on 05/08/2019.
//  Copyright © 2019 Jerry. All rights reserved.
//

import UIKit
import MapKit

class FindLocationViewController: UIViewController {
    @IBOutlet weak var mapVIew: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         self.navigationItem.title = "Add Location"
    }
    

    @IBAction func onTapFinishBtn(_ sender: Any) {
        
    }
    
    class func launch(_ caller:UIViewController){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: FindLocationViewController.self))
        vc.hidesBottomBarWhenPushed = true
        caller.navigationController?.pushViewController(vc, animated: true)
    }

}
