//
//  iTranslateSample01Tests.swift
//  iTranslateSample01Tests
//
//  Created by Andreas Gruber on 04.07.19.
//  Copyright © 2019 iTranslate. All rights reserved.
//

import XCTest
@testable import iTranslateSample01

class iTranslateSample01Tests: XCTestCase {
    
    var persistenceManager: PersistenceManager!
    
    override func setUp() {
        super.setUp()
        self.persistenceManager = PersistenceManager.sharedInstance
    }
    
    //MARK: - Test Save Context
    func testSaveContext() {

        let records = Records(context: persistenceManager.context)
        records.recordId = UUID().uuidString
        records.recordName = "iTranslate \(1)"
        records.recorderFilePath = "iTranslate \(UUID().uuidString).m4a"
        records.recordDuration = "00:00"
        records.recordedDate = Date()
        records.lasteUpdated = Date()
        
        persistenceManager.saveContext()
    }
    
    //MARK: - Test Delete Context With Query
    
    func testDeleteContext() {
        
        let deleted =  persistenceManager.deleteContext(Records.self, objectId: "HDK2-EKREK-AFDK-3JKFE2")
        XCTAssertTrue(deleted)
    }
    
    //MARK: - Test Fetch Context
    
    func testFetchContext() {
        let records = persistenceManager.fetchContexts(Records.self)
        XCTAssertEqual(records.count, 0)
    }
    
    //MARK: - Test Recording View Model
    
    func testRecordingViewModel() {
       
        let records: Records = Records(context: persistenceManager.context)
        records.recordId = UUID().uuidString
        records.recordName = "iTranslate 2"
        records.recorderFilePath = "iTranslate 2.m4a"
        records.recordDuration = "00:00"
        records.recordedDate = Date()
        records.lasteUpdated = Date()
        
        let recordingviewModel: RecordingViewModel = RecordingViewModel(records: records)
        
        XCTAssertEqual(records.recordId, recordingviewModel.recordingId)
        XCTAssertEqual(records.recordName, recordingviewModel.recordingName)
        XCTAssertEqual(records.recorderFilePath, recordingviewModel.recordingFilePath)
        XCTAssertEqual(records.recordDuration, recordingviewModel.recordingDuration)
    }

}
