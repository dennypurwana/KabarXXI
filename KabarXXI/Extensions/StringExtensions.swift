//
//  StringExtensions.swift
//  LoginDemo
//
//  Created by Bayu Yasaputro on 04/04/18.
//  Copyright © 2018 DyCode. All rights reserved.
//

import Foundation

extension String {
    
    func date(with format: String) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self) ?? Date(timeIntervalSince1970: 0)
    }
}
