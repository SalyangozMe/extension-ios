//
//  TutorialPageViewController.swift
//  UIPageViewController Post
//
//  Created by Jeffrey Burt on 12/11/15.
//  Copyright © 2015 Atomic Object. All rights reserved.
//

import UIKit
import SalyangozKit

class TutorialPageViewController: UIPageViewController {
    weak var tutorialDelegate: TutorialPageViewControllerDelegate?
    var tutorialViews: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        if let tutorialViewItems: [TutorialStruct] = DataManager.sharedManager.getTutorials(){
            for item in tutorialViewItems{
                let tutorialView = self.newTutorialViewController(item)
                tutorialViews.append(tutorialView)
            }
            
            let loginView = UIStoryboard.mainStoryboard().instantiateViewControllerWithIdentifier(String(LoginView))
            tutorialViews.append(loginView)
        }
        
        if let initialViewController = tutorialViews.first {
            scrollToViewController(initialViewController)
        }
        
        tutorialDelegate?.tutorialPageViewController(self, didUpdatePageCount: tutorialViews.count)
    }
    
    /**
     Scrolls to the next view controller.
     */
    func scrollToNextViewController() {
        if let visibleViewController = viewControllers?.first,
            let nextViewController = pageViewController(self, viewControllerAfterViewController: visibleViewController) {
            scrollToViewController(nextViewController)
        }
    }
    
    /**
     Scrolls to the view controller at the given index. Automatically calculates
     the direction.
     
     - parameter newIndex: the new index to scroll to
     */
    func scrollToViewController(index newIndex: Int) {
        let nextViewController = tutorialViews[newIndex]
        scrollToViewController(nextViewController, direction: .Forward)
    }
    
    private func newTutorialViewController(item: TutorialStruct) -> TutorialView {
        let tutorialView = UIStoryboard.mainStoryboard().instantiateViewControllerWithIdentifier(String(TutorialView)) as! TutorialView
        tutorialView.item = item
        return tutorialView
    }
    
    /**
     Scrolls to the given 'viewController' page.
     
     - parameter viewController: the view controller to show.
     */
    private func scrollToViewController(viewController: UIViewController,
                                        direction: UIPageViewControllerNavigationDirection = .Forward) {
        setViewControllers([viewController],
                           direction: direction,
                           animated: true,
                           completion: { (finished) -> Void in
                            // Setting the view controller programmatically does not fire
                            // any delegate methods, so we have to manually notify the
                            // 'tutorialDelegate' of the new index.
                            self.notifyTutorialDelegateOfNewIndex()
        })
    }
    
    /**
     Notifies '_tutorialDelegate' that the current page index was updated.
     */
    private func notifyTutorialDelegateOfNewIndex() {
        if let firstViewController = viewControllers?.first,
            let index = tutorialViews.indexOf(firstViewController) {
            tutorialDelegate?.tutorialPageViewController(self,
                                                         didUpdatePageIndex: index)
        }
    }
    
}

// MARK: UIPageViewControllerDataSource

extension TutorialPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController,
                            viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = tutorialViews.indexOf(viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        return tutorialViews[previousIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController,
                            viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = tutorialViews.indexOf(viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = tutorialViews.count
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return tutorialViews[nextIndex]
    }
    
}

extension TutorialPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                                               previousViewControllers: [UIViewController],
                                               transitionCompleted completed: Bool) {
        notifyTutorialDelegateOfNewIndex()
    }
    
}

protocol TutorialPageViewControllerDelegate: class {
    
    /**
     Called when the number of pages is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter count: the total number of pages.
     */
    func tutorialPageViewController(tutorialPageViewController: TutorialPageViewController,
                                    didUpdatePageCount count: Int)
    
    /**
     Called when the current index is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter index: the index of the currently visible page.
     */
    func tutorialPageViewController(tutorialPageViewController: TutorialPageViewController,
                                    didUpdatePageIndex index: Int)
    
}
