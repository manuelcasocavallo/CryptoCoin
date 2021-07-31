//
//  APIModel.swift
//  CryptoCoin
//
//  Created by Manuel Casocavallo on 27/12/2020.
//

import Foundation

struct APIModel {
    //The rate received from the API
    let exchangeRate : Double
    
    //Rounding the rate to 2 decimal places
    var roundedRate : String {
        String(format: "%.2f", exchangeRate)
    }
    
}
