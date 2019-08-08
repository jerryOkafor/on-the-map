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
    @IBOutlet weak var mapView: MKMapView!
    var placeMark:CLPlacemark!
    var mediaUrl:String!
    
    private var addLocationTask:URLSessionDataTask? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         self.navigationItem.title = "Add Location"
        
        self.mapView.delegate = self
        
        //add location to the map view
        if let prevAnnotation = self.mapView?.annotations{
            self.mapView.removeAnnotations(prevAnnotation)
        }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = placeMark.location!.coordinate
        annotation.title  = placeMark.name
        
        self.mapView.addAnnotations([annotation])
        
        //set the map region
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placeMark.location!.coordinate, span: span)
        self.mapView.setRegion(region, animated: true)
        
    }
    

    @IBAction func onTapFinishBtn(_ sender: Any) {
        let body  = CreateLocationRequest(firstName: "John", lastName: "Doe", longitude: placeMark.location!.coordinate.longitude, latitude: placeMark.location!.coordinate.latitude, mapString: placeMark.name, mediaURL: mediaUrl, uniqueKey: UUID().uuidString)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.addLocationTask = ApiClient.doRequestWithData(request: ApiRouter.createLocation.toUrlRequest(), requestType: CreateLocationRequest.self, responseType: CreateLocationResponse.self, body: body,secureResponse: false) { (response, error) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            if let error  = error{
                self.showError(error.localizedDescription)
                return
            }
            
            if let response = response{
                let location = Location(firstName: body.firstName, lastName: body.lastName, longitude: body.latitude, latitude: body.longitude, mapString: body.mapString, mediaURL: body.mediaURL, uniqueKey: body.uniqueKey, objectId: response.objectId, createdAt: response.createdAt, updatedAt: response.createdAt)
                
                (UIApplication.shared.delegate as? AppDelegate)?.locations.append(location)
                
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
            
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
         self.addLocationTask?.cancel()
    }
    
    class func launch(_ caller:UIViewController,placeMark:CLPlacemark){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: FindLocationViewController.self)) as! FindLocationViewController
        vc.placeMark = placeMark
        
        vc.hidesBottomBarWhenPushed = true
        caller.navigationController?.pushViewController(vc, animated: true)
    }

}


extension FindLocationViewController: MKMapViewDelegate{
    
    // Get view for map pins
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pin = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pin == nil {
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pin!.canShowCallout = true
            pin!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pin!.annotation = annotation
        }
        
        return pin
    }

}
