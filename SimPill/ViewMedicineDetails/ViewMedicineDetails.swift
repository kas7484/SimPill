//
//  ViewMedicineDetails.swift
//  SimPill
//


import UIKit
import UserNotifications
import  CoreData

class ViewMedicineDetails: UIViewController
{
    @IBOutlet var mTitle: UILabel!
    @IBOutlet var mType: UILabel!
    @IBOutlet var mDescription: UILabel!
    @IBOutlet var mDetails: UILabel!
    @IBOutlet var mFood: UILabel!
    @IBOutlet var mDate: UILabel!
    @IBOutlet var mSchedule: UILabel!
    @IBOutlet var mTime: UILabel!
    @IBOutlet var ivM_Flag: UIImageView!
    
    var name = String()
    var type = String()
    var strenght = String()
    var details = String()
    var food = String()
    var date = String()
    var schedule = String()
    var time = String()
    
    //var Medicine = [MedicineRecord]()
    var Medicine = [MedicineRecord]()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print("medicine : - \(Medicine)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchMedicineDetails()
    }

    @IBAction func btnBackAct(_ sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func btnEditAct(_ sender: UIBarButtonItem)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddMedicineVC")as! AddMedicineVC
        storyboard.Medicine = Medicine
        storyboard.isEdit = true
        //self.present(storyboard, animated: true, completion: nil)
        navigationController?.pushViewController(storyboard, animated: true)
    }
    
    //for the printing the fetched data
    func fetchMedicineDetails()
    {
        
        
        let selectedMedicine = Medicine[0]
        self.mTitle.text = selectedMedicine.mTitle
        self.mType.text = selectedMedicine.mType
        self.mDescription.text = selectedMedicine.mStrength
        self.mDetails.text = selectedMedicine.mDescription
        self.mFood.text = selectedMedicine.mFood
        self.mDate.text = selectedMedicine.mDate
        self.mSchedule.text = selectedMedicine.mSchedule
        self.mTime.text = selectedMedicine.mTime
        
        if Medicine.count > 0
        {
            for i in 0...Medicine.count - 1
            {
                if Medicine[i].flag == false
                {
                    ivM_Flag.image = UIImage(named: "No")
                }else
                {
                    ivM_Flag.image = UIImage(named: "Yes")
                }
            }
        }
        else
        {
            print("No Medicine detils")
        }
        
    }
    
    
    
    
    
    @IBAction func btnRemoveMedicine(_ sender: UIButton)
    {
            let delete = UIAlertController(title: "Sim Pill", message: "Are you want to sure to delete!", preferredStyle: .alert)
            let deleteAct = UIAlertAction(title: "Delete", style: .default, handler:
            { (alert) in
                
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
                let managedContext = appDelegate.persistentContainer.viewContext
                let selectedMedicine = self.Medicine[0]
                print("selectedMedicine : = \(selectedMedicine)")
                managedContext.delete(selectedMedicine)
                do {
                    try managedContext.save()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CalenderVC")
                    //self.present(storyboard, animated: true, completion: nil)
                    //self.navigationController?.popToRootViewController(animated: true)
                    self.navigationController?.pushViewController(storyboard, animated: true)
                } catch {
                    let saveError = error as NSError
                    print(saveError)
                }
            })
            let cancelAct = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            delete.addAction(deleteAct)
            delete.addAction(cancelAct)
            self.present(delete, animated: true, completion: nil)
    }
    
    @IBAction func btnAddRefillReminderAct(_ sender: UIButton)
    {
        let alert = UIAlertController(title: "Sim Pill", message: "Enter the amount of units remaining. ", preferredStyle: .alert)
        
        // Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "No of units"
        }
        
        // Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            //print("Text field: \(textField?.text)")
            
            //let context = (UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
           // let reminder = MedicineRecord(context: context)
           
            /*(reminder.mStrength?.count)
            do {
                print("Add Unit")
                reminder.mStrength = textField?.text
                try context.save()
            }
            catch{
                print("Unit Remaining")
            }*/
            
        }))
        
        //  Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
