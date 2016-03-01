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
    var addViewController: AddViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        reloadPersons()
        tableView.reloadData()
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

    @IBAction func addBack(segue: UIStoryboardSegue) {
        let addViewController = segue.sourceViewController as! AddViewController
        let person = addViewController.person

        guard (person.firstName ?? "").characters.count > 0 || (person.lastName ?? "").characters.count > 0 else {
            return
        }

        try! dbQueue.inDatabase({ db in
            try person.save(db)
        })

        reloadPersons()

        let index = persons.indexOf{$0.id == person.id}!

        tableView.beginUpdates()
        tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .Automatic)
        tableView.endUpdates()

    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier ==  "Detail"{
            let detailViewController = segue.destinationViewController  as! DetailViewController
            detailViewController.person = persons[self.tableView.indexPathForSelectedRow!.row]
        }
    }

    func reloadPersons() {
        persons = dbQueue.inDatabase { db in
            Person.order(Col.firstName, Col.lastName).fetchAll(db)
        }
    }
}
