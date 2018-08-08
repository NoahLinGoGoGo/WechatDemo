//
//  LSSearchResultViewController.swift
//  WechatDemo
//
//  Created by linshengqi on 2018/6/14.
//  Copyright © 2018年 linshengqi. All rights reserved.
//

import UIKit

class LSSearchResultViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
      
        UIApplication.shared.statusBarStyle = .default;
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        UIApplication.shared.statusBarStyle = .lightContent;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
