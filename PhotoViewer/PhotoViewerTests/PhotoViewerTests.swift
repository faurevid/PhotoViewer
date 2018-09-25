//
//  PhotoViewerTests.swift
//  PhotoViewerTests
//
//  Created by FAURE-VIDAL Laurene on 21/09/2018.
//  Copyright © 2018 FAURE-VIDAL Laurene. All rights reserved.
//

import XCTest
@testable import PhotoViewer

class PhotoViewerTests: XCTestCase {
    var firstView: PhotoViewerViewController!
    var navigationController: UINavigationController?
    var firstViewPresenter: PhotoViewerPresenter!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: PhotoViewerViewController = storyboard.instantiateViewController(withIdentifier: "FirstView") as! PhotoViewerViewController
        firstView = vc
        _ = firstView.view // To call viewDidLoad
        
        firstViewPresenter = PhotoViewerPresenter(view: firstView)
        
        navigationController = PhotoViewerNavigationController(rootViewController: firstView)
    }
    
    override func tearDown() {
        super.tearDown()
        firstViewPresenter = nil
        firstView = nil
        navigationController = nil
    }
    
    func testFetchPopular(){
        //Test with fetching a popular tag
        firstViewPresenter.fetchPhoto(fromSearch: "Cuisine", pagination: 1)
        sleep(5)
        XCTAssertTrue(firstViewPresenter.numberOfPhotos() > 0)
    }
    
}
