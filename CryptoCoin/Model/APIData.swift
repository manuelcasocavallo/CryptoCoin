//
//  APIData.swift
//  CryptoCoin
//
//  Created by Manuel Casocavallo on 27/12/2020.
//

import Foundation

struct APIData : Decodable {
    let asset_id_base : String
    let asset_id_quote : String
    let rate : Double
}
