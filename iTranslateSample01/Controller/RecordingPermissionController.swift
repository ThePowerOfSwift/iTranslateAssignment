//
//  RecordingPermissionController.swift
//  iTranslateSample01
//
//  Created by Anuradh Caldera on 10/19/19.
//  Copyright © 2019 iTranslate. All rights reserved.
//

import UIKit
import AVFoundation

class RecordingPermissionController: BaseController {
    
    private var recordingSession: AVAudioSession!
    private var permissionView: PermissionView!
    
    init(recordingSession: AVAudioSession) {
        self.recordingSession = recordingSession
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpPermissionView()
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

//MARK: - Setup Permission View

extension RecordingPermissionController {
    private func setUpPermissionView() {
        
        let permissionview = PermissionView(_imagename: "Micgray")
        permissionview.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(permissionview)
        
        let permissioinviewConstraints = [permissionview.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                                          permissionview.topAnchor.constraint(equalTo: self.view.topAnchor),
                                          permissionview.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                                          permissionview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)]
        
        NSLayoutConstraint.activate(permissioinviewConstraints)
        
        permissionview.allowpermissionCallBack = { [weak self]  in
            self?.requestPersmssion()
            return
        }
        
        permissionview.askmelaterCallBack = { [weak self] in
            self?.goBack()
            return
        }
    }
}

//MARK: - Request for user permission

extension RecordingPermissionController {
    private func requestPersmssion() {
        recordingSession.requestRecordPermission { (permission) in
            self.goBack()
            return
        }
    }
}


//MARK: - Go Bak
extension RecordingPermissionController {
    private func goBack() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
