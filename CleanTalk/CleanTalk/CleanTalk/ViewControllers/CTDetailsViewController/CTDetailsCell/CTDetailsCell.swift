//
//  CTDetailsCell.swift
//  CleanTalk
//
//  Created by Oleg Sehelin on 2/8/17.
//  Copyright © 2017 Oleg Sehelin. All rights reserved.
//

import UIKit

protocol CTDetailCellDelegate:  class {
    func updateStatusForMessage(_ messageId: String, status: Bool, cellIndex: Int)
}

class CTDetailsCell: UITableViewCell {

    @IBOutlet fileprivate weak var dateLabel: UILabel!
    @IBOutlet fileprivate weak var senderLabel: UILabel!
    @IBOutlet fileprivate weak var typeLabel: UILabel!
    @IBOutlet fileprivate weak var statusLabel: UILabel!
    @IBOutlet fileprivate weak var reportLabel: UILabel!
    @IBOutlet fileprivate weak var messageLabel: UILabel!
    @IBOutlet fileprivate weak var spamButton: UIButton!
    @IBOutlet fileprivate weak var indicator: UIActivityIndicatorView!
    
    fileprivate var model: DetailStatisticModel?
    public weak var delegate: CTDetailCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCellWithModel(model: DetailStatisticModel?) {
        self.model = model
        self.indicator.stopAnimating()
        if let dataModel = model {
            self.dateLabel.text = dataModel.date
            
            var senderString = ""
            if let name = dataModel.sender {
                senderString = name
            }
            
            if let email = dataModel.email {
                if senderString.count > 0 {
                    senderString = senderString + "(\(email))"
                } else {
                    senderString = email
                }
            }
            self.senderLabel.text = senderString
            
            self.typeLabel.text = dataModel.type
            var attributesDictionary = self.statusLabel.attributedText?.attributes(at: 0, longestEffectiveRange: nil, in: NSMakeRange(0, (self.statusLabel.attributedText?.length)!))
            
            var allowString = NSLocalizedString("ALLOW", comment: "")
            attributesDictionary?[.foregroundColor] = UIColor.black
            
            let spam = dataModel.allow != nil ? Int(dataModel.allow!) : 0
            if spam == 0 {
                allowString = NSLocalizedString("SPAM", comment: "")
                attributesDictionary?[.foregroundColor] = UIColor.red
            }
            
            self.statusLabel.attributedText = NSAttributedString(string: "\(allowString)", attributes: attributesDictionary)
            self.messageLabel.text = dataModel.message
            
            let approvedValue = Int(dataModel.approved)
            self.reportLabel.isHidden = approvedValue == 2
            if approvedValue != 2 {
                self.reportLabel.text = approvedValue == 0 ? NSLocalizedString("REPORTED_SPAM_TEXT", comment: "") : NSLocalizedString("REPORTED_ALLOW_TEXT", comment: "")
                
                self.spamButton.setTitle(approvedValue == 0 ? NSLocalizedString("ALLOW_BUTTON", comment: "") : NSLocalizedString("SPAM_BUTTON", comment: ""), for: .normal)
            } else {
                self.spamButton.setTitle(spam == 0 ? NSLocalizedString("ALLOW_BUTTON", comment: "") : NSLocalizedString("SPAM_BUTTON", comment: ""), for: .normal)
            }
        }
    }
    
    @IBAction fileprivate func spamPressed() {
        self.indicator.startAnimating()
        if let dataModel = self.model {
            let spam = Int(dataModel.allow!)! == 1 ? true : false
            let status = Int(dataModel.approved)! == 2 ? !spam : Int(dataModel.approved)! == 0
            self.delegate?.updateStatusForMessage(self.model?.requestId ?? "", status: status, cellIndex: self.tag)
        }
    }
}
