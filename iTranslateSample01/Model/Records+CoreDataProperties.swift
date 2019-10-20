//
//  Records+CoreDataProperties.swift
//  iTranslateSample01
//
//  Created by Anuradh Caldera on 10/20/19.
//  Copyright © 2019 iTranslate. All rights reserved.
//
//

import Foundation
import CoreData


extension Records {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Records> {
        return NSFetchRequest<Records>(entityName: "Records")
    }

    @NSManaged public var recordId: String?
    @NSManaged public var recordName: String?
    @NSManaged public var recordDuration: String?
    @NSManaged public var recordedDate: Date?
    @NSManaged public var lasteUpdated: Date?
    @NSManaged public var recorderFilePath: String?

}
