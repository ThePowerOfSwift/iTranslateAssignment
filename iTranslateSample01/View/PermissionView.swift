//
//  PermissionView.swift
//  iTranslateSample01
//
//  Created by Anuradh Caldera on 10/19/19.
//  Copyright © 2019 iTranslate. All rights reserved.
//

import UIKit

class PermissionView: BaseView {
    
    private var imageName: String?
    private var backgroundContainer: UIView!
    private var microphoneimageView: UIImageView!
    private var headerinfoLabel: UILabel!
    private var laterButton: UIButton!
    private var allowButton: UIButton!
    private var subinfoLabel: UILabel!
    
    var allowpermissionCallBack: (() ->())?
    var askmelaterCallBack: (() -> ())?
    var userdeniedCallBack: (() -> ())?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(_imagename: String? = nil) {
        
        super.init(frame: .zero)
        
        self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.6)
        self.imageName = _imagename
        
        DispatchQueue.main.async {
            self.setbackgroundView()
            self.setUpMicorphoneImageView()
            self.setUpInfoLabels()
            self.setLaterButton()
            self.setAllowButton()
            self.setSubInfoLabel()
        }
    }
}

//MARK: - Setup Background

extension PermissionView {
    private func setbackgroundView() {
        
        backgroundContainer = UIView()
        backgroundContainer.translatesAutoresizingMaskIntoConstraints = false
        backgroundContainer.backgroundColor = .white
        self.addSubview(backgroundContainer)
        
        var _containerWidth: CGFloat = deviceWidth - 60
        var _containerHeight: CGFloat = 3 * deviceHeight/4
        
        if deviceIdom != .phone {
            _containerWidth = deviceWidth/2
            _containerHeight = _containerHeight/1.5
        }
        
        let backgroundcontainerConstraints = [backgroundContainer.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                                              backgroundContainer.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                                              backgroundContainer.widthAnchor.constraint(equalToConstant: _containerWidth),
                                              backgroundContainer.heightAnchor.constraint(equalToConstant: _containerHeight)]
        
        NSLayoutConstraint.activate(backgroundcontainerConstraints)
        
        backgroundContainer.layer.cornerRadius = 8
    }
}

//MARK: - Setup Mirophone image view

extension PermissionView {
    private func setUpMicorphoneImageView() {
        microphoneimageView = UIImageView()
        microphoneimageView.translatesAutoresizingMaskIntoConstraints = false
        microphoneimageView.backgroundColor = .white
        microphoneimageView.contentMode = .scaleAspectFit
        
        if let _imageName = imageName {
            microphoneimageView.image = UIImage(named: _imageName)
        }
        
        backgroundContainer.addSubview(microphoneimageView)
        
        let microphoneimageviewConstriants = [microphoneimageView.centerXAnchor.constraint(equalTo: backgroundContainer.centerXAnchor),
                                              microphoneimageView.topAnchor.constraint(equalTo: backgroundContainer.topAnchor, constant: 50),
                                              microphoneimageView.widthAnchor.constraint(equalToConstant: 120),
                                              microphoneimageView.heightAnchor.constraint(equalToConstant: 120)]
        NSLayoutConstraint.activate(microphoneimageviewConstriants)
    }
}

//MARK: - Setup Info Label

extension PermissionView {
    private func setUpInfoLabels() {
        
        headerinfoLabel = UILabel()
        headerinfoLabel.translatesAutoresizingMaskIntoConstraints = false
        headerinfoLabel.textColor = .lightGray
        headerinfoLabel.textAlignment = .center
        headerinfoLabel.font = UIFont(name: "Helvetica", size: 30)
        headerinfoLabel.text = "Microphone"
        headerinfoLabel.adjustsFontSizeToFitWidth = true
        headerinfoLabel.minimumScaleFactor = 0.2
        
        backgroundContainer.addSubview(headerinfoLabel)
        
        let headerinfolabelContraints = [headerinfoLabel.leftAnchor.constraint(equalTo: backgroundContainer.leftAnchor, constant: 5),
                                         headerinfoLabel.topAnchor.constraint(equalTo: microphoneimageView.bottomAnchor, constant: 10),
                                         headerinfoLabel.rightAnchor.constraint(equalTo: backgroundContainer.rightAnchor, constant: -5)]
        NSLayoutConstraint.activate(headerinfolabelContraints)
    }
}

