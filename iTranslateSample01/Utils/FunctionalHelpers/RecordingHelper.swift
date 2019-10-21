//
//  RecordingHelper.swift
//  iTranslateSample01
//
//  Created by Anuradh Caldera on 10/20/19.
//  Copyright © 2019 iTranslate. All rights reserved.
//

import Foundation
import AVFoundation

class RecordingHelper: NSObject {
    
    private var recordingSession: AVAudioSession!
    private var audioRecorder: AVAudioRecorder!
    private var persistenceManager: PersistenceManager!
    
    private var _recordinId: String?
    private var _filename: String?
    private var _filepath: URL?
    private var _filepathname: String?
    
    var recordStartStopCallBack: ((Bool) -> ())?
    var recordSaveCompleted: ((Bool) -> ())?
    
    
    init(recordingSession: AVAudioSession, persistenceManager: PersistenceManager) {
        self.recordingSession = recordingSession
        self.persistenceManager = persistenceManager
    }
}

//MARK: - Check if user has granted persmission for Microphone

extension RecordingHelper {
    func checkMicrophonePermission() -> (Bool, Bool) {
        switch recordingSession.recordPermission {
        case .granted:
            return (true, true)
        case .denied:
            return (false, true)
        default:
            return (false, false)
        }
    }
}

//MARK: - Start/Stop Recording

extension RecordingHelper {
    func startStopRecording() {
        
        if audioRecorder == nil {
            recordStartStopCallBack!(true)

            _recordinId = CommonHelper.sharedInstance.getRandomGUID()
            
            let numberofRecords = persistenceManager.fetchContextCount(Records.self)
            let directory = CommonHelper.sharedInstance.getDirectory()
            _filename = "Recording \(numberofRecords + 1)"
            _filepathname = "\(_recordinId!).m4a"
            _filepath = directory.appendingPathComponent(_filepathname!)
            
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            
            do {
                audioRecorder = try AVAudioRecorder(url: _filepath!, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()
                return
            } catch (let err) {
                print(err.localizedDescription)
                audioRecorder.stop()
                self.audioRecorder = nil
                recordStartStopCallBack!(false)
                return
            }
        } else {
            audioRecorder.stop()
            self.audioRecorder = nil
            return
        }
    }
}

//MARK: - AVAuido Delegates
extension RecordingHelper: AVAudioRecorderDelegate {

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    
        addRecording { [weak self] in
            self?.recordStartStopCallBack!(false)
            return
        }
        return
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        return
    }
}

//MARK: - Add Recording

extension RecordingHelper {
    private func addRecording(completion: @escaping() -> ()) {
        let newRecording = Records(context: persistenceManager.context)
        newRecording.recordId = _recordinId
        newRecording.recordName = _filename
        newRecording.recorderFilePath = _filepathname
        newRecording.recordDuration = getTimeDuration()
        newRecording.recordedDate = Date()
        newRecording.lasteUpdated = Date()
        
        persistenceManager.saveContext()
        completion()
    }
}


//MARK: - Get Audio time duration

extension RecordingHelper {
    private func getTimeDuration() -> String {
        
        guard let path = _filepath else {
            return ""
        }
        let audioAsset = AVURLAsset.init(url: path, options: nil)
        let duration = audioAsset.duration
        let durationString = CMTime(value: duration.value, timescale: 600).positionalTime
        return durationString
    }
}
