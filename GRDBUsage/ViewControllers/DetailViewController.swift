//
//  DetailViewController.swift
//  GRDBUsage
//
//  Created by zx on 3/1/16.
//  Copyright © 2016 zx. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var personName: UILabel!

    var person: Person!{
        didSet{
            self.configView()
        }
    }

    func configView(){
        guard isViewLoaded() else {
            return
        }
        guard person != nil else {
            return
        }
        personName.text = person!.fullName
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }


    @IBAction func editTap(sender: UIButton) {
        let sb = UIStoryboard(name: "Add", bundle: NSBundle.mainBundle())
        let addViewController : AddViewController = sb.instantiateViewControllerWithIdentifier("Add") as! AddViewController
        addViewController.person = self.person
        self.navigationController?.pushViewController(addViewController, animated: true)
    }

}
