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
    
    private let links = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = "On The Map"

        // Do any additional setup after loading the view.
        
        let logoutBtnItem = UIBarButtonItem(title: "LOGOUT", style: .done, target: self, action: #selector(logout(_:)))
        self.navigationItem.leftBarButtonItems = [logoutBtnItem]
        
        let refreshBtnItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh(_:)))
        let addBtnItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem(_:)))
        
        self.navigationItem.rightBarButtonItems  = [addBtnItem,refreshBtnItem]
    }
    
    @objc
    private func logout(_ sender:UIBarButtonItem){
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
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
}

//List TableViewdatasource
extension ListViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell   = tableView.dequeueReusableCell(withIdentifier: String(describing: MapLink.self), for: indexPath) as! MapLink
        
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
