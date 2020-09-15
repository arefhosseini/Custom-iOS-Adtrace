//
//  ViewController.swift
//  CustomiOSAdtrace
//
//  Created by Aref on 9/14/20.
//

import UIKit

class ViewController: UIViewController, AdtraceDelegate {

    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var appTokenTextField: UITextField!
    @IBOutlet weak var eventTokenTextField: UITextField!
    @IBOutlet weak var startSDKButton: UIButton!
    @IBOutlet weak var sendEventButton: UIButton!
    @IBOutlet weak var sessionResponse: UILabel!
    @IBOutlet weak var eventResponse: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func showAlert(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        self.present(alert, animated: true)

        // duration in seconds
        let duration: Double = 1

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            alert.dismiss(animated: true)
        }
    }
    
    func jsonToString(json: AnyObject) -> String {
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            return convertedString!

        } catch let myJSONError {
            return myJSONError.localizedDescription
        }

    }

    @IBAction func onStartSDK(_ sender: UIButton) {
        let appToken = appTokenTextField.text
        let address = addressTextField.text
        
        if (appToken!.isEmpty) {
            return showAlert("App Token is empty!")
        }
        if (address!.isEmpty) {
            return showAlert("Address is empty!")
        }
        
        let environment = ADTEnvironmentSandbox
        let adtraceConfig = ADTConfig(appToken: appToken!, environment: environment)
        let adtraceTestOptions = AdtraceTestOptions()
        adtraceTestOptions.baseUrl = address
        adtraceConfig?.logLevel = ADTLogLevelVerbose
        adtraceConfig?.delegate = self
        Adtrace.setTestOptions(adtraceTestOptions)
        Adtrace.appDidLaunch(adtraceConfig!)
        
        startSDKButton.isEnabled = false
        startSDKButton.backgroundColor = UIColor.green
        startSDKButton.setTitle("Started", for: .normal)
        enableEvent()

    }
    
    @IBAction func onSendEvent(_ sender: UIButton) {
        let eventToken = eventTokenTextField.text
        
        if (eventToken!.isEmpty) {
            return showAlert("Event Token is empty!")
        }
        
        let adtraceEvent = ADTEvent(eventToken: eventToken!)
        Adtrace.trackEvent(adtraceEvent)
    }
    
    func enableEvent() {
        eventTokenTextField.isEnabled = true
        sendEventButton.isEnabled = true
        sendEventButton.backgroundColor = UIColor.blue
    }
    
    func adtraceEventTrackingSucceeded(_ eventSuccessResponseData: ADTEventSuccess?) {
        eventResponse.text = eventSuccessResponseData?.jsonResponse?.description
        eventResponse.textColor = UIColor.green
        
    }

    func adtraceEventTrackingFailed(_ eventFailureResponseData: ADTEventFailure?) {
        eventResponse.text = eventFailureResponseData?.jsonResponse?.description
        eventResponse.textColor = UIColor.red
    }

    func adtraceSessionTrackingSucceeded(_ sessionSuccessResponseData: ADTSessionSuccess?) {
        sessionResponse.text = sessionSuccessResponseData?.jsonResponse?.description
        sessionResponse.textColor = UIColor.green
    }

    func adtraceSessionTrackingFailed(_ sessionFailureResponseData: ADTSessionFailure?) {
        sessionResponse.text = sessionFailureResponseData?.jsonResponse?.description
        sessionResponse.textColor = UIColor.red
    }
}

