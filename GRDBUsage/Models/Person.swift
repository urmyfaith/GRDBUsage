//
//  Person.swift
//  GRDBUsage
//
//  Created by zx on 3/1/16.
//  Copyright © 2016 zx. All rights reserved.
//

import GRDB

class Person: Record {

    var id: Int64?
    var firstName: String?
    var lastName: String?
    var fullName: String {
        return [firstName, lastName].flatMap {$0}.filter{!$0.isEmpty}.joinWithSeparator(" ")
    }

    init(firstName: String? = nil, lastName: String? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        super.init()
    }

    // MARK: Record
    required init(_ row: Row) {
        id = row.value(named: "id")
        firstName = row.value(named: "firstName")
        lastName = row.value(named: "lastName")
        super.init(row)
    }

    override class func databaseTableName() -> String{
        return "persons"
    }

    override var persistentDictionary: [String: DatabaseValueConvertible?] {
        return [
            "id": id,
            "firstName": firstName,
            "lastName": lastName]
    }

    override func didInsertWithRowID(rowID: Int64, forColumn column: String?) {
        id = rowID
    }
}
