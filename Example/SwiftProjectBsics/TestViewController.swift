//
//  TestViewController.swift
//  SwiftProjectBsics_Example
//
//  Created by Tao on 2018/7/1.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import SwiftProjectBsics

class TestViewController: UIViewController {

   // @IBOutlet weak var testTableView: HttpTableView!
    
    let httpPresenter :LoginPresenter = LoginPresenter()
    
    
    let testView = TestView(frame: CGRect(x: 10, y: 80, width: 100, height: 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  testTableView.
        // Do any additional setup after loading the view.
        
      //  let model : ObjectModel? = modelWithJSON(data: ["":""])
        
        self.view.addSubview(testView)

    }
    
    @IBAction func testAction(_ sender: Any) {
        self.testView.removeFromSuperview()
    }
    
    
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.httpPresenter.login()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}


class TestTableViewCell : UITableViewCell {
    
}
