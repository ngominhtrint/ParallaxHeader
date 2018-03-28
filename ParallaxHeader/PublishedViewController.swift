//
//  PublishedViewController.swift
//  ParallaxHeader
//
//  Created by TriNgo on 3/26/18.
//  Copyright © 2018 TriNgo. All rights reserved.
//

import UIKit
import XLPagerTabStrip

protocol PublishedViewControllerDelegate: class {
    func scrollViewDidScroll(scrollView: UIScrollView, tableView: UITableView)
}

class PublishedViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var itemInfo = IndicatorInfo(title: "Published")
    weak var delegate: PublishedViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "NumberCell", bundle: nil), forCellReuseIdentifier: "NumberCellReuseIdentifier")
    }
}

extension PublishedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NumberCellReuseIdentifier", for: indexPath) as? NumberCell {
            cell.lbNumber.text = "\(indexPath.row)"
            return cell
        }
        return UITableViewCell()
    }
}

extension PublishedViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScroll(scrollView: scrollView, tableView: tableView)
    }
}

extension PublishedViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
