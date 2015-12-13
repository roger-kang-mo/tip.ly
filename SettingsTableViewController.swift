//
//  SettingsTableViewController.swift
//  tip.ly
//
//  Created by Roger Kang Mo on 11/28/15.
//  Copyright © 2015 manservant. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    let defaultTipVariances = [0.03, 0.05, 0.08]
    let userPreferences = NSUserDefaults.standardUserDefaults()
    @IBOutlet weak var defaultTipField: UITextField!
    @IBOutlet weak var tipVarianceSegment: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()


        if let defaultPercentage = userPreferences.objectForKey("defaultPercentage") {
            defaultTipField.text = (defaultPercentage as! String)
        } else {
            userPreferences.setObject("20", forKey: "defaultPercentage")
            userPreferences.synchronize()
        }

        if let defaultVariance = userPreferences.objectForKey("defaultVariance") {
            let varianceAsDouble = (defaultVariance as! NSString).doubleValue
            tipVarianceSegment.selectedSegmentIndex = defaultTipVariances.indexOf(varianceAsDouble)!
        } else {
            tipVarianceSegment.selectedSegmentIndex = 1
            userPreferences.setObject("0.05", forKey: "defaultVariance")
            userPreferences.synchronize()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    @IBAction func onVarianceChange(sender: AnyObject) {
        let selectedVariance = defaultTipVariances[tipVarianceSegment.selectedSegmentIndex]
        userPreferences.setObject(String(format:"%f", selectedVariance), forKey: "defaultVariance")
        userPreferences.synchronize()
    }
    @IBAction func onDefaultPercentageChange(sender: AnyObject) {
        let percentage = (defaultTipField.text! as NSString).doubleValue

        if !percentage.isNaN && percentage >= 0 {
            userPreferences.setObject(String(format:"%.0f", percentage), forKey: "defaultPercentage")
            userPreferences.synchronize()
        }

    }
}
