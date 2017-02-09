//
//  CTSFWCell.swift
//  CleanTalk
//
//  Created by Oleg Sehelin on 2/9/17.
//  Copyright © 2017 Oleg Sehelin. All rights reserved.
//

import UIKit

class CTSFWCell: UITableViewCell {

    @IBOutlet fileprivate weak var flagLabel: UILabel!
    @IBOutlet fileprivate weak var dateLabel: UILabel!
    @IBOutlet fileprivate weak var countryLabel: UILabel!
    @IBOutlet fileprivate weak var ipLabel: UILabel!
    @IBOutlet fileprivate weak var totalLabel: UILabel!
    @IBOutlet fileprivate weak var passedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCellWithModel(dataModel: DetailStatisticModel?) {
        if let model = dataModel, let code = model.sfwCountry  {
            self.flagLabel.text = self.flag(countryCode: code)
            self.countryLabel.text = self.countryName(from: code)
            self.dateLabel.text = model.date
            self.ipLabel.text = model.sfwIp
            self.totalLabel.text = model.sfwTotal
            self.passedLabel.text = model.sfwPassed
        }
    }
    
    //MARK: - Helpers
    fileprivate func flag(countryCode: String) -> String {
        let base = UnicodeScalar("🇦").value - UnicodeScalar("A").value
        
        var string = ""
        countryCode.uppercased().unicodeScalars.forEach {
            if let scala = UnicodeScalar(base + $0.value) {
                string.append(String(describing: scala))
            }
        }
        
        return string
    }
    
    fileprivate func countryName(from countryCode: String) -> String {
        if let name = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: countryCode) {
            return name
        } else {
            return countryCode
        }
    }
}
