//
//  AddTasksViewController.swift
//  CoreDataApp
//
//  Created by yosef elbosaty on 5/15/20.
//  Copyright © 2020 yosef elbosaty. All rights reserved.
//

import UIKit
import CoreData

class AddTasksViewController: UIViewController {

    var task : TaskMO!
    
    //Outlets Declaration
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var taskContentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskContentTextView.layer.borderColor = UIColor.lightGray.cgColor
        taskContentTextView.layer.borderWidth = 1
        navigationItem.title = "New Task"
    }
    //MARK:- Save Button Pressed:
    @IBAction func saveButtonPressed(_ sender: Any) {
        if taskNameTextField.text == "", taskContentTextView.text == ""{
            let alert = UIAlertController(title: "OOPS!", message: "Please make sure you filled the required fields.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }else{
       if let appDelegate = (UIApplication.shared.delegate) as? AppDelegate{
        task = TaskMO(context: appDelegate.persistentContainer.viewContext)
        task.taskName = taskNameTextField.text
        task.taskContent = taskContentTextView.text
        let destination = storyboard?.instantiateViewController(withIdentifier: "home") as! TasksTableViewController
        destination.tasks = [task]
        navigationController?.popToRootViewController(animated: true)
        appDelegate.saveContext()
        }
        }
        
    }
    
}
