//
//  ShowRecordingController.swift
//  iTranslateSample01
//
//  Created by Anuradh Caldera on 10/19/19.
//  Copyright © 2019 iTranslate. All rights reserved.
//

import UIKit
import AVFoundation

class ShowRecordingController: BaseController {
    
    private let persistenceManager: PersistenceManager!
    private var recordingViewModels: [RecordingViewModel] = []
    private var recordingTableView: UITableView!
    private let recordingcellIdentifier = "recordingcellIdentifier"
    
    private var audioPlayer: AVAudioPlayer!
    
    init(persistenceManager: PersistenceManager) {
        self.persistenceManager = persistenceManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        setupRecordsTableView()
        fetchRecordings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideBackButton()
    }
}

//MARK: - Setup Bar buttons

extension ShowRecordingController {
    private func setUpNavBar() {
        let donebarButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneAction(_:)))
        self.navigationItem.rightBarButtonItem = donebarButton
        self.navigationItem.title = "Recordings"
    }
}

// MARK: - Bar Button Action

extension ShowRecordingController {
    @objc private func doneAction(_ sender: UIBarButtonItem) {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

//MARK: - Setup Records Table View

extension ShowRecordingController {
    private func setupRecordsTableView() {
        
        recordingTableView = UITableView(frame: .zero, style: .grouped)
        recordingTableView.translatesAutoresizingMaskIntoConstraints = false
        recordingTableView.register(RecordingCell.self, forCellReuseIdentifier: recordingcellIdentifier)
        recordingTableView.dataSource = self
        recordingTableView.delegate = self
        recordingTableView.tableFooterView = UIView()
        recordingTableView.separatorStyle = .none
        view.addSubview(recordingTableView)
        
        let recordingtableViewConstraitns = [recordingTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                                             recordingTableView.topAnchor.constraint(equalTo: self.view.topAnchor),
                                             recordingTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                                             recordingTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)]
        
        NSLayoutConstraint.activate(recordingtableViewConstraitns)
    }
}

//MARK: - Table View DataSource

extension ShowRecordingController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordingViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let recording: RecordingViewModel = recordingViewModels[indexPath.row]
    
        let recordingCell = tableView.dequeueReusableCell(withIdentifier: recordingcellIdentifier) as! RecordingCell
        recordingCell.recordingViewModel = recording
        return recordingCell
    }

}

//MARK: - Table View Delegates

extension ShowRecordingController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: deviceWidth, height: 40))
        let headertitleLabel = UILabel(frame: CGRect(x: 10, y: 5, width: deviceWidth - 10, height: 40))
        headertitleLabel.text = "RECENTLY USED"
        headertitleLabel.textColor = .lightGray
        headerView.addSubview(headertitleLabel)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        playRecording(at: indexPath.row)
        return
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            deleteRecording(at: indexPath.row)
        }
    }
}

//MARK: - Fetch Recordings

extension ShowRecordingController {
    private func fetchRecordings() {
        let records = persistenceManager.fetchContexts(Records.self)
        recordingViewModels = records.map({ return RecordingViewModel(records: $0 )})
        
        DispatchQueue.main.async {
            self.recordingTableView.reloadData()
        }
    }
}

//MARK: - Play Audio

extension ShowRecordingController {
    private func playRecording(at index: Int) {
        let selectedRecording = recordingViewModels[index]
        let directory = CommonHelper.sharedInstance.getDirectory()
        if let filepath = selectedRecording.recordingFilePath {
            let path = directory.appendingPathComponent(filepath)
            
            do {
                audioPlayer = try AVAudioPlayer.init(contentsOf: path)
                audioPlayer.play()
            } catch(let err) {
                print(err.localizedDescription)
            }
        }
    }
}

extension ShowRecordingController {
    private func deleteRecording(at index: Int) {
        let selectedRecording = recordingViewModels[index]
        guard let _recordId = selectedRecording.recordingId else { return }
        guard let _recordname = selectedRecording.recordingFilePath else { return }
        
        let _deleted = persistenceManager.deleteContext(Records.self, objectId: _recordId)
        let _deletefile = CommonHelper.sharedInstance.removeAudioFileFromManger(filename: _recordname)
        if _deleted && _deletefile {
            let indexpath = IndexPath(row: index, section: 0)
            recordingViewModels.remove(at: index)
            self.recordingTableView.deleteRows(at: [indexpath], with: .fade)
        }
        
    }
}

