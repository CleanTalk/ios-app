//
//  CTStatisticCell.swift
//  CleanTalk
//
//  Created by Oleg Sehelin on 2/7/17.
//  Copyright © 2017 Oleg Sehelin. All rights reserved.
//

import UIKit
import SDWebImage

protocol CTStatisticCellDelegate : class {
    func pressedOnButtonWithType(type: StatisticType, serviceId: String?, authKey: String)
    func pressedOnNewMessages(model: ServiceModel?)
}

fileprivate let kMaxDefaultCellWidth = 113.0

class CTStatisticCell: UITableViewCell {

    @IBOutlet fileprivate weak var siteImageView: UIImageView!
    @IBOutlet fileprivate weak var siteNameLabel: UILabel!
    @IBOutlet fileprivate weak var newMessagesLabel: UILabel!
    @IBOutlet fileprivate weak var messagesIndicator: UIActivityIndicatorView!
    @IBOutlet fileprivate weak var firewallContainerView: UIView!
    @IBOutlet fileprivate weak var marginImageView: UIImageView!
    
    @IBOutlet fileprivate weak var enableSpamTodayLabel: UIButton!
    @IBOutlet fileprivate weak var enableSpamYesterdayLabel: UIButton!
    @IBOutlet fileprivate weak var enableSpamWeekLabel: UIButton!

    @IBOutlet fileprivate weak var disableSpamTodayLabel: UIButton!
    @IBOutlet fileprivate weak var disableSpamYesterdayLabel: UIButton!
    @IBOutlet fileprivate weak var disableSpamWeekLabel: UIButton!

    @IBOutlet fileprivate weak var enableFirewallTodayLabel: UIButton!
    @IBOutlet fileprivate weak var enableFirewallYesterdayLabel: UIButton!
    @IBOutlet fileprivate weak var enableFirewallWeekLabel: UIButton!
    
    weak var delegate: CTStatisticCellDelegate?
    fileprivate var serviceModel: ServiceModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    func updateDataForCell(dataModel: ServiceModel?) {
        self.serviceModel = dataModel
        if let model = dataModel {
            
            //swf view
            let isShowSFWView = model.checkIfNeedToShowSFWView()
            self.firewallContainerView.isHidden = !isShowSFWView
            self.marginImageView.isHidden = !isShowSFWView
            
            //image
            if let urlString = model.siteIcon {
                self.siteImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.siteImageView.sd_setImage(with: URL(string: urlString))
            }
            
            //new messages
            if let newMessagesArray = model.detailStats {
                self.messagesIndicator.stopAnimating()
                self.newMessagesLabel.isHidden = newMessagesArray.count == 0
                self.newMessagesLabel.text = "\(newMessagesArray.count)"
            } else {
                self.messagesIndicator.startAnimating()
            }
            
            self.siteNameLabel.text = model.siteName
            
            let enabledAtributse = self.enableSpamWeekLabel.attributedTitle(for: .normal)?.attributes(at: 0, longestEffectiveRange: nil, in: NSMakeRange(0, (self.enableSpamWeekLabel.attributedTitle(for: .normal)?.length)!))

            let disabledAtributse = self.disableSpamWeekLabel.attributedTitle(for: .normal)?.attributes(at: 0, longestEffectiveRange: nil, in: NSMakeRange(0, (self.disableSpamWeekLabel.attributedTitle(for: .normal)?.length)!))

            //spam firewall
            if isShowSFWView == true {
                let enabledTodayFireWall = model.statsToday?.sfw == nil ? 0 : model.statsToday?.sfw
                let enabledYesterdayFireWall = model.statsYesterday?.sfw == nil ? 0 : model.statsYesterday?.sfw
                let enabledWeekFireWall = model.statsWeek?.sfw == nil ? 0 : model.statsWeek?.sfw
                
                self.enableFirewallTodayLabel.setAttributedTitle(NSAttributedString(string: "\(enabledTodayFireWall!)", attributes: enabledAtributse), for: .normal)
                self.enableFirewallYesterdayLabel.setAttributedTitle(NSAttributedString(string: "\(enabledYesterdayFireWall!)", attributes: enabledAtributse), for: .normal)
                self.enableFirewallWeekLabel.setAttributedTitle(NSAttributedString(string: "\(enabledWeekFireWall!)", attributes: enabledAtributse), for: .normal)

            }

            //today spam
            if let todayModal = model.statsToday, let allowToday = todayModal.allow, let spamToday = todayModal.spam {
                self.enableSpamTodayLabel.setAttributedTitle(NSAttributedString(string: "\(allowToday)", attributes: enabledAtributse), for: .normal)
                self.disableSpamTodayLabel.setAttributedTitle(NSAttributedString(string: "\(spamToday)", attributes: disabledAtributse), for: .normal)                
            }

            //yesterday spam
            if let yestedayModal = model.statsYesterday, let allowYesterday = yestedayModal.allow, let spamYesterday = yestedayModal.spam {
                self.enableSpamYesterdayLabel.setAttributedTitle(NSAttributedString(string: "\(allowYesterday)", attributes: enabledAtributse), for: .normal)
                self.disableSpamYesterdayLabel.setAttributedTitle(NSAttributedString(string: "\(spamYesterday)", attributes: disabledAtributse), for: .normal)
            }

            //week spam
            if let weekModel = model.statsWeek, let allowWeek = weekModel.allow, let spamWeek = weekModel.spam {
                self.enableSpamWeekLabel.setAttributedTitle(NSAttributedString(string: "\(allowWeek)", attributes: enabledAtributse), for: .normal)
                self.disableSpamWeekLabel.setAttributedTitle(NSAttributedString(string: "\(spamWeek)", attributes: disabledAtributse), for: .normal)
            }
        }
    }
        
    //MARK: - Buttons
    
    @IBAction fileprivate func newMessagesPressed() {
        self.delegate?.pressedOnNewMessages(model: self.serviceModel)
    }
    
    @IBAction fileprivate func buttonPressed(sender: UIButton) {
        if let type = StatisticType(rawValue: sender.tag), sender.attributedTitle(for: .normal)?.string != "0", let serviceId = self.serviceModel?.serviceId {
            self.delegate?.pressedOnButtonWithType(type: type, serviceId: "\(serviceId)", authKey: self.serviceModel?.authKey ?? "")
        }
    }
}
