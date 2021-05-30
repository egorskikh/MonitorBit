//
//  BtcView.swift
//  MonitorBit
//
//  Created by Egor Gorskikh on 29.05.2021.
//

import UIKit

class BtcView: UIView {
    
    // MARK: - UI Elements
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ usdLbl,
                                                        eurLbl,
                                                        rubLbl] )
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 11
        return stackView
    }()
    
    lazy var usdLbl: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = ""
        label.textColor = .white
        return label
    }()
    
    lazy var eurLbl: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = ""
        label.textColor = .white
        return label
    }()
    
    lazy var rubLbl: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = ""
        label.textColor = .white
        return label
    }()
    
    lazy var dateLbl: UILabel = {
        
        let time = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YY"
        let formattedDate = formatter.string(from: time as Date)
        
        let label = UILabel()
        label.attributedText = NSMutableAttributedString().bold(formattedDate)
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(BtcTableViewCell.self, forCellReuseIdentifier: BtcTableViewCell.reuseID)
        return tableView
    }()
    
    // MARK: - Public method
    
    public func fillCellWithText(_ input: BitcoinResponse) {
        usdLbl.attributedText = NSMutableAttributedString()
            .bold(String(input.USD.buy) + " " + String(input.USD.symbol))
        eurLbl.attributedText = NSMutableAttributedString()
            .bold(String(input.EUR.buy) + " " + String(input.EUR.symbol))
        rubLbl.attributedText = NSMutableAttributedString()
            .bold(String(input.RUB.buy) + " " + String(input.RUB.symbol))
    }
    
}
