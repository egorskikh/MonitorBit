//
//  BTCCell.swift
//  MonitorBit
//
//  Created by Егор Горских on 26.03.2021.
//

import UIKit

class BtcCell: UITableViewCell {
    
    static let reuseID = "BTCCell"
    
    @IBOutlet weak var updLabel: UILabel!
    @IBOutlet weak var eurLabel: UILabel!
    @IBOutlet weak var rubLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func configuratinCell(_ btc: BTC) {
        self.updLabel.text = btc.upd
        self.eurLabel.text = btc.eur
        self.rubLabel.text = btc.rub
        self.dateLabel.text = btc.date
    }
    
}
