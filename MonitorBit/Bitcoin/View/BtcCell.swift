//
//  BTCCell.swift
//  MonitorBit
//
//  Created by Егор Горских on 26.03.2021.
//

import UIKit

class BtcCell: UITableViewCell {
    
    static let reuseID = "Cell"
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [updLbl,
                                                       eurLbl,
                                                       rubLbl])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 3
        stackView.contentMode = .scaleToFill
        return stackView
    }()
    
    lazy var updLbl: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var eurLbl: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var rubLbl: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var dateLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate var view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupConstraint() {
        contentView.addSubview(view)
        view.addSubview(stackView)
        view.addSubview(dateLbl)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 10),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            dateLbl.leadingAnchor.constraint(greaterThanOrEqualTo: stackView.trailingAnchor),
            dateLbl.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            dateLbl.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
    }
    
    public func configuratinCell(_ btc: BTC) {
        self.updLbl.text = btc.upd
        self.eurLbl.text = btc.eur
        self.rubLbl.text = btc.rub
        self.dateLbl.text = btc.date
    }
    
}
