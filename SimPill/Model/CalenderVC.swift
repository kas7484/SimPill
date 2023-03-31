//
//  CalenderVC.swift
//  SimPill


import UIKit
import FSCalendar
import CoreGraphics
import UserNotifications
import CoreData

class CalenderVC: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet var calender: FSCalendar!
    //var selectedDate = String()
   
    @IBOutlet var medicineTableView: UITableView!
    var presentDatesArray = String()
    var absentDatesArray  = [String]()
    var medicineData = [MedicineRecord]()
    var item: [String] = []
    let text = "data share : "
    var strFileContent = String()
    var shareData = ""
   
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        getData()
        medicineTableView.reloadData()
        
        if medicineData.count > 0{
            
        }
        else{
            medicineTableView.isHidden = true
        }
        
        self.medicineTableView.tableFooterView = UIView()
        self.medicineTableView.layer.cornerRadius = 10.0
        self.calender.layer.cornerRadius = 10.0
        
        //presentDatesArray = ["2018-02-20","2018-02-21","2018-02-12","2018-02-25"]
        //absentDatesArray = ["2018-02-10","2018-02-28","2018-02-31","2018-02-22"]

        
        calender.scrollDirection = .horizontal
        calender.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesUpperCase]
        
        let today = Date()
        calender.today = today
        calender.currentPage = today
        calender.delegate = self
        calender.dataSource = self
        
        
        calender.appearance.headerMinimumDissolvedAlpha = 0.0
        calender.appearance.todayColor = UIColor.clear
        calender.appearance.titleTodayColor = calender.appearance.titleDefaultColor;
        calender.appearance.subtitleTodayColor = calender.appearance.subtitleDefaultColor;
        
        //for the give the permition to allow the notification
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound])
        { (success, error) in
            
            if error != nil {
                print("Authorization Unsuccessfull")
            }else {
                print("Authorization Successfull")
            }
        }
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor?
    {
        
        if medicineData.count > 0
        {
            for i in 0...medicineData.count
            {
                let condition = medicineData[i].flag 
                let strDate = medicineData[i].mDate
                
                if condition == true{
                    presentDatesArray = strDate!
                }
                else{
                    presentDatesArray = strDate!
                }
            }
        }
        
        
        let formatter: String = DateFormatter.stringFrom(date: date)
         if presentDatesArray.contains(formatter)
         {
            return UIColor.green
            //let img = UIImage(named: "GreenDate")
         }
         else if absentDatesArray.contains(formatter)
         {
            return UIColor.red
            // return UIImage(named: "RedDate")
         }
         else
         {
            return nil
         }
       
    }
   
    
    
    
   /* func calendar(_ calendar: FSCalendar!, appearance: FSCalendarAppearance!, titleDefaultColorFor date: Date!) -> UIColor!
    {
        //let dateString: String = calender.f(date, format: "yyyy-MM-dd")
        /*let formatter: String = DateFormatter.stringFrom(date: date)
        if presentDatesArray.contains(formatter){
            return UIColor.green
            //let img = UIImage(named: "GreenDate")
        }
        else if absentDatesArray.contains(formatter){
            return UIColor.red
           // return UIImage(named: "RedDate")
        }
        else{return nil
        }*/
        return nil
    }*/

    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        //formatter.dateFormat = "yyyy/MM/dd"
        //formatter.dateFormat = "MMM dd, yyyy"
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter
    }()
    
    func getStringFromDate(date:Date) -> String{
        let formatter = DateFormatter()
        //formatter.dateFormat = "yyyy/MM/dd"
        formatter.dateFormat = "MMM dd, yyyy h:mma"
        return formatter.string(from:date)
    };
   
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition){
        self.formatter.string(from: date)
        let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "YourPillForTodayVC")as! YourPillForTodayVC
        
        let formatDate = formatter.string(from: date)
        storyboard.selectedDate = formatDate
        print("did select : = \(formatDate)")
        //self.present(storyboard, animated: true, completion: nil)
        navigationController?.pushViewController(storyboard, animated: true)
    }
    
    
    @IBAction func btnAddMedicine(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddMedicineVC")as! AddMedicineVC
        storyboard.isEdit = false
        navigationController?.pushViewController(storyboard, animated: true)
    }
    
    @IBAction func btnShareAct(_ sender: UIBarButtonItem)
    {
        // get the documents folder url
        let documentDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        // create the destination url for the text file to be saved
        
       
        let fileURL = documentDirectory.appendingPathComponent("MedicineDetails.pdf")
         print("DOC_URL \(fileURL.absoluteString)")
        
        for shardata in medicineData{
            //let shareDate = shardata.mTitle! + "\n" + shardata.mDate! + "\n" + shardata.mTime! + "\n"

            strFileContent.append(shardata.mTitle! + "," + shardata.mDate! + "," + shardata.mTime! + "," + shardata.mType! + "," + shardata.mStrength! + "," + shardata.mDescription! + "," + shardata.mFood! + "," + shardata.mSchedule! + "," + "\n")
        }
        
        //print("File Content : \(strFileContent)")
        
        do {
            // writing to disk
            try strFileContent.write(to: fileURL, atomically: false, encoding: .utf8)
            
            // saving was successful. any code posterior code goes here
            // reading from disk
            do {
                let mytext = try String(contentsOf: fileURL)
                print(strFileContent)   // "some text\n"
            } catch {
                print("error loading contents of:", fileURL, error)
            }
        } catch {
            print("error writing to url:", fileURL, error)
        }
       
        let imageToShare = [ strFileContent ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func getData()
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            try medicineData = context.fetch(MedicineRecord.fetchRequest())
        }
        catch
    {
            print("Error Message :-\(error)")
        }
    }
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicineData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")as! CalenderCell
        if medicineData.count > 0
        {
            cell.mDate.text = medicineData[indexPath.row].mDate
            cell.mTitle.text = medicineData[indexPath.row].mTitle
            cell.mTime.text = medicineData[indexPath.row].mDescription
            cell.mTime.text = medicineData[indexPath.row].mTime
        }
        else
        {
            medicineTableView.isHidden =  true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.medicineTableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewMedicineDetails")as! ViewMedicineDetails
        
        storyboard.Medicine = [medicineData[indexPath.row]]
        //self.present(storyboard, animated: true, completion: nil)
        navigationController?.pushViewController(storyboard, animated: true)
    }
    
    /*func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
         if editingStyle == .delete
         {
            let delete = UIAlertController(title: "Sim Pill", message: "Are you want to sure to delete!", preferredStyle: .alert)
            let deleteAct = UIAlertAction(title: "Delete", style: .default, handler:{ (alert) in
         
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                let data = self.medicineData[indexPath.row]
                context.delete(data)
    
                do
                {try context.save()
                }
                catch
                {print(error)
                }
                self.medicineTableView.reloadData()
                self.viewDidLoad()
         })
         let cancelAct = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
         delete.addAction(deleteAct)
         delete.addAction(cancelAct)
         self.present(delete, animated: true, completion: nil)
         }
    }*/
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        let takeAct = UITableViewRowAction(style: .default, title: "Take")
        { (take, indexPath) in
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            let medicineRecord = self.medicineData[indexPath.row] as MedicineRecord
            medicineRecord.flag = true
            do {
                try managedContext.save()
                self.navigationController?.popViewController(animated: true)
            } catch let error as NSError {
                print("Error while trying to save medicine",error)
            }
            
        }
        let UnTakeAct = UITableViewRowAction(style: .default, title: "UnTake") { (UnTakeAct, indexPath) in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            let medicineRecord = self.medicineData[indexPath.row] as MedicineRecord
            medicineRecord.flag = false
            medicineRecord.mId = self.medicineData[indexPath.row].mId
        
            do {
                try managedContext.save()
                self.navigationController?.popViewController(animated: true)
            } catch let error as NSError {
                print("Error while trying to save medicine",error)
            }
        }
        let deleteAct = UITableViewRowAction(style: .default, title: "Delete"){ (deleteAct, indexPath) in
            
            let delete = UIAlertController(title: "Sim Pill", message: "Are you want to sure to delete!", preferredStyle: .alert)
            let deleteAct = UIAlertAction(title: "Delete", style: .default, handler:{ (alert) in
                
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                let data = self.medicineData[indexPath.row]
                context.delete(data)
                
                do
                {try context.save()
                }
                catch
                {print(error)
                }
                self.medicineTableView.reloadData()
                self.viewDidLoad()
            })
            let cancelAct = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            delete.addAction(deleteAct)
            delete.addAction(cancelAct)
            self.present(delete, animated: true, completion: nil)
        }
        
        takeAct.backgroundColor = UIColor.green
        UnTakeAct.backgroundColor = UIColor.lightGray
        deleteAct.backgroundColor  = UIColor.red
        return [takeAct,UnTakeAct,deleteAct]
    }
}


