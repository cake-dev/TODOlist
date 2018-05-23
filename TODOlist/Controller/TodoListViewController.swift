//
//  ViewController.swift
//  TODOlist
//
//  Created by Jake B on 5/18/18.
//  Copyright © 2018 Jake B. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var listItems = [ListItem]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.

        loadItems()
    }
    
    // MARK: TableView datasource methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = listItems[indexPath.row].title
        cell.accessoryType = listItems[indexPath.row].checked == true ? .checkmark : .none
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: TableView delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listItems[indexPath.row].checked = !listItems[indexPath.row].checked
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    
    // MARK: Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New List Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will occur once user clicks add item button on alert
            if textField.text != "" {
                let newItem = ListItem()
                newItem.title = textField.text!
                self.listItems.append(newItem)
                self.saveItems()
                self.tableView.reloadData()
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(listItems)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding list items")
        }
    }
    
    private func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                listItems = try decoder.decode([ListItem].self, from: data)
            } catch {
                print("Error decoding listItem array, \(error)")
            }
        }
    }
    
    

}

