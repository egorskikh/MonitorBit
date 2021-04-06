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
    
    
    func configuratinCell(upd: String, eur: String, rub: String, date: String) {
        self.updLabel.text = upd
        self.eurLabel.text = eur
        self.rubLabel.text = rub
        self.dateLabel.text = date
    }
    
}
