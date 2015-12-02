//
//  SettingsTableViewController.swift
//  tip.ly
//
//  Created by Roger Kang Mo on 11/28/15.
//  Copyright © 2015 manservant. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    let userPreferences = NSUserDefaults.standardUserDefaults()
    @IBOutlet weak var defaultTipField: UITextField!
    @IBOutlet weak var verboseRatingSwitch: UISwitch!

//    func setPreference(value: String, key: String){
//        userPreferences.setObject(value, forKey: key)
//        userPreferences.synchronize()
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        if let defaultPercentage = userPreferences.objectForKey("defaultPercentage") {
            defaultTipField.text = (defaultPercentage as! String)
        }
        let useVerboseRatings = userPreferences.boolForKey("verboseRatings")
        if userPreferences.objectForKey("verboseRatings") != nil {
            verboseRatingSwitch.setOn(useVerboseRatings, animated: true)
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
    @IBAction func onVerboseChange(sender: AnyObject){
        userPreferences.setBool(verboseRatingSwitch.on, forKey: "verboseRatings")
        userPreferences.synchronize()
    }

    @IBAction func onDefaultPercentageChange(sender: AnyObject) {
        userPreferences.setObject(defaultTipField.text!, forKey: "defaultPercentage")
        userPreferences.synchronize()
    }
}
