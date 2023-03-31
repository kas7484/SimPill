//
//  AppDelegate.swift
//  SimPill


import UIKit
import CoreData
import UserNotifications
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{

    var window: UIWindow?
    var medicineDetails = [MedicineRecord]()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.sharedManager().enable = true
        
        fetchNotification()
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound]){ (success, error) in
            if error != nil {
                print("Authorization Unsuccessfull")
            }else {
                print("Authorization Successfull")
            }
        }
        
        let action = UNNotificationAction(identifier: "myNotification", title: "Take a Medicine", options: [])
        let category = UNNotificationCategory(identifier: "myNoti", actions: [action], intentIdentifiers: [], options: [])
         UNUserNotificationCenter.current().setNotificationCategories([category])
        return true
    }

    func scheduleNotification(at date: Date)
    {
        fetchNotification()
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: .current, from: date)
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
        
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = "myNoti"
        
        
        if medicineDetails.count > 0
        {
            for notification in medicineDetails{
                content.title = notification.mTitle!
                content.subtitle = notification.mType!
                content.body = notification.mDescription!
                content.sound = UNNotificationSound.default()
            }
            let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: true)
            let request = UNNotificationRequest(identifier: "myNotification", content: content, trigger: trigger)
            
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request)
            {
            (error) in
                if let error = error {
                    print("Uh oh! We had an error: \(error)")
                }
            }
        }
        else{
            print("no record found")
        }
        
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: {requests -> () in
            print("\(requests.count) requests -------")
            for request in requests{
                print(request.identifier)
            }})
        UNUserNotificationCenter.current().getDeliveredNotifications(completionHandler: {notification -> () in
            print("\(notification.count) Delivered notifications-------")
            for notification in notification{
                print(notification.request.identifier)
            }})
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SimPill")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
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
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    
    //geting the data for notification
    func fetchNotification()
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            try medicineDetails = context.fetch(MedicineRecord.fetchRequest())
        }
        catch{
            print("Error Fetching Database :-\(error)")
        }
    }
}
//for the notifiation permitions  when user allow the notification then it will be fire
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
}


