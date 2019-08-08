//
//  MapViewController.swift
//  on-the-map
//
//  Created by Jerry Hanks on 03/08/2019.
//  Copyright © 2019 Jerry. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = ""
        // Do any additional setup after loading the view.
        
        
        self.mapView.delegate = self
        
        // 1
        let location = CLLocationCoordinate2D(latitude: 51.50007773,
                                              longitude: -0.1246402)
        
        // 2
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        //3
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Big Ben"
        annotation.subtitle = "London"
        mapView.addAnnotation(annotation)
        
        let logoutBtnItem = UIBarButtonItem(title: "LOGOUT", style: .done, target: self, action: #selector(logout(_:)))
        self.navigationItem.leftBarButtonItems = [logoutBtnItem]
        
        let refreshBtnItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh(_:)))
        let addBtnItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem(_:)))
        
        self.navigationItem.rightBarButtonItems  = [addBtnItem,refreshBtnItem]
        
        //load map locations here and drop pins
    }
    

    
    @IBAction
    private func logout(_ sender:AnyObject){
        print("Logout Btn clicked!")
        
    }
    
    @objc
    private func refresh(_ sender:UIBarButtonItem){
        print("Refresh Btn clicked!")
        
    }
    
    @objc
    private func addItem(_ sender:UIBarButtonItem){
        PostLocationViewController.launch(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.title = ""
    }


}

extension MapViewController : MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView{
            if let url = view.annotation?.subtitle{
                UIApplication.shared.openURL(URL(string: url!)!)
            }
            
        }
    }
}
