//
//  RecordingController.swift
//  iTranslateSample01
//
//  Created by Anuradh Caldera on 10/19/19.
//  Copyright © 2019 iTranslate. All rights reserved.
//

import UIKit
import AVFoundation

class RecordingController: BaseController {
    
    private var recordingSession: AVAudioSession!
    private let persistenceManager: PersistenceManager!
    private var recordingView: RecordingView!

    init(persistenceManager: PersistenceManager) {
        self.recordingSession = AVAudioSession.sharedInstance()
        self.persistenceManager = persistenceManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpRecordingView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar(_animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showNavigationBar(_animated: animated)
    }
}

//MARK: - Setup Recording View

extension RecordingController {
    private func setUpRecordingView() {
        
        let recordingView = RecordingView(_imagename: "Mic", persistenceManager: persistenceManager)
        recordingView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(recordingView)
        let recordingviewConstraints = [recordingView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                                        recordingView.topAnchor.constraint(equalTo: self.view.topAnchor),
                                        recordingView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                                        recordingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)]
        
        NSLayoutConstraint.activate(recordingviewConstraints)
        
        recordingView.showRecordingsCallBack = {
            self.navigateToShowRecordings()
            return
        }
        
        recordingView.ispermissionAllowedCallBack = { [weak self] (allowed, denied) in
            if !allowed {
                if denied {
                    self?.navigatetoSettings()
                    return
                }
                self?.navigateToShowPermission(denied: denied)
                return
            }
        }
    }
}

//MARK: - Navigate to Show Permission

extension RecordingController {
    private func navigateToShowPermission(denied: Bool) {
        let permissionController = RecordingPermissionController(recordingSession: recordingSession)
        permissionController.providesPresentationContextTransitionStyle = true
        permissionController.definesPresentationContext = true
        permissionController.modalPresentationStyle = .overCurrentContext
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(permissionController, animated: true)
        }
        
    }
}

//MARK: - Navigate to Settings

extension RecordingController {
    private func navigatetoSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            return
        }
        return
    }
}

//MARK: - Navigate to Show Recordings

extension RecordingController {
    private func navigateToShowRecordings() {
        let showrecordingController = ShowRecordingController(persistenceManager: persistenceManager)
        self.navigationController?.pushViewController(showrecordingController, animated: true)
    }
}
