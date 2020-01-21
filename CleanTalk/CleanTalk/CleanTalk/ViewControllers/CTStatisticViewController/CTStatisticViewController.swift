//
//  CTStatisticViewController.swift
//  CleanTalk
//
//  Created by Oleg Sehelin on 1/31/17.
//  Copyright © 2017 Oleg Sehelin. All rights reserved.
//

import UIKit
import  SnapKit

fileprivate let kMinSitesCount = 10
fileprivate let kSearchBarHeight = 44.0
fileprivate let kStatisticCellHeight = 146.0
fileprivate let kTimerInterval = 1800
fileprivate let kSecondsInday = 86400.0
fileprivate let kMaxAllowdTag = 102

class CTStatisticViewController: UIViewController {

    override var prefersStatusBarHidden: Bool {
        return true
    }

    fileprivate var dataSource: [ServiceModel]! = []
    fileprivate var timer: Timer?
    fileprivate var isSearchMode:Bool = false
    fileprivate var pullToRefresh = UIRefreshControl()
    
    @IBOutlet fileprivate weak var searchBar: UISearchBar!
    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet fileprivate weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(true, animated:true)
        self.title = NSLocalizedString("PANEL", tableName: nil, bundle: Bundle.main, value: "", comment: "")
        self.tableView.register(UINib(nibName: "CTStatisticCell", bundle: nil), forCellReuseIdentifier: "Statistic Cell")
     
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(self.handleTap(sender:))))
        //pull to refresh
        self.pullToRefresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.pullToRefresh.addTarget(self, action: #selector(CTStatisticViewController.refreshPressed), for: .valueChanged)
        self.tableView?.addSubview(self.pullToRefresh)

        
        //hide search bar during init 
        self.refreshPressed()
        self.initTimer()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Button methods
    
    @IBAction func refreshPressed() {
        self.refreshTimer()
        let request = MainStatsRequest()
        request.sessionId = ModelsManager.shared.getSessionId()
        
        if self.pullToRefresh.isRefreshing == false {
            self.indicator.startAnimating()
        }
        
        AlamofireDispatcher.shared.run(request: request, keyPath:Constants.Service.serviceKey) { (response: Response<[ServiceModel]>) in            
            self.indicator.stopAnimating()
            self.pullToRefresh.endRefreshing()
            switch response {
            case .success(let model):
                ModelsManager.shared.statisticModelsList = model
                self.dataSource = model
                self.loadDetailStatistic()
                self.initTimer()
                
            case .error(let error):
                ModelsManager.shared.showAlertMessage(withError: error)
            }
        }
    }
    
    @IBAction fileprivate func sitePressed() {
        if let url = URL(string: Constants.URL.apiURL) {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction fileprivate func logoutPressed() {
        UserDefaults.standard.set(false, forKey: Constants.Defines.alreadyLogin)
        
        if let loginViewController = self.navigationController?.viewControllers.first as? CTLoginViewController {
            _ = self.navigationController?.popToViewController(loginViewController, animated: true)
        } else {
            let loginViewController = CTLoginViewController(nibName: "CTLoginViewController", bundle: nil)
            self.navigationController?.pushViewController(loginViewController, animated: true)
        }
    }
    
    //MARK: - Detail Statistic
    
    fileprivate func loadDetailStatistic() {
        self.updateSearchBarVisibility()
        self.tableView.reloadData()

        if let modelsList = ModelsManager.shared.statisticModelsList {
            for (index, model) in modelsList.enumerated() {
                let detailsRequest = self.initialiseDetailRequest(index: index, days: nil, serviceId: model.serviceId, time: nil, allow: true, isSpamRequest: true)
                
                AlamofireDispatcher.shared.run(request: detailsRequest, keyPath: Constants.Defines.requests) {
                    (responce: Response<[DetailStatisticModel]>) in
                    
                    switch responce {
                    case .success(let model):
                        if let serviceModel = ModelsManager.shared.statisticModelsList?     [detailsRequest.index] {
                            serviceModel.detailStats = model
                            
                            if self.isSearchMode == false {
                                let indexPath = IndexPath(item: detailsRequest.index, section: 0)
                                self.tableView.reloadRows(at: [indexPath], with: .none)
                            }
                        }
                        
                    case .error(let error):
                    ModelsManager.shared.showAlertMessage(withError: error)
                    }
                }
            }
        }
    }
    
    //MARK: - Helplers
    
    fileprivate func updateTimeValueForService(_ serviceId: String) {
        let key = Constants.Defines.timeInterval + serviceId
        UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: key)
    }
    
    fileprivate func initTimer() {
        self.timer = Timer.init(timeInterval: TimeInterval(kTimerInterval), target: self, selector: #selector(CTStatisticViewController.refreshPressed), userInfo: nil, repeats: true)
    }
    
    fileprivate func refreshTimer() {
        if self.timer?.isValid == true {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    fileprivate func filterArray(searchString: String) -> [ServiceModel] {
        var result: [ServiceModel] = []
        
        
        if let data = ModelsManager.shared.statisticModelsList {

            result = data.filter {($0.siteName?.lowercased().contains(searchString))!}
        }
        return result
    }
    
    fileprivate func initialiseDetailRequest(index: Int, days: String?, serviceId:String?, time: Double?, allow:Bool, isSpamRequest: Bool) -> DetailStatsRequest {
        let detailsRequest = DetailStatsRequest()
        detailsRequest.sessionId = ModelsManager.shared.getSessionId()
        detailsRequest.serviceId = serviceId
        detailsRequest.index = index
        detailsRequest.days = days
        detailsRequest.allow = allow
        detailsRequest.isSpamRequest = isSpamRequest
        
        if let serviceKey = serviceId, time == nil {
            let timeKey = Constants.Defines.timeInterval + serviceKey
            let timeValue = UserDefaults.standard.double(forKey: timeKey)
            detailsRequest.time = "\(timeValue)"
        } else if time != nil {
            detailsRequest.time = "\(time!)"
        }
        
        return detailsRequest
    }
    
    fileprivate func updateSearchBarVisibility() {
        self.searchBar.snp.remakeConstraints { (make) -> Void in
            if self.dataSource.count < kMinSitesCount {
                make.height.equalTo(0)
            } else {
                make.height.equalTo(kSearchBarHeight)
            }
        }
    }

    fileprivate func convertDays(tag: Int) -> Int {
        var result = 1
        
        switch (tag - 100) % 3 {
        case 2:
            result = 7
        default:
            break
        }
        
        return result
    }
    
    fileprivate func getCorrectTimeForDaysCount(days: Int) -> TimeInterval {
        var result:TimeInterval = 0.0
        
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second])
        
        var date:Date = Date()
        date = date.addingTimeInterval(-kSecondsInday * Double(days))
        
        let components = calendar.dateComponents(unitFlags, from: date)
        if let date = calendar.date(from: components) {
            result = calendar.startOfDay(for: date).timeIntervalSince1970
        }
        return result
    }
    
    @objc internal func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.searchBar.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }
}


extension CTStatisticViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            self.dataSource = ModelsManager.shared.statisticModelsList
        } else {
            self.dataSource = self.filterArray(searchString: searchText.lowercased())
        }
        
        self.tableView.reloadData()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.searchBar.setShowsCancelButton(true, animated: true)
        self.isSearchMode = true
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        self.searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = nil
        self.searchBar.resignFirstResponder()
        self.dataSource = ModelsManager.shared.statisticModelsList
        self.tableView.reloadData()
        self.isSearchMode = false
    }
}

