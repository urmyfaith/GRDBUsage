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
}
