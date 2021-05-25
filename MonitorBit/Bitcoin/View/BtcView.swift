//
//  BtcView.swift
//  MonitorBit
//
//  Created by Egor Gorskikh on 24.05.2021.
//

import UIKit

class BtcView: UIView {
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ updLbl,
                                                        eurLbl,
                                                        rubLbl] )
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 11
        return stackView
    }()
    
    lazy var updLbl: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = ""
        return label
    }()
    
    lazy var eurLbl: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = ""
        return label
    }()
    
    lazy var rubLbl: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = ""
        return label
    }()
    
    lazy var dateLbl: UILabel = {
        
        let time = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YY"
        let formattedDate = formatter.string(from: time as Date)
        
        let label = UILabel()
        label.text = formattedDate
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(BtcCell.self, forCellReuseIdentifier: BtcCell.reuseID)
        return tableView
    }()
}
