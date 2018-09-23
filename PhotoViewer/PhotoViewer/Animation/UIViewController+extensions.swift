//
//  UIViewController+extensions.swift
//  PhotoViewer
//
//  Created by FAURE-VIDAL Laurene on 21/09/2018.
//  Copyright © 2018 FAURE-VIDAL Laurene. All rights reserved.
//

import UIKit

extension UIViewController {
    func topViewControllerIfNeeded() -> UIViewController {
        if let navVc = self as? UINavigationController {
            return navVc.viewControllers.last ?? self
        }
        return self
    }
}
