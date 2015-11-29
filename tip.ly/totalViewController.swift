//
//  TotalViewController.swift
//  tip.ly
//
//  Created by Roger Kang Mo on 11/27/15.
//  Copyright © 2015 manservant. All rights reserved.
//

import UIKit

class TotalViewController: UIViewController {
    let tipPercentages = [0.15, 0.20, 0.25]
    var billAmt:String!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipField: UITextField!
    @IBOutlet weak var totalField: UITextField!
    @IBOutlet weak var tipSegment: UISegmentedControl!
    @IBOutlet weak var dollarLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        billField.text = billAmt
        recalculate(billField)
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
