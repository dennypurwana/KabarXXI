//
//  DateExtensions.swift
//  LoginDemo
//
//  Created by Bayu Yasaputro on 04/04/18.
//  Copyright © 2018 DyCode. All rights reserved.
//

import Foundation

extension Date {
    
    static func getFormattedDate(dateStringParam: String) -> String{
       
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let dateFromInputString = dateFormatter.date(from: dateStringParam)
        dateFormatter.locale = Locale(identifier: "id")
        dateFormatter.dateFormat = "EEEE dd-MMM-yyyy HH:mm:dd";
        
        if(dateFromInputString != nil){
            return dateFormatter.string(from: dateFromInputString!)
        }
        else{
            debugPrint("could not convert date")
            return "N/A"
        }
       
    }
      
}
