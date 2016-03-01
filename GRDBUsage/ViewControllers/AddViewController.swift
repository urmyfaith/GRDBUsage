//
//  AddViewController.swift
//  GRDBUsage
//
//  Created by zx on 3/1/16.
//  Copyright © 2016 zx. All rights reserved.
//

import UIKit

class AddViewController: UITableViewController {

    @IBOutlet weak var firstNameTextFiled: UITextField!
    @IBOutlet weak var lastNameTextFiled: UITextField!

    var person: Person = Person(firstName: "", lastName: "")

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    func textFieldDidEndEditing(textField: UITextField) {
        if textField == firstNameTextFiled {
            person.firstName = textField.text
        } else if textField == lastNameTextFiled {
            person.lastName = textField.text
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        person.firstName = firstNameTextFiled.text
        person.lastName = lastNameTextFiled.text
    }

}
