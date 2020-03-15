//
//  TodoListTableViewController.swift
//  TodoLog
//
//  Created by Kouki Saito on 12/1/19.
//  Copyright © 2019 Kouki Saito. All rights reserved.
//

import UIKit

class TodoListTableViewController: UITableViewController {

    var todoList = [
        Todo(
            title: "カレーの買い物",
            createdAt: Date() - 30*60, // 30分前
            locationInfo: "スーパー",
            done: false
        ),
        Todo(
            title: "定期券の更新",
            createdAt: Date() - 2*24*60*60, // 2日前
            locationInfo: "最寄駅",
            done: true
        ),
        Todo(
            title: "新幹線の予約",
            createdAt: Date() - 2*24*60*60, // 2日前
            locationInfo: "東京駅",
            done: false
        ),
        Todo(
            title: "メールを返す",
            createdAt: Date() - 4*24*60*60, // 4日前
            locationInfo: "自宅",
            done: false
        )
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "TODO登録", message: "TODO のタイトルと行う場所を入力してください。", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "タイトル(例: 買い物)"
        }
        alert.addTextField { textField in
            textField.placeholder = "場所(例: スーパー)"
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
        let todo = Todo(title: title, createdAt: Date(), locationInfo: locationInfo, done: false)
        todoList.insert(todo, at: 0)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TodoTableViewCell
        cell.configureCell(todo: todoList[indexPath.row])
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
