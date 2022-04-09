//
//  AppDatabase.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/9.
//

import Foundation
import GRDB
import ObjectiveC

let appDB = AppDatabase.shared

// MARK: - AppDatabase
final class AppDatabase {
    
    static let version: String = "1.0.0"
        
    /// Provides access to the database.
    ///
    /// Application can use a `DatabasePool`, and tests can use a fast
    /// in-memory `DatabaseQueue`.
    ///
    /// See <https://github.com/groue/GRDB.swift/blob/master/README.md#database-connections>
    private let dbWriter: DatabaseWriter
    
    /// The DatabaseMigrator that defines the database schema.
    ///
    /// See <https://github.com/groue/GRDB.swift/blob/master/Documentation/Migrations.md>
    private lazy var migrator: DatabaseMigrator = DatabaseMigrator()
    
    /// Provides a read-only access to the database
    var dbReader: DatabaseReader {
        dbWriter
    }
    
    /// Creates an `AppDatabase`, and make sure the database schema is ready.
    init(_ dbWriter: DatabaseWriter) throws {
        self.dbWriter = dbWriter
        
        try migrate()
    }
    
}

// MARK: - Path
extension AppDatabase {
    
    static let dbFolderName: String = "Database"
    static let dbFileName: String = "db.sqlite"
    static let dbFolderURL: URL = {
        do {
            // Create a folder for storing the SQLite database, as well as
            // the various temporary files created during normal database
            // operations (https://sqlite.org/tempfiles.html).
            let fileManager = FileManager()
    //            let folderURL = try fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("database", isDirectory: true)
            
            let folderURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(dbFolderName, isDirectory: true)
            
            try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true)
            
            return folderURL
        } catch {
            log.error("创建数据库文件夹失败")
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        }
    }()
    
    // Connect to a database on disk
    // See https://github.com/groue/GRDB.swift/blob/master/README.md#database-connections
    static let dbFileURL: URL = { dbFolderURL.appendingPathComponent(dbFileName)
    }()
    
}

// MARK: - Persistence
extension AppDatabase {
    /// The database for the application
    static let shared = makeShared()
    
    private static func makeShared() -> AppDatabase {
        do {
            let dbPool = try DatabasePool(path: dbFileURL.path)
                        
            // Create the AppDatabase
            let appDatabase = try AppDatabase(dbPool)
            
            log.info("数据库路径：\n\(dbFileURL.absoluteString)")
            
            return appDatabase
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate.
            //
            // Typical reasons for an error here include:
            // * The parent directory cannot be created, or disallows writing.
            // * The database is not accessible, due to permissions or data protection when the device is locked.
            // * The device is out of space.
            // * The database could not be migrated to its latest schema version.
            // Check the error message to determine what the actual problem was.
            fatalError("Unresolved error \(error)")
        }
    }
    
    func connect() {
        
    }
//    class func test() {
//        do {
//            try shared.dbWriter.write { db in
//                let c1 = XWHTestModel()
//                c1.name = "hello100"
//                c1.score = 12000
//                try c1.insert(db)
//            }
//        } catch let e {
//            log.error(e)
//        }
//    }
}

// MARK: - migrate
extension AppDatabase {
    
    private func migrate() throws {
        #if DEBUG
            // Speed up development by nuking the database when migrations change
            // See https://github.com/groue/GRDB.swift/blob/master/Documentation/Migrations.md#the-erasedatabaseonschemachange-option
            migrator.eraseDatabaseOnSchemaChange = true
        #endif
        
        migrator.registerMigration("1.0.0") { db in
            // Create a table
            // See https://github.com/groue/GRDB.swift#create-tables
            try XWHDataUserManager.createUserModelTable(db)
            try XWHDataDeviceManager.createDeviceModelTable(db)
        }
        
//        migrator.registerMigration("1.0.1") { db in
//            // Create a table
//            // See https://github.com/groue/GRDB.swift#create-tables
//            try db.alter(table: XWHTestModel.databaseTableName, body: { ta in
//                ta.add(column: "age", .integer).notNull().defaults(to: 0)
//            })
//        }
        
        try migrator.migrate(dbWriter)
    }
    
}

// MARK: - warpper
extension AppDatabase {
    
    public func write<T>(_ updates: (Database) throws -> T) {
        do {
            let _ = try dbWriter.write(updates)
        } catch let e {
            log.error("数据写入失败, e = \(e)")
        }
    }
    
    public func read<T>(_ value: (Database) throws -> T?) -> T? {
        do {
            return try dbReader.read(value)
        } catch let e {
            log.error("数据读取失败, e = \(e)")
            return nil
        }
    }
    
}
