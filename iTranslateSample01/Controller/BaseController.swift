//
//  BaseController.swift
//  iTranslateSample01
//
//  Created by Anuradh Caldera on 10/19/19.
//  Copyright © 2019 iTranslate. All rights reserved.
//

import UIKit

class BaseController: UIViewController {
    
    let deviceWidth: CGFloat = UIScreen.main.bounds.width
    let deviceHeight: CGFloat = UIScreen.main.bounds.height
    let blueColor: UIColor = UIColor.init(red: 26/255, green: 152/255, blue: 255/255, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setUpNavigationBar()
    }
}

//MARK: - Setup Navigation Bar

extension BaseController {
    private func setUpNavigationBar() {
        self.navigationController?.navigationBar.barTintColor = blueColor
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18)!]
    }
}

//MARK: - Hide/Show Navigation Bar in Specific View Controller

extension BaseController {
    func hideNavigationBar(_animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: _animated)
    }
    
    func showNavigationBar(_animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: _animated)
    }
}

//MARK: - Hide Back Button Title

extension BaseController {
    func hideBackButton() {
        self.navigationItem.hidesBackButton = true
    }
}

