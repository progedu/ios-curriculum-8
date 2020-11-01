//
//  TodoListTableViewController.swift
//  TodoLog
//
//  Created by Kouki Saito on 12/1/19.
//  Copyright © 2019 Kouki Saito. All rights reserved.
//

import UIKit
import CoreData

class TodoListTableViewController: UITableViewController {

    var managedObjectContext: NSManagedObjectContext!
    var fetchedResultsController: NSFetchedResultsController<Todo>!

    override func viewDidLoad() {
        super.viewDidLoad()

        managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<Todo>  = Todo.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]

        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "TODO登録", message: "TODO のタイトルと行う場所を入力してください。", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "タイトル(例: 買い物)"
            textField.accessibilityIdentifier = "InputTitle"
        }
        alert.addTextField { textField in
            textField.placeholder = "場所(例: スーパー)"
            textField.accessibilityIdentifier = "InputLocationInfo"
        }
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "登録", style: .default, handler: { [weak alert] _ in
            if let todoTitle = alert?.textFields?[0].text,
                let locationInfo = alert?.textFields?[1].text {
                self.addTodo(title: todoTitle, locationInfo: locationInfo)
            }
        }))
        present(alert, animated: true, completion: nil)
    }

    func addTodo(title: String, locationInfo: String) {
        let todo = Todo(context: managedObjectContext)
        todo.title = title
        todo.createdAt = Date()
        todo.locationInfo = locationInfo
        todo.done = false
        try? managedObjectContext.save()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections![section].numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TodoTableViewCell
        let todo = fetchedResultsController.object(at: indexPath)
        cell.configureCell(todo: todo) { [weak self] isChecked in
            todo.done = isChecked
            try? self?.fetchedResultsController.managedObjectContext.save()
        }
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Message" {
            // swiftlint:disable:next force_cast
            let destination = segue.destination as! MessageCollectionViewController
            let selectedTodo = fetchedResultsController.object(at: tableView.indexPathForSelectedRow!)
            destination.todo = selectedTodo
        }
    }

}

extension TodoListTableViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .automatic)
        @unknown default:
            break
        }
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

class TodoListDataController {
    private let managedObjectContext: NSManagedObjectContext
    let fetchedResultsController: NSFetchedResultsController<Todo>

    init(managedObjectContext: NSManagedObjectContext, delegate: NSFetchedResultsControllerDelegate) {
        self.managedObjectContext = managedObjectContext
        let fetchRequest: NSFetchRequest<Todo>  = Todo.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]

        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = delegate
    }

    func performFetch() {
        try? fetchedResultsController.performFetch()
    }

    func addTodo(title: String, locationInfo: String) {
        let todo = Todo(context: managedObjectContext)
        todo.title = title
        todo.createdAt = Date()
        todo.locationInfo = locationInfo
        todo.done = false
        try? managedObjectContext.save()
    }

    func modify(todo: Todo, done: Bool) {
        todo.done = done
        try? managedObjectContext.save()
    }
}

