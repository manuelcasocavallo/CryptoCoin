//
//  ViewController.swift
//  CryptoCoin
//
//  Created by Manuel Casocavallo on 27/12/2020.
//


import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var appNameLabel: UILabel!

    
    var selectedCurrency : String = "Select a currency"
    let appName = "CryptoCoin💰"
    
    //Initializing the CoinManager struct
    var coinManager = CoinManager()
    
    
    
//MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appNameLabel.text = ""
        var charIndex = 0.0
        for letter in appName {
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in
                self.appNameLabel.text?.append(letter)
            }
            charIndex += 1
        }
        
        currencyLabel.text = selectedCurrency
        currencyPicker.setValue(UIColor.white, forKey: "textColor")
        
        //The coin manager sets this VC as delegate
        coinManager.delegate = self

        //Setting the VC as the currency picker data source and delegate
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }
}



//MARK: - UIPickerViewDataSource / UIPickerViewDelegate

extension ViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    //This method sets the number of components to be shown in the picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //This method sets the number of the picker rows, it correspond to the array count
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    //This method gets called by the picker view when loading and will ask the delegate for a row title for each row.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //The string is retrieved from the CoinManager array, using the row count for the array position count (row 0 = array[0], row 1 = array[1], ... )
        return coinManager.currencyArray[row]
    }
    
    //This method gets triggered everytime the user scrolls the picker and it records the row number that is selected.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCurrency = coinManager.currencyArray[row]
        //Calling the getCoinPrice with the selected currency
        coinManager.getPrice(for: selectedCurrency)
    }
    
}

//MARK: - CoinManagerDelegate

extension ViewController : CoinManagerDelegate {
    func didUpdatePrice(_ coinManager: CoinManager, _ results: APIModel) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text = results.roundedRate
            self.currencyLabel.text = self.selectedCurrency
        }
    }
    
    func didFailWithError(error: Error) {
        print(error.localizedDescription)
    }
}
 
