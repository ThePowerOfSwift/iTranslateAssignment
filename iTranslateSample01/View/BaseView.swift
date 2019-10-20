//
//  BaseView.swift
//  iTranslateSample01
//
//  Created by Anuradh Caldera on 10/19/19.
//  Copyright © 2019 iTranslate. All rights reserved.
//

import UIKit

class BaseView: UIView {
    let deviceWidth: CGFloat = UIScreen.main.bounds.width
    let deviceHeight: CGFloat = UIScreen.main.bounds.height
    let deviceIdom: UIUserInterfaceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
    let blueColor: UIColor = UIColor.init(red: 26/255, green: 152/255, blue: 255/255, alpha: 1)

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
