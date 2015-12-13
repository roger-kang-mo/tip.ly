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
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipField: UITextField!
    @IBOutlet weak var totalField: UITextField!
    @IBOutlet weak var tipSegment: UISegmentedControl!
    @IBOutlet weak var dollarLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        hideBottomFields()
        setUpTipSegments()

        self.navigationItem.setHidesBackButton(true, animated: false)

        billField.becomeFirstResponder()
        billField.text = billAmt
        recalculate(billField)
    }

    @IBAction func onBillEditingChanged(sender: AnyObject) {
        showBottomFields()
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

    func setUpTipSegments() {
        if let tipPref = NSUserDefaults.standardUserDefaults().objectForKey("defaultPercentage") {
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
        
        switch origin {
            case billField:
                totalAmt = tipAmt + billAmount
                totalField.text = String(format: "%.2f", totalAmt)
                tipField.text = String(format: "%.2f", tipAmt)
            case tipField:
                tipAmt = (tipField.text! as NSString).doubleValue
                totalAmt = tipAmt + billAmount
                totalField.text = String(format: "%.2f", totalAmt)
            case tipSegment:
                tipField.text = String(format: "%.2f", tipAmt)
                totalAmt = tipAmt + billAmount
                totalField.text = String(format: "%.2f", totalAmt)
            default: // Edited totalField
                tipAmt = totalAmt - billAmount
                tipField.text = String(format: "%.2f", tipAmt)
        }
    }
}
