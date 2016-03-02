//: Playground - noun: a place where people can play


import GRDB
import CoreLocation

class DBStore{

    static let sharedInstance = DBStore()

    var dbQueue: DatabaseQueue!

    private  init(){

        var configuration = Configuration()
        configuration.trace = { print($0) }
        dbQueue = DatabaseQueue(configuration: configuration)
        initializeTables()
    }
    
    func initializeTables() {
        do {
            try dbQueue.inDatabase { db in
                try db.execute(
                    "CREATE TABLE pointOfInterests (" +
                        "id INTEGER PRIMARY KEY, " +
                        "title TEXT, " +
                        "latitude TEXT, " +
                        "longitude TEXT" +
                    ")")
            }
        }catch{
            print("")
        }
    }

    enum operationType{
        case insert
        case update
        case save
        case delete
    }

    func  run(operation operation: operationType, withRowObject rowObject: Record){
        do {
            try dbQueue.inDatabase { db in
                switch operation {
                case .insert:
                    try rowObject.insert(db)
                case .update:
                    try rowObject.update(db)
                case .save:
                    try rowObject.save(db)
                case .delete:
                    try rowObject.delete(db)
                }
            }
        } catch {
            print("")
        }
    }

    func isModelObjectExist(modelObject: Record){

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


let dbStore = DBStore()

//: 1.数据库插入

let poiA1 = PointOfInterest(title: "wuhan", coordinate: CLLocationCoordinate2DMake(CLLocationDegrees(10.0), CLLocationDegrees(20.0)))
let poiA2 = PointOfInterest(title: "wuhan", coordinate: CLLocationCoordinate2DMake(CLLocationDegrees(30.0), CLLocationDegrees(20.0)))
let poiB1 = PointOfInterest(title: "guangzhou", coordinate: CLLocationCoordinate2DMake(CLLocationDegrees(30.0), CLLocationDegrees(40.0)))
let poiB2 = PointOfInterest(title: "guangzhou", coordinate: CLLocationCoordinate2DMake(CLLocationDegrees(60.0), CLLocationDegrees(50.0)))

dbStore.run(operation: .insert, withRowObject: poiA1)
dbStore.run(operation: .insert, withRowObject: poiA2)
dbStore.run(operation: .insert, withRowObject: poiB1)
dbStore.run(operation: .insert, withRowObject: poiB2)

poiB2.title = "guangzhou2"
dbStore.run(operation: .save, withRowObject: poiB2)
//: 2. 查询


//:     2.0 全部
dbStore.dbQueue.inDatabase { db in
    let pois = PointOfInterest.fetchAll(db)
    print("LINE:",__LINE__,"<--",pois)
}

dbStore.dbQueue.inDatabase { db in
    let pois = PointOfInterest.all().fetchAll(db)
    print("LINE:",__LINE__,"<--",pois)
}


//:     2.1 多条件排序

dbStore.dbQueue.inDatabase { db in
    let pois = PointOfInterest.order(PointOfInterest.sortItmes.title, PointOfInterest.sortItmes.latitude).fetchAll(db)
    pois.map{
        let poi:PointOfInterest = $0
        print("LINE:",__LINE__,"<--",poi)
        print("LINE:",__LINE__,"<--",poi.title)
    }
}

//:     2.2反序
dbStore.dbQueue.inDatabase { db in
    let pois = PointOfInterest.order(PointOfInterest.sortItmes.title).reverse().fetchAll(db)
    pois.map{print("LINE:",__LINE__,"<--",$0)}
}

//:     2.3限制数量

dbStore.dbQueue.inDatabase { db in
    let pois = PointOfInterest.limit(1).fetchAll(db)
    print("LINE:",__LINE__,"<--",pois)
}

dbStore.dbQueue.inDatabase { db in
    let pois = PointOfInterest.limit(1,offset:1).fetchAll(db)
    print("LINE:",__LINE__,"<--",pois)
}

//:    2.4 筛选
dbStore.dbQueue.inDatabase { db in
    let pois = PointOfInterest.filter(PointOfInterest.sortItmes.longitude < (PointOfInterest.sortItmes.latitude)).fetchAll(db)
    print("LINE:",__LINE__,"<--",pois)
}

dbStore.dbQueue.inDatabase { db in
    let pois = PointOfInterest.filter(PointOfInterest.sortItmes.title == "wuhan").fetchAll(db)
    pois.map{print("LINE:",__LINE__,"<--",$0)}
}


//:     2.5函数筛选

dbStore.dbQueue.inDatabase { db in
    let count = PointOfInterest.select(PointOfInterest.sortItmes.title).fetchCount(db)
    print("LINE:",__LINE__,"<--",count)
}

dbStore.dbQueue.inDatabase { db in
    let count = PointOfInterest.filter(PointOfInterest.sortItmes.title == "wuhan").fetchCount(db)
    print("LINE:",__LINE__,"<--",count)
}

/*
PRAGMA foreign_keys = ON
CREATE TABLE pointOfInterests (id INTEGER PRIMARY KEY, title TEXT, latitude TEXT, longitude TEXT)
PRAGMA table_info("pointOfInterests")
INSERT INTO "pointOfInterests" ("title","id","longitude","latitude") VALUES ('wuhan',NULL,20.0,10.0)
INSERT INTO "pointOfInterests" ("title","id","longitude","latitude") VALUES ('wuhan',NULL,20.0,30.0)
INSERT INTO "pointOfInterests" ("title","id","longitude","latitude") VALUES ('guangzhou',NULL,40.0,30.0)
INSERT INTO "pointOfInterests" ("title","id","longitude","latitude") VALUES ('guangzhou',NULL,50.0,60.0)
UPDATE "pointOfInterests" SET "title"='guangzhou2',"longitude"=50.0,"latitude"=60.0 WHERE "id"=4
SELECT * FROM "pointOfInterests"
LINE: 137 <-- [<PointOfInterest title:"wuhan" id:1 longitude:20.0 latitude:10.0>, <PointOfInterest title:"wuhan" id:2 longitude:20.0 latitude:30.0>, <PointOfInterest title:"guangzhou" id:3 longitude:40.0 latitude:30.0>, <PointOfInterest title:"guangzhou2" id:4 longitude:50.0 latitude:60.0>]
SELECT * FROM "pointOfInterests"
LINE: 142 <-- [<PointOfInterest title:"wuhan" id:1 longitude:20.0 latitude:10.0>, <PointOfInterest title:"wuhan" id:2 longitude:20.0 latitude:30.0>, <PointOfInterest title:"guangzhou" id:3 longitude:40.0 latitude:30.0>, <PointOfInterest title:"guangzhou2" id:4 longitude:50.0 latitude:60.0>]
SELECT * FROM "pointOfInterests" ORDER BY "title", "latitude"
LINE: 151 <-- <PointOfInterest title:"guangzhou" id:3 longitude:40.0 latitude:30.0>
LINE: 152 <-- Optional("guangzhou")
LINE: 151 <-- <PointOfInterest title:"guangzhou2" id:4 longitude:50.0 latitude:60.0>
LINE: 152 <-- Optional("guangzhou2")
LINE: 151 <-- <PointOfInterest title:"wuhan" id:1 longitude:20.0 latitude:10.0>
LINE: 152 <-- Optional("wuhan")
LINE: 151 <-- <PointOfInterest title:"wuhan" id:2 longitude:20.0 latitude:30.0>
LINE: 152 <-- Optional("wuhan")
SELECT * FROM "pointOfInterests" ORDER BY "title" DESC
LINE: 158 <-- <PointOfInterest title:"wuhan" id:1 longitude:20.0 latitude:10.0>
LINE: 158 <-- <PointOfInterest title:"wuhan" id:2 longitude:20.0 latitude:30.0>
LINE: 158 <-- <PointOfInterest title:"guangzhou2" id:4 longitude:50.0 latitude:60.0>
LINE: 158 <-- <PointOfInterest title:"guangzhou" id:3 longitude:40.0 latitude:30.0>
SELECT * FROM "pointOfInterests" LIMIT 1
LINE: 164 <-- [<PointOfInterest title:"wuhan" id:1 longitude:20.0 latitude:10.0>]
SELECT * FROM "pointOfInterests" LIMIT 1 OFFSET 1
LINE: 169 <-- [<PointOfInterest title:"wuhan" id:2 longitude:20.0 latitude:30.0>]
SELECT * FROM "pointOfInterests" WHERE ("longitude" < "latitude")
LINE: 174 <-- [<PointOfInterest title:"wuhan" id:2 longitude:20.0 latitude:30.0>, <PointOfInterest title:"guangzhou2" id:4 longitude:50.0 latitude:60.0>]
SELECT * FROM "pointOfInterests" WHERE ("title" = 'wuhan')
LINE: 179 <-- <PointOfInterest title:"wuhan" id:1 longitude:20.0 latitude:10.0>
LINE: 179 <-- <PointOfInterest title:"wuhan" id:2 longitude:20.0 latitude:30.0>
SELECT COUNT(*) FROM "pointOfInterests"
LINE: 186 <-- 4
SELECT COUNT(*) FROM "pointOfInterests" WHERE ("title" = 'wuhan')
LINE: 191 <-- 2

*/

