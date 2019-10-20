//
//  RecordingViewModel.swift
//  iTranslateSample01
//
//  Created by Anuradh Caldera on 10/20/19.
//  Copyright © 2019 iTranslate. All rights reserved.
//

import Foundation
import AVFoundation

struct RecordingViewModel: Codable {
    
    var recordingId: String?
    var recordingFilePath: String?
    var recordingName: String?
    var recordingDuration: String?
    var recordedData: String?
    var recordLastmodifiedData: String?
    
    init(records: Records) {
        self.recordingId = records.recordId
        self.recordingFilePath = records.recorderFilePath
        self.recordingName = records.recordName
        self.recordingDuration = records.recordDuration
        self.recordedData = convertDateToString(date: records.recordedDate)
        self.recordLastmodifiedData = convertDateToString(date: records.lasteUpdated)
    }
}

//MARK: - Convert Date To String
extension RecordingViewModel {
    private func convertDateToString(date: Date?) -> String {
        guard let _date = date else {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy hh:mm:ss"
        let datestring = dateFormatter.string(from: _date)
        return datestring
    }
}