//MARK: - Setup later button

extension PermissionView {
    private func setLaterButton() {
        
        laterButton = UIButton()
        laterButton.translatesAutoresizingMaskIntoConstraints = false
        laterButton.setTitle("Maybe later", for: .normal)
        laterButton.setTitleColor(blueColor, for: .normal)
        laterButton.titleLabel?.font = UIFont(name: "Helvetica", size: 17)
        
        backgroundContainer.addSubview(laterButton)
        
        let laterbuttonConstraints = [laterButton.centerXAnchor.constraint(equalTo: backgroundContainer.centerXAnchor),
                                      laterButton.bottomAnchor.constraint(equalTo: backgroundContainer.bottomAnchor, constant: -40),
                                      laterButton.heightAnchor.constraint(equalToConstant: 40),
                                      laterButton.widthAnchor.constraint(equalToConstant: 100)]
        NSLayoutConstraint.activate(laterbuttonConstraints)
        
        laterButton.addTarget(self, action: #selector(askmelaterAction(_:)), for: .touchUpInside)
    }
}

//MARK: - Setup allow button

extension PermissionView {
    private func setAllowButton() {
        
        allowButton = UIButton()
        allowButton.translatesAutoresizingMaskIntoConstraints = false
        allowButton.backgroundColor = .white
        allowButton.setTitleColor(blueColor, for: .normal)
        allowButton.setTitle("Allow", for: .normal)
        allowButton.titleLabel?.font = UIFont(name: "Helvetica", size: 20)
        allowButton.titleLabel?.adjustsFontSizeToFitWidth = true
        allowButton.titleLabel?.minimumScaleFactor = 0.2
        
        backgroundContainer.addSubview(allowButton)
        
        let allowbuttonConstraints = [allowButton.leftAnchor.constraint(equalTo: backgroundContainer.leftAnchor, constant: 40),
                                      allowButton.bottomAnchor.constraint(equalTo: laterButton.topAnchor, constant: -30),
                                      allowButton.rightAnchor.constraint(equalTo: backgroundContainer.rightAnchor, constant: -40),
                                      allowButton.heightAnchor.constraint(equalToConstant: 45)]
        NSLayoutConstraint.activate(allowbuttonConstraints)
        
        allowButton.layer.cornerRadius = 5
        allowButton.layer.borderColor = blueColor.cgColor
        allowButton.layer.borderWidth = 1
        
        allowButton.addTarget(self, action: #selector(allowPermissionAction(_:)), for: .touchUpInside)
    }
}

//MARK: - Setup sub info label

extension PermissionView {
    private func setSubInfoLabel() {
        
        subinfoLabel = UILabel()
        subinfoLabel.translatesAutoresizingMaskIntoConstraints = false
        subinfoLabel.textColor = .lightGray
        subinfoLabel.textAlignment = .center
        subinfoLabel.numberOfLines = 0
        subinfoLabel.font = UIFont(name: "Helvetica", size: 17)
        subinfoLabel.text = "In order to use voice to voice conversation, iTranslate needs your permission to use your iPhone’s microphone."
        subinfoLabel.adjustsFontSizeToFitWidth = true
        subinfoLabel.minimumScaleFactor = 0.2
        
        backgroundContainer.addSubview(subinfoLabel)
        
        let subinfolabelConstraints = [subinfoLabel.leftAnchor.constraint(equalTo: backgroundContainer.leftAnchor, constant: 40),
                                       subinfoLabel.topAnchor.constraint(equalTo: headerinfoLabel.bottomAnchor, constant: 20),
                                       subinfoLabel.rightAnchor.constraint(equalTo: backgroundContainer.rightAnchor, constant: -40),
                                       subinfoLabel.bottomAnchor.constraint(equalTo: allowButton.topAnchor, constant: -10)]
        NSLayoutConstraint.activate(subinfolabelConstraints)
    }
}

//MARK: - Allow Permission Action

extension PermissionView {
    @objc private func allowPermissionAction(_ sender: UIButton) {
        allowpermissionCallBack!()
        return
    }
}

//MARK: - Ask Later Action

extension PermissionView {
    @objc private func askmelaterAction(_ sender: UIButton) {
        askmelaterCallBack!()
        return
    }
}

