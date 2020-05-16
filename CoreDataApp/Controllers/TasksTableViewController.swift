//
//  ViewController.swift
//  CoreDataApp
//
//  Created by yosef elbosaty on 5/15/20.
//  Copyright © 2020 yosef elbosaty. All rights reserved.
//

import UIKit
import CoreData

class TasksTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    var tasks : [TaskMO] = []
    
    var fetchResultsController : NSFetchedResultsController<TaskMO>!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 30.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset = .zero
        tableView.backgroundColor = UIColor(red: 242.0/255.0, green: 238.0/255.0, blue: 203.0/255.0, alpha: 1)
        navigationItem.title = "To-Do"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        //Fetching Data
        let fetchRequest : NSFetchRequest<TaskMO> = TaskMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "taskName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let appDelegate = (UIApplication.shared.delegate) as? AppDelegate{
            let context = appDelegate.persistentContainer.viewContext
            fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultsController.delegate = self
            do{
                try fetchResultsController.performFetch()
                if let fetchedResults = fetchResultsController.fetchedObjects{
                    tasks = fetchedResults
                }
            }catch{print(error)}
            
        }
    }

    //MARK:- Go To AddTasksViewController
    @IBAction func gotoNewTasks(_ sender: Any) {
        performSegue(withIdentifier: "newTasks", sender: self)
    }
    
}

//MARK:- NSFetchedResultsControllerDelegate Methods:
extension TasksTableViewController{
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type{
        case .insert:
            if let newIndexPath = newIndexPath{
            tableView.insertRows(at: [newIndexPath], with: .fade)
        }
        case .delete:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath{
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }
        if let fetchedObjects = controller.fetchedObjects{
            tasks = fetchedObjects as! [TaskMO]
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

//MARK:- TabelView DataSource Methods:
extension TasksTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.taskName
        cell.layer.backgroundColor = UIColor(red: 242.0/255.0, green: 238.0/255.0, blue: 203.0/255.0, alpha: 1).cgColor
        cell.accessoryType = task.done ? .checkmark : .none
        return cell
    }
}

//MARK:- TabelView Delegate Methods:
extension TasksTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contentDestination = storyboard?.instantiateViewController(withIdentifier: "content") as! TaskContentViewController
        navigationController?.pushViewController(contentDestination, animated: true)
        contentDestination.task = tasks[indexPath.row]
  
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            if let appDelegate = (UIApplication.shared.delegate) as? AppDelegate{
                let context = appDelegate.persistentContainer.viewContext
                let taskToDelete = self.fetchResultsController.object(at: indexPath)
                context.delete(taskToDelete)
                appDelegate.saveContext()
        }
           
            handler(true)
    }
        
        let doneAction = UIContextualAction(style: .normal, title: "Done") { (action, view, handler) in
            if let appDelegate = (UIApplication.shared.delegate) as? AppDelegate{
           
                self.tasks[indexPath.row].done = true
                appDelegate.saveContext()
            }
            handler(true)
        }
        
  
        let swipeActionConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, doneAction])
        return swipeActionConfiguration
    }
}
