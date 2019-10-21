//
//  RecordingView.swift
//  iTranslateSample01
//
//  Created by Anuradh Caldera on 10/19/19.
//  Copyright © 2019 iTranslate. All rights reserved.
//

import UIKit
import AVFoundation

class RecordingView: BaseView {
    private var imageName: String?
    private var recordsoundimageView: UIImageView!
    private var showrecordingButton: UIButton!
    private var pulseLayer: PulseLayer!
    
    private var recordingSession: AVAudioSession!
    private var recordingHelper: RecordingHelper!
    private var persistenceManager: PersistenceManager!
    
    
    var ispermissionAllowedCallBack: ((Bool, Bool) -> ())?
    var showRecordingsCallBack: (() -> ())?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(_imagename: String? = nil, persistenceManager: PersistenceManager) {
        super.init(frame: .zero)
        
        self.persistenceManager = persistenceManager
        recordingSession = AVAudioSession.sharedInstance()
        recordingHelper = RecordingHelper(recordingSession: recordingSession, persistenceManager: persistenceManager)
        
        self.backgroundColor = .white
        self.imageName = _imagename
        
        DispatchQueue.main.async {
            self.setMicrophoneImageView()
            self.setShowRecordingsButton()
        }
    }
}

//MARK: - Setup Microphone image view

extension RecordingView {
    private func setMicrophoneImageView() {
        
        recordsoundimageView = UIImageView()
        recordsoundimageView.translatesAutoresizingMaskIntoConstraints = false
        recordsoundimageView.backgroundColor = .white
        recordsoundimageView.contentMode = .scaleAspectFit
        recordsoundimageView.isUserInteractionEnabled = true
        
        if let _imageName = imageName {
            recordsoundimageView.image = UIImage(named: _imageName)
        }
        
        self.addSubview(recordsoundimageView)
        
        let recordsoundimageViewConstraints = [recordsoundimageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                                               recordsoundimageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                                    recordsoundimageView.widthAnchor.constraint(equalToConstant: 120),
                                    recordsoundimageView.heightAnchor.constraint(equalToConstant: 120)]
        NSLayoutConstraint.activate(recordsoundimageViewConstraints)
        
        recordsoundimageView.layer.cornerRadius = 60

        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(tapToRecord(_:)))
        recordsoundimageView.addGestureRecognizer(tapgesture)
    }
}

//MARK: - Setup Show Recording Button

extension RecordingView {
    private func setShowRecordingsButton() {
        
        showrecordingButton = UIButton()
        showrecordingButton.translatesAutoresizingMaskIntoConstraints = false
        showrecordingButton.backgroundColor = .white
        showrecordingButton.setTitle("Show Recordings", for: .normal)
        showrecordingButton.setTitleColor(blueColor, for: .normal)
        showrecordingButton.titleLabel?.font = UIFont(name: "Helvetica", size: 20)
        showrecordingButton.titleLabel?.adjustsFontSizeToFitWidth = true
        showrecordingButton.titleLabel?.minimumScaleFactor = 0.2
        
        self.addSubview(showrecordingButton)
        
        let showrecordbuttonConstraints = [showrecordingButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                                           showrecordingButton.topAnchor.constraint(equalTo: recordsoundimageView.bottomAnchor, constant: 80),
                                           showrecordingButton.widthAnchor.constraint(equalToConstant: 220),
                                           showrecordingButton.heightAnchor.constraint(equalToConstant: 45)]
        NSLayoutConstraint.activate(showrecordbuttonConstraints)
        
        showrecordingButton.layer.cornerRadius = 5
        showrecordingButton.layer.borderColor = blueColor.cgColor
        showrecordingButton.layer.borderWidth = 1
        
        showrecordingButton.addTarget(self, action: #selector(showRecordings(_:)), for: .touchUpInside)
    }
}

//MARK: - Tap Gesture Function for image

extension RecordingView {
    @objc private func tapToRecord(_ recognizer: UITapGestureRecognizer) {
        
        self.showrecordingButton.isEnabled = false
        let (ispermited, denied) = recordingHelper.checkMicrophonePermission()
        if !ispermited {
            ispermissionAllowedCallBack!(ispermited, denied)
            return
        }
        
        recordingHelper.recordStartStopCallBack = { [weak self] recording in
            if recording {
                self?.addAnimation()
                return
            }
            
            self?.showrecordingButton.isEnabled = true
            self?.remomoveAnimation()
            return
        }
        recordingHelper.startStopRecording()
        return
    }
}

//MARK: - Show Recordings button action

extension RecordingView {
    @objc private func showRecordings(_ sender: UIButton) {
        self.showRecordingsCallBack!()
        return
    }
}

//MARK: - Remove animation

extension RecordingView {
    func remomoveAnimation() {
        DispatchQueue.main.async {
            self.pulseLayer.removeAllAnimations()
        }
    }
}

//MARK: - Show animation

extension RecordingView {
    func addAnimation() {
        DispatchQueue.main.async {
            self.pulseLayer = PulseLayer(_numberofPulses: .infinity, _radius: 100, _position: self.center)
            self.layer.insertSublayer(self.pulseLayer, below: self.recordsoundimageView.layer)
        }
    }
}
