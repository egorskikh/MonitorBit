//
//  BitcoinResponse.swift
//  MonitorBit
//
//  Created by Егор Горских on 25.03.2021.
//

import Foundation

struct BitcoinResponse: Decodable {
    let USD: Details
    let EUR: Details
    let RUB: Details
}

struct Details: Decodable {
    var buy: Double
    var symbol: String
}
