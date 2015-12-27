//
//  TotalViewController.swift
//  tip.ly
//
//  Created by Roger Kang Mo on 11/27/15.
//  Copyright © 2015 manservant. All rights reserved.
//

import UIKit

class TotalViewController: UIViewController {

    let userPreferences = NSUserDefaults.standardUserDefaults()

    var tipPercentages = [0.15, 0.20, 0.25]
    var defaultTipPercentage:Double!
    var billAmt:String!
    var tipVariance:Double!
    let dateFormatter = NSDateFormatter()
    let numberFormatter = NSNumberFormatter()
    let locale = NSLocale.currentLocale()
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipField: UITextField!
    @IBOutlet weak var totalField: UITextField!
    @IBOutlet weak var tipSegment: UISegmentedControl!
    @IBOutlet weak var dollarLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!

    override func viewDidLoad() {
        initFormatters()

        super.viewDidLoad()
        hideBottomFields()
        setUpTipSegments()

        self.navigationItem.setHidesBackButton(true, animated: false)

        billField.becomeFirstResponder()
        getPersistedBill()
        if(billAmt != nil) {
            billField.text = billAmt
            showBottomFields()
        }
        recalculate(billField)
    }

    @IBAction func onBillEditingChanged(sender: AnyObject) {
        showBottomFields()
        persistBill()
    }

    @IBAction func onEditingEnded(sender: AnyObject) {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBillFocus(sender: AnyObject) {
        if let label = dollarLabel {
            label.textColor = UIColor(red:0.25, green:0.27, blue:0.29, alpha:0.05)
        }
    }

    @IBAction func onEditingChanged(sender: AnyObject) {
        recalculate(sender as! UIControl)
    }

    func hideBottomFields() {
        self.tipSegment.alpha = 0
        self.tipField.alpha = 0
        self.tipLabel.alpha = 0
        self.totalField.alpha = 0
    }

    func showBottomFields() {
        UIView.animateWithDuration(0.1, animations: {
            self.tipSegment.alpha = 1
            self.tipField.alpha = 1
            self.tipLabel.alpha = 1
            self.totalField.alpha = 1
        })
    }

    func persistBill(){
        let currentTime = dateFormatter.stringFromDate(NSDate())
        let billAndTime: [String: String] = ["amount": billField.text!, "time": currentTime]
        userPreferences.setObject(billAndTime, forKey: "billField")
        userPreferences.synchronize()
    }

    func getPersistedBill(){
        let billAndTime = userPreferences.objectForKey("billField")
        let bill = billAndTime!["amount"] as! String
        let currentTime = NSDate()
        let date = dateFormatter.dateFromString(billAndTime!["time"] as! String)

        if(date != nil){
            let interval = currentTime.timeIntervalSinceDate(date!)
            if(interval < 600){ billAmt = bill } // 10 minutes
        }
    }

    func setUpTipSegments() {
        if let tipPref = userPreferences.objectForKey("defaultPercentage") {
            defaultTipPercentage = (tipPref as! NSString).doubleValue
        } else {
            defaultTipPercentage = 20
        }

        if let defaultVariance = userPreferences.objectForKey("defaultVariance") {
            tipVariance = (defaultVariance as! NSString).doubleValue
        } else {
            tipVariance = 0.05
            userPreferences.setObject("0.05", forKey: "defaultVariance")
            userPreferences.synchronize()
        }

        let percentageAsDec = defaultTipPercentage/100
        tipPercentages = [percentageAsDec - tipVariance, percentageAsDec, percentageAsDec + tipVariance]
        for (index, perc) in tipPercentages.enumerate() {
            let titlePerc = String(format: "%.0f", perc * 100)
            tipSegment.setTitle("\(titlePerc)%", forSegmentAtIndex: index)
        }
    }

    func keyboardWillShow(notification: NSNotification) {

        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y -= keyboardSize.height
        }

    }

    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y += keyboardSize.height
        }
    }

    func recalculate(origin: UIControl) {
        let billAmount = (billField.text! as NSString).doubleValue
        var tipAmt = billAmount * tipPercentages[tipSegment.selectedSegmentIndex]
        var totalAmt = (totalField.text! as NSString).doubleValue


        // Switch Statements: An Ultimate Evil
        switch origin {
            case billField:
                totalAmt = tipAmt + billAmount
                setFieldText(totalField, value: totalAmt)
                setFieldText(tipField, value: tipAmt)
            case tipField:
                tipAmt = (tipField.text! as NSString).doubleValue
                totalAmt = tipAmt + billAmount
                setFieldText(totalField, value: totalAmt)
            case tipSegment:
                setFieldText(tipField, value: tipAmt)
                totalAmt = tipAmt + billAmount
                setFieldText(totalField, value: totalAmt)
            default: // Edited totalField
                tipAmt = totalAmt - billAmount
                setFieldText(tipField, value: tipAmt)
        }
    }

    func setFieldText(dest: UITextField, value: Double){
        dest.text = numberFormatter.stringFromNumber(value)
    }

    func initFormatters(){
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeStyle = .ShortStyle
        numberFormatter.numberStyle = .DecimalStyle
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2

        if(locale.localeIdentifier == "en_US"){
            numberFormatter.groupingSeparator = ","
            numberFormatter.decimalSeparator = "."
        }else{
            numberFormatter.groupingSeparator = "."
            numberFormatter.decimalSeparator = ","
        }
    }
}
