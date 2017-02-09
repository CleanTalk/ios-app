//
//  CTSFWViewController.swift
//  CleanTalk
//
//  Created by Oleg Sehelin on 2/9/17.
//  Copyright © 2017 Oleg Sehelin. All rights reserved.
//

import UIKit

fileprivate let kSFWCellHeight = 80.0
class CTSFWViewController: UIViewController {
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    var dataSource: [DetailStatisticModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.title = "Spam FireWall Review"
        // Do any additional setup after loading the view.
        
        self.tableView.register(UINib(nibName: "CTSFWCell", bundle: nil), forCellReuseIdentifier: "SFW Cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CTSFWViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SFW Cell", for: indexPath) as! CTSFWCell
        cell.tag = indexPath.row
        cell.updateCellWithModel(dataModel: self.dataSource[indexPath.row])
        
        return cell
    }
}

extension CTSFWViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(kSFWCellHeight)
    }
}
