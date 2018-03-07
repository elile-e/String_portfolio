
//
//  AppDelegate.swift
//  st_ring
//
//  Created by EuiSuk_Lee on 2017. 8. 28..
//  Copyright © 2017년 EuiSuk_Lee. All rights reserved.
//

import UIKit
import CoreData
import FBSDKCoreKit
import UserNotifications
import Firebase
import SwiftyJSON
import Alamofire
import Fabric
import Crashlytics
import AdSupport
import FacebookLogin

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var rootViewController =  UIViewController()
    let gcmMessageIDKey = "209742933285"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //TOKEN RESET
        if KOSession.shared().isOpen() {
            let kakaotoken = KOSession.shared().accessToken!
            UserDefaults.standard.set(kakaotoken, forKey: "token")
            UserDefaults.standard.synchronize()
        }
        if let i = FBSDKAccessToken.current() {
            UserDefaults.standard.set(i.tokenString, forKey: "token")
            UserDefaults.standard.synchronize()
        }
        
        //시작 뷰컨트롤러 셋팅
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        if UserDefaults.standard.object(forKey: "id") == nil {
            let storyboard = UIStoryboard(name: "STAccountStoryboard", bundle: nil)
            let rootView = storyboard.instantiateViewController(withIdentifier: "STStartViewController")
            rootViewController = UINavigationController(rootViewController: rootView) as UIViewController
        } else {
            self.checkStatus()
        }
        
        self.window?.rootViewController = rootViewController
        self.window?.makeKeyAndVisible()
        
        //기본 UI view 관련 셋팅 (네비바 쉐도우, statusbar, font etc...)
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().backgroundColor = .white
        UINavigationBar.appearance().isTranslucent = false

        let Tabbarattribute:[NSAttributedStringKey:UIFont] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): UIFont(name: "NanumSquare", size: 8)!]
        UITabBarItem.appearance().setTitleTextAttributes(Tabbarattribute, for: .normal)
        
        let Navibarattribute:[NSAttributedStringKey:UIFont] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): UIFont(name: "NanumSquare", size: 15)!]
        UINavigationBar.appearance().titleTextAttributes = Navibarattribute
        
        
        //firebase set
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self as? MessagingDelegate
        // [END set_messaging_delegate]
        // Register for remote notifications. This shows a permission dialog on first run, to
        // show the dialog at a more appropriate time move this registration accordingly.
        // [START register_for_notifications]
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        if let token = Messaging.messaging().fcmToken {
            print("FCM token: \(token )")
            UserDefaults.standard.set(token, forKey: "fcm_token")
            UserDefaults.standard.synchronize()
        }
        
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(tokenRefreshNotification(notification:)),
                                                         name: NSNotification.Name.InstanceIDTokenRefresh,
                                                         object: nil)
        
        //FACEBOOK SET
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        //KAKAOKTALK SET
        KOSession.shared().isAutomaticPeriodicRefresh = true
        
        //Fabric
        Fabric.with([Crashlytics.self])
        
        //Adbrix
        if (NSClassFromString("ASIdentifierManager") != nil) {
            let ifa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            let isAppleAdvertisingTrackingEnalbed = ASIdentifierManager.shared().isAdvertisingTrackingEnabled
            
            print("Igaworks get uuid : " + ifa)
            
            IgaworksCore.setAppleAdvertisingIdentifier(ifa, isAppleAdvertisingTrackingEnabled: isAppleAdvertisingTrackingEnalbed)
        }
        
        IgaworksCore.igaworksCore(withAppKey: "144282290", andHashKey: "589698743ea045f2")
        IgaworksCore.setLogLevel(IgaworksCoreLogDebug)
        
        
        
        
        Thread.sleep(forTimeInterval: 1.0)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        //KAKAOTalk SET
        KOSession.handleDidEnterBackground()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        KOSession.handleDidBecomeActive()
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken as Data
        Messaging.messaging().shouldEstablishDirectChannel = true
        
        if let token = Messaging.messaging().fcmToken {
            print("FCM token: \(token)")
            UserDefaults.standard.set(token, forKey: "fcm_token")
            UserDefaults.standard.synchronize()
        }
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "st_ring")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if KOSession.isKakaoAccountLoginCallback(url){
            return KOSession.handleOpen(url)
        }
        
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [String : AnyObject] = [:])-> Bool {
        if KOSession.isKakaoAccountLoginCallback(url){
            return KOSession.handleOpen(url)
        }
        
        return true

    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        NotificationCenter.default.post(name: .fcmMessageNoti ,object: nil)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        // Let FCM know about the message for analytics etc.
        Messaging.messaging().appDidReceiveMessage(userInfo)
        // handle your message
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        if let token = Messaging.messaging().fcmToken {
            print("FCM token: \(token )")
            UserDefaults.standard.set(token, forKey: "fcm_token")
            UserDefaults.standard.synchronize()
        }
    }
    
    @objc func tokenRefreshNotification(notification: NSNotification) {
        // NOTE: It can be nil here
        if let token = Messaging.messaging().fcmToken {
            print("FCM token: \(token )")
            UserDefaults.standard.set(token, forKey: "fcm_token")
            UserDefaults.standard.synchronize()
        }
    }
    
    func checkStatus() {
        let sex = UserDefaults.standard.string(forKey: "sex")
        let id = UserDefaults.standard.string(forKey: "id")
        var initialViewController = UIViewController()
        
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "access-token" : UserDefaults.standard.string(forKey: "token")!,
            "account-id" : id!,
            "account-sex" : sex!
        ]
        let url = String.domain! + "information/\(String(describing: sex!))/\(String(describing: id!))/get/status/"
        
        
        Alamofire.request(url, method: HTTPMethod.get, encoding: JSONEncoding.default, headers: headers).responseJSON{ (response) in
            switch response.result {
            case .success:
                print("Validation Successful")
                let jsonValue = JSON(response.result.value)
                print(jsonValue)
                let status = jsonValue["status"].stringValue
                UserDefaults.standard.set(status, forKey: "status")
                
                switch status{
                case "ACTIVATE", "EDITING":
                    let storyboard = UIStoryboard(name: "STMainStoryboard", bundle: nil)
                    let rootView = storyboard.instantiateViewController(withIdentifier: "STMainTabBarController")
                    initialViewController = UINavigationController(rootViewController: rootView)
                case "BEFOREJOIN":
                    let storyboard = UIStoryboard(name: "STAccountStoryboard", bundle: nil)
                    let rootView = storyboard.instantiateViewController(withIdentifier: "STStartViewController")
                    initialViewController = UINavigationController(rootViewController: rootView)
                case "INREVIEW":
                    let storyboard = UIStoryboard(name: "STAccountStoryboard", bundle: nil)
                    initialViewController = storyboard.instantiateViewController(withIdentifier: "STWaitingReviewViewController")
                case "REJECTED":
                    let storyboard = UIStoryboard(name: "STAccountStoryboard", bundle: nil)
                    initialViewController = storyboard.instantiateViewController(withIdentifier: "STRejectReviewViewController")
                default:
                    self.checkStatus()
                }
                
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
            case .failure(let error):
                print(error)
                
                break
            }
        }
    }
}
