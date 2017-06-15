//
//  ViewController.swift
//  SwiftPhotoGallery
//
//  Created by Justin Vallely on 08/25/2015.
//  Copyright (c) 2015 Justin Vallely. All rights reserved.
//

import UIKit

class ViewController: PortraitOnlyViewController {

    let imageNames = ["image1.jpeg", "image2.jpeg", "image3.jpeg"]
    let imageTitles = ["Image 1", "Image 2", "Image 3"]

    var pageViewController: UIPageViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create page view controller
        guard let pageVC = storyboard?.instantiateViewController(withIdentifier: "PageViewController") as? UIPageViewController,
            let startingPageContentViewController = viewController(at: 0)
            else { return }

        let viewControllers: [UIViewController] = [startingPageContentViewController]

        pageViewController = pageVC
        pageViewController.dataSource = self
        pageViewController.setViewControllers(viewControllers, direction: .forward, animated: false, completion: { _ in })
        pageViewController.view.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(view.frame.size.width), height: CGFloat(view.frame.size.height - 30))
        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParentViewController: self)
    }

    func viewController(at index: Int) -> PageContentViewController? {
        if (imageTitles.count == 0) || (index >= imageTitles.count) {
            return nil
        }
        // Create a new view controller and pass suitable data.
        guard let pageContentViewController = storyboard?.instantiateViewController(withIdentifier: "PageContentViewController") as? PageContentViewController else { return nil }
        pageContentViewController.imageNames = imageNames
        pageContentViewController.imageFile = imageNames[index]
        pageContentViewController.titleText = imageTitles[index]
        pageContentViewController.pageIndex = index
        return pageContentViewController
    }
}


// MARK: UIPageViewControllerDataSource Methods
extension ViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let pageContentViewController = viewController as? PageContentViewController else { return nil }

        var index: Int = pageContentViewController.pageIndex
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        index -= 1
        return self.viewController(at: index)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let pageContentViewController = viewController as? PageContentViewController else { return nil }

        var index: Int = pageContentViewController.pageIndex
        if index == NSNotFound {
            return nil
        }
        index += 1
        if index == imageTitles.count {
            return nil
        }
        return self.viewController(at: index)
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return imageTitles.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
