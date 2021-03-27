//
//  BTCCell.swift
//  MonitorBit
//
//  Created by Егор Горских on 26.03.2021.
//

import UIKit

class BTCCell: UITableViewCell {
    
    static let reuseID = "BTCCell"
    
    @IBOutlet weak var updLabel: UILabel!
    @IBOutlet weak var eurLabel: UILabel!
    @IBOutlet weak var rubLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    // MARK: - View Life Cycle
    override func prepareForReuse() {
      super.prepareForReuse()

    }
    
}
