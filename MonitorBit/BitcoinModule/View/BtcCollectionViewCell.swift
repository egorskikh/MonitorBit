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
        view.backgroundColor = .lightGray
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            symbol,
            buy
        ])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 0
        return stackView
    }()
    
    lazy var buy: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    lazy var symbol: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewConstraint()
        setupUIConstraint()
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
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    public func fillCell(_ bitcoinResponse: Details ) {
        symbol.attributedText = NSMutableAttributedString()
            .bold(bitcoinResponse.symbol)
        buy.attributedText = NSMutableAttributedString()
            .bold(bitcoinResponse.buy.description)
    }
    
}
