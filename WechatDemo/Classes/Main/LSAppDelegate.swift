//
//  AppDelegate.swift
//  WechatDemo
//
//  Created by linshengqi on 2018/6/9.
//  Copyright © 2018年 linshengqi. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class LSAppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        let tabBarVc = LSTabBarController()
        self.window = UIWindow()
        self.window?.frame  = UIScreen.main.bounds
        self.window?.rootViewController = tabBarVc
        self.window?.makeKeyAndVisible()
        
        viewControllers(tabBarVc)
        customizeInterface()
        setupNotification(application)
        return true
    }
    
    
    func viewControllers(_ tabbarVC: UITabBarController) {
        let chat = LSNavigationController(rootViewController: LSChatListController())
        let contact = LSNavigationController(rootViewController: LSContactListController())
        let discovery = LSNavigationController(rootViewController: LSDiscoveryController(style: .grouped))
        let me =   LSNavigationController(rootViewController: LSMeController(style: .grouped))
        
        tabbarControllerAddChildVc(tabbraVC: tabbarVC, childVC: chat, normalImage: "tabbar_mainframe", selectedImage: "tabbar_mainframeHL", title: "微信")
        tabbarControllerAddChildVc(tabbraVC: tabbarVC, childVC: contact, normalImage: "tabbar_contacts", selectedImage: "tabbar_contactsHL", title: "通讯录")
        tabbarControllerAddChildVc(tabbraVC: tabbarVC, childVC: discovery, normalImage: "tabbar_discover", selectedImage: "tabbar_discoverHL", title: "发现")
        tabbarControllerAddChildVc(tabbraVC: tabbarVC, childVC: me, normalImage: "tabbar_me", selectedImage: "tabbar_meHL", title: "我")

    }
    
    func customizeInterface()  {
        UITabBar.appearance().backgroundColor = UIColor.white
        
        var selectedAttrs = Dictionary<NSAttributedStringKey, UIColor>()
        selectedAttrs[NSAttributedStringKey.foregroundColor] = RGB(r: 26,g: 178,b: 10)
        
        let tabBar = UITabBarItem.appearance()
        tabBar.setTitleTextAttributes(selectedAttrs, for: .selected)
        
        
        UIApplication.shared.statusBarStyle = .lightContent;
        let navBar = UINavigationBar.appearance()
        navBar.tintColor = UIColor.white
        navBar.barTintColor = RGBA(r: 0.1, g: 0.1, b: 0.1, a: 0.65)
        var titleAttrs = Dictionary<NSAttributedStringKey, UIColor>()
        titleAttrs[NSAttributedStringKey.foregroundColor] = UIColor.white
        navBar.titleTextAttributes = titleAttrs
        
    }
    
    
    func tabbarControllerAddChildVc(tabbraVC: UITabBarController, childVC: UIViewController, normalImage: String, selectedImage: String, title: String) {
        childVC.title = title
        childVC.tabBarItem.image = UIImage(named: normalImage)?.withRenderingMode(.alwaysOriginal)
        childVC.tabBarItem.selectedImage = UIImage(named: selectedImage)?.withRenderingMode(.alwaysOriginal)
        tabbraVC.addChildViewController(childVC)
    }
    
    
    func setupNotification(_ application: UIApplication)  {

        let iOS8 = 8.0
        if iosVersion >= iOS8 {
            let setting = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            application.registerUserNotificationSettings(setting)
        }
    }
    
    
}

