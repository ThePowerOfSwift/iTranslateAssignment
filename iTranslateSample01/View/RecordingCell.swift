//
//  RecordingCell.swift
//  iTranslateSample01
//
//  Created by Anuradh Caldera on 10/20/19.
//  Copyright © 2019 iTranslate. All rights reserved.
//

import UIKit

class RecordingCell: UITableViewCell {
    
    let blueColor: UIColor = UIColor.init(red: 26/255, green: 152/255, blue: 255/255, alpha: 1)
    let lightGrayColor: UIColor = UIColor.init(red: 206/255, green: 212/255, blue: 217/255, alpha: 1)
    
    private var backContainer: UIView!
    private var separatorView: UIView!
    
    private var recordingTimeLabel: UILabel!
    private var recordingNameLabel: UILabel!
    private var createdDateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        setBackgroundView()
        setUpSeparator()
        setUpContent()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var recordingViewModel: RecordingViewModel! {
        didSet {
            recordingNameLabel.text = recordingViewModel.recordingName
            recordingTimeLabel.text = recordingViewModel.recordingDuration
            createdDateLabel.text = recordingViewModel.recordedData
        }
    }
    
}

//MARK: - Setup Background View

extension RecordingCell {
    private func setBackgroundView() {
        
        backContainer = UIView()
        backContainer.translatesAutoresizingMaskIntoConstraints = false
        backContainer.backgroundColor = .white
        
        addSubview(backContainer)
        
        let backcontainerconstraints = [backContainer.leftAnchor.constraint(equalTo: leftAnchor),
                                        backContainer.topAnchor.constraint(equalTo: topAnchor),
                                        backContainer.rightAnchor.constraint(equalTo: rightAnchor),
                                        backContainer.bottomAnchor.constraint(equalTo: bottomAnchor)]
        NSLayoutConstraint.activate(backcontainerconstraints)
    }
}

//MARK: - Setup Separator

extension RecordingCell {
    private func setUpSeparator() {
        
        separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = lightGrayColor
        
        backContainer.addSubview(separatorView)
        
        let separatorviewConstraints = [separatorView.leftAnchor.constraint(equalTo: backContainer.leftAnchor, constant: 20),
                                        separatorView.rightAnchor.constraint(equalTo: backContainer.rightAnchor),
                                        separatorView.bottomAnchor.constraint(equalTo: backContainer.bottomAnchor),
                                        separatorView.heightAnchor.constraint(equalToConstant: 1)]
        NSLayoutConstraint.activate(separatorviewConstraints)
    }
}

//MARK: - Setup Content

extension RecordingCell {
    private func setUpContent() {
        
        recordingTimeLabel = UILabel()
        recordingTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        recordingTimeLabel.textAlignment = .right
        recordingTimeLabel.font = UIFont(name: "Helvetica", size: 22)
        recordingTimeLabel.textColor = blueColor
        recordingTimeLabel.text = "04:55"
        
        backContainer.addSubview(recordingTimeLabel)
        
        let recordingtimelabelConstraints = [recordingTimeLabel.topAnchor.constraint(equalTo: backContainer.topAnchor, constant: 20),
                                             recordingTimeLabel.rightAnchor.constraint(equalTo: backContainer.rightAnchor, constant: -20)]
        NSLayoutConstraint.activate(recordingtimelabelConstraints)
    
        recordingNameLabel = UILabel()
        recordingNameLabel.translatesAutoresizingMaskIntoConstraints = false
        recordingNameLabel.textAlignment = .left
        recordingNameLabel.font = UIFont(name: "Helvetica", size: 20)
        recordingNameLabel.text = "Recording ABCD"
        recordingNameLabel.adjustsFontSizeToFitWidth = true
        recordingNameLabel.minimumScaleFactor = 0.2
        
        backContainer.addSubview(recordingNameLabel)
        
        let recordingNameLabelConstraints = [recordingNameLabel.leftAnchor.constraint(equalTo: backContainer.leftAnchor, constant: 40),
                                             recordingNameLabel.topAnchor.constraint(equalTo: backContainer.topAnchor, constant: 20),
                                             recordingNameLabel.rightAnchor.constraint(equalTo: recordingTimeLabel.leftAnchor, constant: 2)]
        NSLayoutConstraint.activate(recordingNameLabelConstraints)
        
        
        createdDateLabel = UILabel()
        createdDateLabel.translatesAutoresizingMaskIntoConstraints = false
        createdDateLabel.textAlignment = .left
        createdDateLabel.textColor = .lightGray
        createdDateLabel.font = UIFont(name: "Helvetica", size: 18)
        createdDateLabel.text = "2019/05/26 "
        
        backContainer.addSubview(createdDateLabel)
        
        let createdDateLabelConstraints = [createdDateLabel.leftAnchor.constraint(equalTo: backContainer.leftAnchor, constant: 40),
                                             createdDateLabel.topAnchor.constraint(equalTo: recordingNameLabel.bottomAnchor, constant: 5),
                                             createdDateLabel.rightAnchor.constraint(equalTo: backContainer.rightAnchor, constant: -5)]
        NSLayoutConstraint.activate(createdDateLabelConstraints)
    }
}
