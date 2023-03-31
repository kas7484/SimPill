//
//  YourPillForTodayVC.swift
//  SimPill
//


import UIKit
import FSCalendar
import CoreGraphics
import CoreData

class YourPillForTodayVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    @IBOutlet var medicineTableView: UITableView!
    //core database
    var Medicine = [MedicineRecord]()
    var selectedDate = String()
    var index:Int = 0
    override func viewDidLoad()
    {
        super.viewDidLoad()
        medicineTableView.tableFooterView = UIView()
        medicineTableView.reloadData()
        getData()
   
        print("selectedDate : = \(selectedDate)")
        
        
        //for the no record found
        if Medicine.count > 0
        {
        }
        else
        {
            noMedicineFound()
            print("No record found")
        }
    }
    
    func noMedicineFound() {
        let childViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NoRecordFound")
        self.addChildViewController(childViewController)
        
        self.view.addSubview(childViewController.view)
        childViewController.didMove(toParentViewController: self)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 174
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
       return Medicine.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")as! YourPillsForTodayCell
        
        if Medicine.count > 0
        {
            print("ID \(String(describing: Medicine[indexPath.row].mId))")
            cell.mTitle.text = Medicine[indexPath.row].mTitle
            cell.mType.text = Medicine[indexPath.row].mType
            cell.mStrength.text = Medicine[indexPath.row].mStrength
            cell.mTime.text = Medicine[indexPath.row].mTime
            cell.mDescription.text = Medicine[indexPath.row].mDescription
            cell.mDoseSchedule.text = Medicine[indexPath.row].mSchedule
            cell.mFood.text = Medicine[indexPath.row].mFood
            cell.mDate.text = Medicine[indexPath.row].mDate
            
            if Medicine[indexPath.row].flag == false
            {
                cell.flagImage.image = UIImage(named: "No")
            }
            else
            {
                cell.flagImage.image = UIImage(named: "Yes")
            }
        }
        else{
            noMedicineFound()
            print("No record found")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewMedicineDetails")as! ViewMedicineDetails
        storyboard.Medicine = [self.Medicine[indexPath.row]]
        navigationController?.pushViewController(storyboard, animated: true)
    }
    
    
    @IBAction func btnBackAct(_ sender: UIBarButtonItem){
        navigationController?.popToRootViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        let takeAct = UITableViewRowAction(style: .default, title: "Take")
        { (take, indexPath) in
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            let medicineRecord = self.Medicine[indexPath.row] as MedicineRecord
            medicineRecord.flag = true
            
            
            do {
                try managedContext.save()
                //self.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            } catch let error as NSError {
                print("Error while trying to save medicine",error)
            }
            
        }
        let UnTakeAct = UITableViewRowAction(style: .default, title: "UnTake") { (UnTakeAct, indexPath) in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            let medicineRecord = self.Medicine[indexPath.row] as MedicineRecord
            medicineRecord.flag = false
            medicineRecord.mId = self.Medicine[indexPath.row].mId
           
            
            do {
                try managedContext.save()
                //self.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            } catch let error as NSError {
                print("Error while trying to save medicine",error)
            }
        }
        let deleteAct = UITableViewRowAction(style: .default, title: "Delete"){ (deleteAct, indexPath) in
            
            let delete = UIAlertController(title: "Sim Pill", message: "Are you want to sure to delete!", preferredStyle: .alert)
            let deleteAct = UIAlertAction(title: "Delete", style: .default, handler:{ (alert) in
                
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                let data = self.Medicine[indexPath.row]
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
    
    
    
    func getData()
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do
        {
            let fetchRequest: NSFetchRequest <MedicineRecord> = MedicineRecord.fetchRequest()
            print("get data on selected date = \(selectedDate)")
            fetchRequest.predicate = NSPredicate(format: "mDate == %@", selectedDate)
            try Medicine = context.fetch(fetchRequest)
        }
        catch
        {
            print("Error Message :-\(error)")
        }
    }
}
