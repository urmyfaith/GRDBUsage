//
//  Database.swift
//  GRDBUsage
//
//  Created by zx on 3/1/16.
//  Copyright © 2016 zx. All rights reserved.
//

import GRDB

struct Col {
    static let id = SQLColumn("id")
    static let firstName = SQLColumn("firstName")
    static let lastName = SQLColumn("lastName")
}


var dbQueue: DatabaseQueue!

func setupDataBase() {

    //创建DBQueue
    let documentPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! as NSString
    let databasePath = documentPath.stringByAppendingPathComponent("db.sqlite")
    dbQueue = try! DatabaseQueue(path: databasePath)


    //整理下数据库.
    let collation = DatabaseCollation("localized_case_insensitive") { (lhs, rhs) in
        return (lhs as NSString).localizedCaseInsensitiveCompare(rhs)
    }

    dbQueue.inDatabase { (db) -> Void in
        db.addCollation(collation)
    }

    //初始化数据库
    var migrator = DatabaseMigrator()
    migrator.registerMigration("createPersons") { (db) -> Void in
        try db.execute(
//            "CREATE TABLE persons (" +
//                "id INTEGER PRIMARY KEY, " +
//                "firstName TEXT COLLATE localized_case_insensitive, " +
//                "lastName TEXT COLLATE localized_case_insensitive" +
//            ")"
            "CREATE TABLE persons (" +
                "id INTEGER PRIMARY KEY, " +
                "firstName TEXT COLLATE localized_case_insensitive, " +
                "lastName TEXT COLLATE localized_case_insensitive" +
            ")"
        )
    }
    migrator.registerMigration("addPsersons") { (db) -> Void in
        try Person(firstName: "Arthur", lastName: "Miller").insert(db)
        try Person(firstName: "Barbra", lastName: "Streisand").insert(db)
        try Person(firstName: "Cinderella").insert(db)
    }

    try! migrator.migrate(dbQueue)
}