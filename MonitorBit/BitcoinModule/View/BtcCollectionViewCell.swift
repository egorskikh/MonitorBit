//
//  BtcCollectionViewCell.swift
//  MonitorBit
//
//  Created by Egor Gorskikh on 30.05.2021.
//

import UIKit

class BtcCollectionViewCell: UICollectionViewCell {
    
    static let reuseID = "CollectionViewCell"
    
    lazy var view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var buy: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var symbol: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViewConstraint() {
        contentView.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setupUIConstraint() {
        view.addSubview(symbol)
        NSLayoutConstraint.activate([
            symbol.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            symbol.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    
}
