//
//  NSMutableAttributedString.swift
//  MonitorBit
//
//  Created by Egor Gorskikh on 25.05.2021.
//

import UIKit

extension NSMutableAttributedString {
    var fontSize:CGFloat { return 17 }
    var boldFont:UIFont { return UIFont(name: "AvenirNext-Bold", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize) }
    
    func bold(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
}
