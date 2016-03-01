//
//  MainTableViewController.swift
//  GRDBUsage
//
//  Created by zx on 3/1/16.
//  Copyright © 2016 zx. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {

    var persons:[Person] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return persons.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        let person = persons[indexPath.row]
        cell.textLabel!.text = person.fullName
        return cell
    }


    @IBAction func EidtTap(sender: UIBarButtonItem) {
        
    }
}
