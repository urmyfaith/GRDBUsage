//
//  Person.swift
//  GRDBUsage
//
//  Created by zx on 3/1/16.
//  Copyright © 2016 zx. All rights reserved.
//

import GRDB
import CoreLocation

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


class PointOfInterest : Record {
    var id: Int64?
    var title: String?
    var coordinate: CLLocationCoordinate2D

    init(title: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        super.init()
    }

    /// The table name
    override class func databaseTableName() -> String {
        return "pointOfInterests"
    }

    /// Initialize from a database row
    required init(_ row: Row) {
        id = row.value(named: "id")
        title = row.value(named: "title")
        coordinate = CLLocationCoordinate2DMake(
            row.value(named: "latitude"),
            row.value(named: "longitude"))
        super.init(row)
    }

    /// The values persisted in the database
    override var persistentDictionary: [String: DatabaseValueConvertible?] {
        return [
            "id": id,
            "title": title,
            "latitude": coordinate.latitude,
            "longitude": coordinate.longitude]
    }

    /// Update record ID after a successful insertion
    override func didInsertWithRowID(rowID: Int64, forColumn column: String?) {
        id = rowID
    }

    struct sortItmes {
        static let id = SQLColumn("id")
        static let title = SQLColumn("title")
        static let latitude = SQLColumn("latitude")
        static let longitude = SQLColumn("longitude")
    }
}