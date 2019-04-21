//
//  ViewController.swift
//  Yahoo
//
//  Created by John Ferlic on 3/22/19.
//  Copyright © 2019 John Ferlic. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    var data: [Float] = []
    var bkgrndColor: String = ""
    
    @IBAction func buttonPressed(_ sender: Any) {
        
        if let url = URL(string: "https://www.quandl.com/api/v3/datasets/WIKI/\(self.tickerTextField.text!)/data.json?api_key=1vm2-SkboCgr-7pwGCfC&limit=1") {
            URLSession.shared.dataTask(with: url) { (data, response, error) -> Void in
                guard error == nil else {
                    print("Error: \(error!)")
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    print("Bad Response")
                    return
                }
                guard response.statusCode == 200 else {
                    let alert = UIAlertController(title: "No Results", message: "The ticker you entered didn't give any results", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    print("Bad Response: \(response.statusCode)")
                    DispatchQueue.main.async {
                        self.view.backgroundColor = UIColor.white
                        self.present(alert, animated: true)
                        self.tickerLabel.text = ""
                        self.openPriceLabel.text = ""
                        self.closingPriceLabel.text = ""
                        self.tickerTextField.text = ""
                    }
                    return
                }
                guard let data = data else {
                    print("No data")
                    return
                }
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                formatter.calendar = Calendar(identifier: .iso8601)
                formatter.timeZone = TimeZone(secondsFromGMT: 0)
                formatter.locale = Locale(identifier: "en_US_POSIX")
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(formatter)
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                if let result = try? decoder.decode(TimeSeries.self, from: data) {
                    self.data = result.datasetData.data.first?.data ?? []
                    if (self.data[0] > self.data[3]) {
                        self.bkgrndColor = "red"
                    } else {
                        self.bkgrndColor = "green"
                    }
                    print(result.datasetData.data.first?.date)
                    for x in self.data {
                        print(x)
                    }
                    
                    DispatchQueue.main.async {
                        if (self.bkgrndColor == "red") {
                            self.view.backgroundColor = UIColor.red
                        } else {
                            self.view.backgroundColor = UIColor.green
                        }
                        self.tickerLabel.text = self.tickerTextField.text?.uppercased()
                        self.openPriceLabel.text = String(self.data[0])
                        self.closingPriceLabel.text = String(self.data[3])
                        self.tickerTextField.text = ""
                    }
                }
            }
            .resume()
        }
        
    }
    
    @IBOutlet weak var openPriceLabel: UILabel!
    @IBOutlet weak var closingPriceLabel: UILabel!
    @IBOutlet weak var tickerLabel: UILabel!
    @IBOutlet weak var tickerTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
}


