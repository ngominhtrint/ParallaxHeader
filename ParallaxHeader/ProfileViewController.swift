//
//  ProfileViewController.swift
//  ParallaxHeader
//
//  Created by TriNgo on 3/26/18.
//  Copyright © 2018 TriNgo. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ProfileViewController: ButtonBarPagerTabStripViewController {

    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var barView: ButtonBarView!
    
    let blue: UIColor = UIColor(red: 35/255, green: 133/255, blue: 192/255, alpha: 1)
    
    var goingUp: Bool?
    var childScrollingDownDueToParent = false
    
    override func viewDidLoad() {
        setupView()
        super.viewDidLoad()
    }

    private func setupView() {
        containerHeightConstraint.constant = UIScreen.main.bounds.height - 3 * barView.bounds.height
        
        settings.style.buttonBarBackgroundColor = .clear
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.selectedBarBackgroundColor = blue
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 1.0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .lightGray
            newCell?.label.textColor = self.blue
        }
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let publishedViewController = storyboard.instantiateViewController(withIdentifier: "PublishedViewController") as! PublishedViewController
        publishedViewController.itemInfo = IndicatorInfo(title: "PUBLISHED")
        publishedViewController.delegate = self
        
        let taggedViewController = storyboard.instantiateViewController(withIdentifier: "TaggedViewController") as! TaggedViewController
        taggedViewController.itemInfo = IndicatorInfo(title: "TAGGED")
        
        let savedViewController = storyboard.instantiateViewController(withIdentifier: "SavedViewController") as! SavedViewController
        savedViewController.itemInfo = IndicatorInfo(title: "SAVED")
        savedViewController.delegate = self
        
        return [publishedViewController, taggedViewController, savedViewController]
    }
}

extension ProfileViewController: PublishedViewControllerDelegate, SavedViewControllerDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView, tableView: UITableView) {
        goingUp = scrollView.panGestureRecognizer.translation(in: scrollView).y < 0
        
        let parentViewMaxContentYOffset = self.scrollView.contentSize.height - self.scrollView.frame.height
        
        if goingUp! {
            if scrollView == tableView {
                if self.scrollView.contentOffset.y < parentViewMaxContentYOffset && !childScrollingDownDueToParent {
                    self.scrollView.contentOffset.y = max(min(self.scrollView.contentOffset.y + tableView.contentOffset.y, parentViewMaxContentYOffset), 0)
                    tableView.contentOffset.y = 0
                }
            }
        } else {
            if scrollView == tableView {
                if tableView.contentOffset.y < 0 && self.scrollView.contentOffset.y > 0 {
                    self.scrollView.contentOffset.y = max(self.scrollView.contentOffset.y - abs(tableView.contentOffset.y), 0)
                }
            }
            if scrollView == self.scrollView {
                if tableView.contentOffset.y > 0 && self.scrollView.contentOffset.y < parentViewMaxContentYOffset {
                    childScrollingDownDueToParent = true
                    tableView.contentOffset.y = max(tableView.contentOffset.y - (parentViewMaxContentYOffset - self.scrollView.contentOffset.y), 0)
                    self.scrollView.contentOffset.y = parentViewMaxContentYOffset
                    childScrollingDownDueToParent = false
                }
            }
        }
    }
}
