//
//  TaskContentViewController.swift
//  CoreDataApp
//
//  Created by yosef elbosaty on 5/15/20.
//  Copyright © 2020 yosef elbosaty. All rights reserved.
//

import UIKit
import CoreData
class TaskContentViewController: UIViewController{

    var task : TaskMO!

    @IBOutlet weak var content: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        content.layer.borderColor = UIColor.lightGray.cgColor
        content.layer.borderWidth = 1
        navigationItem.title = task.taskName
        content.text = task.taskContent
        }
        
        
        
    }
    

   


