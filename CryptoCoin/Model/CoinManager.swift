//
//  CoinManager.swift
//  CryptoCoin
//
//  Created by Manuel Casocavallo on 27/12/2020.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(_ coinManager: CoinManager, _ results: APIModel)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    
    func getPrice(for currency: String){
        let completeURL : String = "\(baseURL)BTC/\(currency)?apikey=\(apiKey)"
        performRequest(with: completeURL)
    }
    
    
    //Performing a api request to coinapi.io
    func performRequest(with urlString: String) {
        //Create a url constant with an optional binding, by converting the urlString to the URL data-type
        if let url = URL(string: urlString) {
            //Create a URLSession
            let session = URLSession(configuration: .default)
            //Give the session a task with the url
            let task = session.dataTask(with: url) { (data, response, error) in
                //Check for errors, print them if any, then return
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                //If no error is detected, the data from the session are stored to safeData and then used to call the parseJSON method
                if let safeData = data {
                    if let results = self.parseJSON(safeData) {
                        self.delegate?.didUpdatePrice(self, results)
                    }
                }
            }
            //Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> APIModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(APIData.self, from: data)
            let lastPrice = decodedData.rate
            let results = APIModel(exchangeRate: lastPrice)
            return results
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
