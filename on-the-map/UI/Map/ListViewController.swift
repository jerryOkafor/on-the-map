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
    
    private var locations:[Location]{
        get{return (UIApplication.shared.delegate as! AppDelegate).locations}
    }
    
    private let links = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self

        // Do any additional setup after loading the view.
        
        let logoutBtnItem = UIBarButtonItem(title: "LOGOUT", style: .done, target: self, action: #selector(logout(_:)))
        self.navigationItem.leftBarButtonItems = [logoutBtnItem]
        
        let refreshBtnItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh(_:)))
        let addBtnItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem(_:)))
        
        self.navigationItem.rightBarButtonItems  = [addBtnItem,refreshBtnItem]
        
        
        //add observers
        NotificationCenter.default.addObserver(self, selector: #selector(doneLoadingData(_:)), name: .doneLoading, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(networkActivityStarted), name: .networkActivityStarted, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(networkActivityDone), name: .networkActivityStoped, object: nil)
    }
    
    @objc
    private func networkActivityStarted(){
        self.toggleProgress(true)
    }
    
    @objc
    private func networkActivityDone(){
        self.toggleProgress(false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //refres maps pins
        self.tableView.reloadData()
    }

    
    @objc
    private func doneLoadingData(_ notification:Notification){
        //refres maps pins
        self.tableView.reloadData()
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
        NotificationCenter.default.post(name: .logout, object: nil)
    }
    
    
    @objc
    private func refresh(_ sender:UIBarButtonItem){
       NotificationCenter.default.post(name: .refresh, object: nil)
        
    }
    
    @objc
    private func addItem(_ sender:UIBarButtonItem){
         PostLocationViewController.launch(self)
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
        cell.textLabel?.text  = "\(String(describing: item.firstName)) \(String(describing: item.lastName))"
        cell.detailTextLabel?.text = item.mediaURL
        
        return cell
    }
    
    
}

//List TableView Delegate
extension ListViewController  : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = locations[indexPath.row]
        if let url = URL(string: location.mediaURL){
            UIApplication.shared.open(url)
        }else{
            self.showError("Invalid media link")
        }
    }
}


class MapLink: UITableViewCell {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.selectionStyle = .none
        
    }
}
