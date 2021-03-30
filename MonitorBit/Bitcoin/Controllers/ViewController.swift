//
//  ViewController.swift
//  MonitorBit
//
//  Created by Егор Горских on 25.03.2021.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Property
    
    let networkDataFetcher = NetworkDataFetcher()
    let btcCell = BTCCell()
    
    var resultsUPD = [String]()
    var resultsEUR = [String]()
    var resultsRUB = [String]()
    var dateResults = [String]()
    
    lazy var formatteddate: String = {
        let time = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM"
        let formatteddate = formatter.string(from: time as Date)
        return formatteddate
    }()
    
    @IBOutlet weak var updLabel: UILabel!
    @IBOutlet weak var eurLabel: UILabel!
    @IBOutlet weak var rubLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btcEqual: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - View Life Cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchDataBTC()
        setupTableView()
    }
    
    // MARK: - Action
    
    @IBAction func add(_ sender: UIBarButtonItem) {
        
        guard
            let saveUpdLabetl = updLabel.text,
            let saveEurLabetl = eurLabel.text,
            let saveRubLabetl = rubLabel.text,
            let dateLabel = dateLabel.text
        else {
            return
        }
        
        self.resultsUPD.append(saveUpdLabetl)
        self.resultsEUR.append(saveEurLabetl)
        self.resultsRUB.append(saveRubLabetl)
        self.dateResults.append(dateLabel)
        
        tableView.reloadData()
    }
    
    
    
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "price history"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        resultsUPD.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BTCCell.reuseID, for: indexPath) as! BTCCell
        cell.updLabel.text = resultsUPD[indexPath.row]
        cell.eurLabel.text = resultsEUR[indexPath.row]
        cell.rubLabel.text = resultsRUB[indexPath.row]
        cell.dateLabel.text = dateResults[indexPath.row]
        return cell
    }
    
}

// MARK: - Setup Method

extension ViewController {
    
    private func setupTableView() {
        tableView.rowHeight = 91
        title = "1 BTC"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func fetchDataBTC() {
        
        networkDataFetcher.fetchСourse { (fetchСourse) in
            guard let course = fetchСourse else { return }
            self.eurLabel.text = String(course.EUR.buy) + " " + String(course.EUR.symbol)
            self.updLabel.text = String(course.USD.buy) + " " + String(course.USD.symbol)
            self.rubLabel.text = String(course.RUB.buy) + " " + String(course.RUB.symbol)
            self.btcEqual.text = "1 BTC ="
            self.dateLabel.text = self.formatteddate
        }
        
    }
    
}
