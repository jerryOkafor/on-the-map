//
//  TabBarController.swift
//  on-the-map
//
//  Created by Jerry Hanks on 03/08/2019.
//  Copyright © 2019 Jerry. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    private var laodLocationsTak : URLSessionDataTask? = nil
    private var deleteSessionTask : URLSessionDataTask? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.loadLocations()
        
        //add refresh notification event observer
        NotificationCenter.default.addObserver(self, selector: #selector(loadLocations), name: .refresh, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(logout), name: .logout, object: nil)
    }
    
    @objc
    private func logout(){
        
        UIApplication.shared.isNetworkActivityIndicatorVisible   = true
        
        self.deleteSessionTask = ApiClient.doRequest(request: ApiRouter.deleteSession.toUrlRequest(), responseType: Session.self) { (response, error) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            if let error = error{
                print("Error: \(error)")
                
                self.showError(error.localizedDescription)
                return
            }
            
            self.completeLogout()
        }
    }
    
    @objc
    private func loadLocations(){
        
        UIApplication.shared.isNetworkActivityIndicatorVisible  = true
        (UIApplication.shared.delegate as! AppDelegate).locations.removeAll()
        NotificationCenter.default.post(name: .networkActivityStarted, object: nil)
        
        self.laodLocationsTak =  ApiClient.doRequest(request: ApiRouter.locations.toUrlRequest(),responseType: LocationResponse.self,secureResponse: false) { (response, error) in
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            NotificationCenter.default.post(name: .networkActivityStoped, object: nil)
            
            if let error = error{
                print("Error: \(error)")
                
                self.showError(error.localizedDescription)
                return
            }
            
            if let locations = response?.results{
                
                for location in locations{
                    (UIApplication.shared.delegate as! AppDelegate).locations.append(location)
                }
                
                //notify observers
                NotificationCenter.default.post(name:.doneLoading,object: nil)
            }
            
            
        }
    }
    
    private func completeLogout(){
        //start from the beginning
        
        if let window = (UIApplication.shared.delegate as? AppDelegate)?.window{
            let rootNavControler = storyboard?.instantiateViewController(withIdentifier: String(describing: MainViewController.self))
            window.rootViewController = rootNavControler
        }
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.deleteSessionTask?.cancel()
        self.laodLocationsTak?.cancel()
    }
}
