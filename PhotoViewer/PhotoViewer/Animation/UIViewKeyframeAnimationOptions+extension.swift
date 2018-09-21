//
//  UIViewKeyframeAnimationOptions+extension.swift
//  PhotoViewer
//
//  Created by FAURE-VIDAL Laurene (Prestataire)  [IT-CE] on 21/09/2018.
//  Copyright © 2018 FAURE-VIDAL Laurene. All rights reserved.
//

import UIKit
extension UIViewKeyframeAnimationOptions {
    static var curveEaseIn: UIViewKeyframeAnimationOptions { get { return UIViewKeyframeAnimationOptions(rawValue: UIViewAnimationOptions.curveEaseIn.rawValue) } }
    static var curveEaseOut: UIViewKeyframeAnimationOptions { get { return UIViewKeyframeAnimationOptions(rawValue: UIViewAnimationOptions.curveEaseOut.rawValue) } }
}
