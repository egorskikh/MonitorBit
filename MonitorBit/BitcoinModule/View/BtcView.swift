//
//  BtcView.swift
//  MonitorBit
//
//  Created by Egor Gorskikh on 29.05.2021.
//

import UIKit

class BtcView: UIView {
    
    // MARK: - UI Elements
    
    // --- del later
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
    // --- del later
    
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
        
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(BtcTableViewCell.self,
                           forCellReuseIdentifier: BtcTableViewCell.reuseID)
        return tableView
    }()
    
    lazy var collectionView: UICollectionView = {
        
        let layot = UICollectionViewFlowLayout()
        layot.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layot)
        collectionView.register(BtcCollectionViewCell.self,
                                forCellWithReuseIdentifier: BtcCollectionViewCell.reuseID)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
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
