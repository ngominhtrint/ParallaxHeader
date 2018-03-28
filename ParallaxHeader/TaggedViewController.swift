//
//  TaggedViewController.swift
//  ParallaxHeader
//
//  Created by TriNgo on 3/26/18.
//  Copyright © 2018 TriNgo. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class TaggedViewController: UIViewController {

    var itemInfo = IndicatorInfo(title: "Tagged")
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension TaggedViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
