//
//  ViewController.swift
//  tip.ly
//
//  Created by Roger Kang Mo on 11/26/15.
//  Copyright © 2015 manservant. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var dollarLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!

    @IBAction func onFinishedEditing(sender: AnyObject) {
        view.endEditing(true)
    }

    @IBAction func onTouchEvent(sender: AnyObject) {
        if let label = dollarLabel {
            label.textColor = UIColor(red:0.25, green:0.27, blue:0.29, alpha:0.05)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        billField.becomeFirstResponder()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "TotalViewSegue" {
            let nextView = (segue.destinationViewController as! TotalViewController)
        
            nextView.billAmt = billField.text
        }
    }
}

