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
    let AUD: Details
    let BRL: Details
    let CAD: Details
    let CHF: Details
    let CLP: Details
    let CNY: Details
    let DKK: Details
    let GBP: Details
    let HKD: Details
    let INR: Details
    let ISK: Details
    let JPY: Details
    let KRW: Details
    let NZD: Details
    let PLN: Details
    let SEK: Details
    let SGD: Details
    let THB: Details
    let TRY: Details
    let TWD: Details
}

struct Details: Decodable {
    let buy: Double
    let symbol: String
}
