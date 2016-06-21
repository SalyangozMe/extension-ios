//
//  TutorialContainerView.swift
//  Salyangoz
//
//  Created by Muhammed Said Özcan on 14/06/16.
//  Copyright © 2016 Tower Labs. All rights reserved.
//

import UIKit
import Foundation

class TutorialContainerView: UIViewController{
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    var tutorialPageViewController: TutorialPageViewController?{
        didSet{
            tutorialPageViewController?.tutorialDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.addTarget(self, action: #selector(TutorialContainerView.didChangePageControlValue), forControlEvents: .ValueChanged)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let tutorialPagerView = segue.destinationViewController as? TutorialPageViewController {
            self.tutorialPageViewController = tutorialPagerView
        }
    }
    @IBAction func goToNext(sender: AnyObject) {
        if pageControl.currentPage == pageControl.numberOfPages - 2{
            Wireframe.sharedWireframe.showLoginViewAsRootView()
        }else{
            tutorialPageViewController?.scrollToNextViewController()
        }
    }
    
    func didChangePageControlValue() {
        tutorialPageViewController?.scrollToViewController(index: pageControl.currentPage)
    }
}


extension TutorialContainerView: TutorialPageViewControllerDelegate {
    
    func tutorialPageViewController(tutorialPageViewController: TutorialPageViewController,
                                    didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }
    
    func tutorialPageViewController(tutorialPageViewController: TutorialPageViewController,
                                    didUpdatePageIndex index: Int) {
        if index == pageControl.numberOfPages - 1{
            Wireframe.sharedWireframe.showLoginViewAsRootView()
        }
        pageControl.currentPage = index
    }
    
}
