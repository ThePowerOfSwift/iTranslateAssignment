//
//  CommonHelper.swift
//  iTranslateSample01
//
//  Created by Anuradh Caldera on 10/20/19.
//  Copyright © 2019 iTranslate. All rights reserved.
//

import Foundation

struct CommonHelper {
    
    static let sharedInstance = CommonHelper()
    
    private init() { }
}

//MARK: - Get Directory

extension CommonHelper {
    func getDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = path[0]
        return documentDirectory
    }
}

//MARK: - Genrate Random UUID

extension CommonHelper {
    func getRandomGUID() -> String {
        return UUID().uuidString
    }
}

//MARK: - Remove file from manager

extension CommonHelper {
    func removeAudioFileFromManger(filename: String) -> Bool {
        let directory = getDirectory()
        
        do {
            let path = directory.appendingPathComponent(filename)
            try FileManager.default.removeItem(at: path)
            return true
        } catch(let err) {
            print(err.localizedDescription)
            return false
        }
    }
}
