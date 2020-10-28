//
//  WhiteNavigationController.swift
//  RandomUser
//
//  Created by anny on 2020/10/23.
//  Copyright © 2020 anny. All rights reserved.
//

import UIKit

class WhiteNavigationController: UINavigationController {
    
    // 狀態列變成白色
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
