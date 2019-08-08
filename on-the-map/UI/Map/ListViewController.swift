//
//  ListViewController.swift
//  on-the-map
//
//  Created by Jerry Hanks on 03/08/2019.
//  Copyright © 2019 Jerry. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var networkIndicator: UIActivityIndicatorView!
    
    private var locations = [Location]()
    
    private let links = [String]()
    private var networkTask:URLSessionDataTask? = nil
    private var deletSessoinTask:URLSessionDataTask? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = "On The Map"

        // Do any additional setup after loading the view.
        
        let logoutBtnItem = UIBarButtonItem(title: "LOGOUT", style: .done, target: self, action: #selector(logout(_:)))
        self.navigationItem.leftBarButtonItems = [logoutBtnItem]
        
        let refreshBtnItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh(_:)))
        let addBtnItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem(_:)))
        
        self.navigationItem.rightBarButtonItems  = [addBtnItem,refreshBtnItem]
        
        //load locations
        self.loadLocations()
    }
    
    
    private func loadLocations(){
        self.toggleProgress(true)
        self.networkTask =  ApiClient.doRequest(request: ApiRouter.locations.toUrlRequest(),responseType: LocationResponse.self,secureResponse: false) { (response, error) in
            
            self.toggleProgress(false)
            if let error = error{
                print("Error: \(error)")
                
                self.showError(error.localizedDescription)
                return
            }
            
            if let locations = response?.results{
                self.locations = locations
                
                self.tableView.reloadData()
            }
            
            
        }
    }
    
    private func toggleProgress(_ show:Bool){
        if show{
            self.networkIndicator.startAnimating()
            self.tableView.isHidden = true
        }else{
            self.networkIndicator.stopAnimating()
            self.tableView.isHidden = false
        }
    }
    
    @objc
    private func logout(_ sender:UIBarButtonItem){
        
        UIApplication.shared.isNetworkActivityIndicatorVisible   = true
        ApiClient.doRequest(request: ApiRouter.deleteSession.toUrlRequest(), responseType: Session.self) { (response, error) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            if let error = error{
                print("Error: \(error)")
                
                self.showError(error.localizedDescription)
                return
            }
            
            self.completeLogout()
        }
    }
    
    private func completeLogout(){
        //start from the beginning
        
        if let window = (UIApplication.shared.delegate as? AppDelegate)?.window{
            let rootNavControler = storyboard?.instantiateViewController(withIdentifier: String(describing: MainViewController.self))
            window.rootViewController = rootNavControler
        }
        
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
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.networkTask?.cancel()
    }
}

//List TableViewdatasource
extension ListViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell   = tableView.dequeueReusableCell(withIdentifier: String(describing: MapLink.self), for: indexPath) as! MapLink
        let item = self.locations[indexPath.row]
        cell.textLabel?.text  = item.firstName
        cell.detailTextLabel?.text = item.mediaURL
        
        return cell
    }
    
    
}

//List TableView Delegate
extension ListViewController  : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Item selected at : \(indexPath.row)")
    }
}


class MapLink: UITableViewCell {

}
