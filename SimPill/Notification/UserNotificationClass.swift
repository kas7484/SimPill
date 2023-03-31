//
//  UserNotificationClass.swift
//  SimPill
//


import UIKit
import UserNotifications

class UserNotificationClass: UIViewController
{

    func scheduleNotification(at date: Date)
    {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: .current, from: date)
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
        
        let content = UNMutableNotificationContent()
        //content.title = tfTitle.text!
        //content.body = tfMessage.text!
       content.sound = UNNotificationSound.default()
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
        let request = UNNotificationRequest(identifier: "textNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request)
        {
            (error) in
            if let error = error {
                print("Uh oh! We had an error: \(error)")
            }
        }
    }
   
    
    func getStringFromDate(date:Date) -> String{
        let formatter = DateFormatter()
        //formatter.dateFormat = "yyyy/MM/dd"
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter.string(from:date)
    };
    
    
    /*let alert =  UIAlertController(title: "Sim Pill", message: "view or take medicine!", preferredStyle: .alert)
     let view = UIAlertAction(title: "View Medicine", style: .default) { (alert) in
     let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewMedicineDetails")as! ViewMedicineDetails
     
     storyboard.Medicine = [self.Medicine[indexPath.row]]
     self.present(storyboard, animated: true, completion: nil)
     }
     let take = UIAlertAction(title: "Take Medicine", style: .default) { (alert) in
     
     let cell = YourPillsForTodayCell()
     if cell.flagImage.image ==  UIImage(named: "NoDate"){
     cell.flagImage.image = UIImage(named: "Yes")
     self.medicineTableView.reloadData()
     }else {
     cell.flagImage.image = UIImage(named: "No")
     self.medicineTableView.reloadData()
     }
     }
     
     alert.addAction(view)
     alert.addAction(take)
     self.present(alert, animated: true, completion: nil)*/
    
    
    
    /*func timedNotifications(inSeconds: TimeInterval, completion: @escaping (_ Success: Bool) -> ())
    {
        //setUpNoticationSchedule()
        let content = UNMutableNotificationContent()
        
        if medicineData.count > 0
        {
            //let notification  = medicineData[0]
            for notification  in medicineData
            {
                content.title = notification.mTitle!
                content.subtitle = notification.mType!
                content.body = notification.mDescription!
                
                let date = Date(timeIntervalSinceNow: 3600)
                
                let yourDate: Date? = formatter.date(from: notification.mDate!)
                
                
                
                
                let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: yourDate!)
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                //
                //                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: inSeconds, repeats: false)
                let request = UNNotificationRequest(identifier: "customNotification", content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request)
                {   (error) in
                    if error != nil
                    {
                        completion(false)
                    }else
                    {
                        completion(true)
                    }
                }
            }
            
            
            
        }
        else
        {
            print("no record found")
        }
        
    }*/
    
    
    
    
    func setUpNoticationSchedule()
    {
       /* let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do
        {
            let fetchRequest: NSFetchRequest <MedicineRecord> = MedicineRecord.fetchRequest()
            print("selected date = \(selectedDate)")
            
            let noticationDate = //medicineData[0].mDate
            let notificationTime = medicineData[0].mTime
            
            fetchRequest.predicate = NSPredicate(format: "mDate == %@", noticationDate!)
            print("FETCH_REQUEST\(fetchRequest)")
            
            try medicineData = context.fetch(fetchRequest)
        }
        catch
        {
            print("Error Message :-\(error)")
        }*/
    }
    
    
    
}
