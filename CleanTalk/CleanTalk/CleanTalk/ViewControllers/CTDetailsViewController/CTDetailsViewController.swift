//
//  CTDetailsViewController.swift
//  CleanTalk
//
//  Created by Oleg Sehelin on 2/8/17.
//  Copyright © 2017 Oleg Sehelin. All rights reserved.
//

import UIKit

let kDetailsCellHeight = 105.0

class CTDetailsViewController: UIViewController {
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    var dataSource: [DetailStatisticModel] = []
    var authKey: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.title = "Blacklist Review"
        // Do any additional setup after loading the view.
        
        self.tableView.register(UINib(nibName: "CTDetailsCell", bundle: nil), forCellReuseIdentifier: "Details Cell")

        self.tableView.estimatedRowHeight = CGFloat(kDetailsCellHeight)
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CTDetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Details Cell", for: indexPath) as! CTDetailsCell
        cell.delegate = self
        cell.tag = indexPath.row
        cell.updateCellWithModel(model: self.dataSource[indexPath.row])
        
        return cell
    }
}

extension CTDetailsViewController: CTDetailCellDelegate {
    func updateStatusForMessage(_ messageId: String, status: Bool, cellIndex: Int) {
        let alert = UIAlertController(title: NSLocalizedString("REPORTED_TITLE", comment: ""), message: nil, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString("REPORTED_YES", comment: ""), style: .default, handler: { result in
            let request = ChangeStatusRequest()
            request.messageId = messageId
            request.status = status
            request.authKey = self.authKey
            
            AlamofireDispatcher.shared.run(request: request, keyPath: nil) { (responce: Response<ChangeStatusModel>) in
                switch responce {
                case .success(let model):
                    if model.received?.intValue == 1 {
                        let detailsModel = self.dataSource[cellIndex]
                        detailsModel.approved = status == true ? "1" : "0"
                        let indexPath = IndexPath(item: cellIndex, section: 0)
                        self.tableView.reloadRows(at: [indexPath], with: .none)
                    }
                case .error(let error):
                    ModelsManager.shared.showAlertMessage(withError: error)
                }
            }
        })
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("REPORTED_NO", comment: ""), style: .default, handler: { result in
            alert.dismiss(animated: true, completion: nil)
            let indexPath = IndexPath(item: cellIndex, section: 0)
            self.tableView.reloadRows(at: [indexPath], with: .none)
        })
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
}
