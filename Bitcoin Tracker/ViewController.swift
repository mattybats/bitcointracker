//
//  ViewController.swift
//  Bitcoin Tracker
//
//  Created by Matthew Batsinelas on 11/28/17.
//  Copyright © 2017 Matthew Batsinelas. All rights reserved.
//

import UIKit
import Alamofire
import UserNotifications


struct base: Decodable {
    
    let disclaimer: String
    let bpi: Bpi
}

struct Bpi: Decodable {
    let USD: USD
    let GBP: GBP
    let EUR: EUR
}

struct USD: Decodable {
    let rate_float: Float
    let description: String
    let symbol: String
    let code: String
}

struct GBP: Decodable {
    let rate_float: Float
    let description: String
    let symbol: String
    let code: String
}

struct EUR: Decodable {
    let rate_float: Float
    let description: String
    let symbol: String
    let code: String
}

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
   
    var containerView = UIView()
    var progressView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var btnExecute: UIButton!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var pickerData: [String] = [String]()
    var pickerTitle: [String] = [String]()
    
    var currentCurrency : String = ""
    var currentAmount : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self
        loadPrice()
    }

    // Picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerTitle.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerTitle[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        self.lblTitle.text = self.pickerData[row]
        currentAmount = self.pickerData[row]
        currentCurrency = self.pickerTitle[row]
    }
    
    // Loading data from the API

    func loadPrice(){
        let jsonURLString = "https://api.coindesk.com/v1/bpi/currentprice.json"
        
        guard let url = URL(string: jsonURLString) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else {return}
            
            do {
                
                let bitcoinData = try JSONDecoder().decode(base.self, from: data)
                
                self.pickerTitle = ["\(bitcoinData.bpi.USD.code)", "\(bitcoinData.bpi.GBP.code)","\(bitcoinData.bpi.EUR.code)"]
                
                self.pickerData = ["\(bitcoinData.bpi.USD.rate_float)","\(bitcoinData.bpi.GBP.rate_float)","\(bitcoinData.bpi.EUR.rate_float)"]
                
                DispatchQueue.main.async {
                    self.pickerView.reloadAllComponents()
                    let row = self.pickerView.selectedRow(inComponent: 0);
                    self.pickerView(self.pickerView, didSelectRow: row, inComponent:0)
                }

            } catch {
                print("error")
            }
            
            } .resume()
    }
    
    // @IBActions

    @IBAction func btnExecuteClicked(_ sender: Any) {
        
        let string = (self.segment.selectedSegmentIndex == 1) ? "Congrats on selling 1 Bitcoin, which is \(currentAmount) \(currentCurrency)!" : "Congrats on buying 1 Bitcoin, which is \(currentAmount) \(currentCurrency)!"
        
        if #available(iOS 10.0, *) {
            
            let content = UNMutableNotificationContent()
            content.categoryIdentifier = "transactionNotification"
            content.title = "Bitcoin Tracker"
            content.body = NSString.localizedUserNotificationString(forKey: string, arguments: nil)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: "FiveSecond", content: content, trigger: trigger)
            let center = UNUserNotificationCenter.current()
            
            center.add(request) { (error) in
                
                debugPrint("Error: \(String(describing: error))")

            }
        }
        else
        {
            let notification = UILocalNotification()
            notification.alertBody = "Notification"
            notification.fireDate = NSDate(timeIntervalSinceNow:60) as Date
            notification.repeatInterval = NSCalendar.Unit.minute
            UIApplication.shared.cancelAllLocalNotifications()
            UIApplication.shared.scheduledLocalNotifications = [notification]
        }
    }
}
extension ViewController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "action1":
            print("First Action")
        case "action2":
            print("Second Action")
        default:
            print("error")
        }
        completionHandler()
    }
}