extension CTStatisticViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Statistic Cell", for: indexPath) as! CTStatisticCell
        cell.updateDataForCell(dataModel: self.dataSource[indexPath.row])
        cell.delegate = self
        
        return cell
    }
}

extension CTStatisticViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(kStatisticCellHeight)
    }
}

extension CTStatisticViewController: CTStatisticCellDelegate {
    func pressedOnNewMessages(model: ServiceModel?) {
        if let serviceKey = model?.serviceId {
            let timeKey = Constants.Defines.timeInterval + serviceKey
            UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: timeKey)
        }
            
        let detailViewController = CTDetailsViewController(nibName:"CTDetailsViewController", bundle: nil)
        if let details = model?.detailStats {
            detailViewController.dataSource = details
        }
        
        detailViewController.authKey = model?.authKey ?? ""
        self.navigationController?.pushViewController(detailViewController, animated: true)
        model?.detailStats = []
    }
    
    func pressedOnButtonWithType(type: StatisticType, serviceId: String?, authKey: String) {
        let days = self.convertDays(tag: type.rawValue)
        let detailsRequest = self.initialiseDetailRequest(index: 0, days: "\(abs(days))", serviceId: serviceId, time: self.getCorrectTimeForDaysCount(days: days), allow: type.rawValue <= kMaxAllowdTag, isSpamRequest: type.rawValue < StatisticType.enabledFirewallToday.rawValue)
        
        self.indicator.startAnimating()
        AlamofireDispatcher.shared.run(request: detailsRequest, keyPath: Constants.Defines.requests) {
            (responce: Response<[DetailStatisticModel]>) in
            
            self.indicator.stopAnimating()
            switch responce {
            case .success(let model):
                if type.rawValue < StatisticType.enabledFirewallToday.rawValue {
                    let detailViewController = CTDetailsViewController(nibName:"CTDetailsViewController", bundle: nil)
                    detailViewController.dataSource = model
                    detailViewController.authKey = authKey
                    self.navigationController?.pushViewController(detailViewController, animated: true)
                } else {
                    let sfwViewController = CTSFWViewController(nibName:"CTSFWViewController", bundle:nil)
                    sfwViewController.dataSource = model
                    self.navigationController?.pushViewController(sfwViewController, animated: true)
                }
                
            case .error(let error):
                ModelsManager.shared.showAlertMessage(withError: error)
            }
        }
    }
}
