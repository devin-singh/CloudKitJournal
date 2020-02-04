//
//  EntryListTableViewController.swift
//  CloudKitJournal
//
//  Created by Devin Singh on 2/4/20.
//  Copyright © 2020 Devin Singh. All rights reserved.
//

import UIKit

class EntryListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        EntryController.shared.fetchAllEntries { (result) in
            if result {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }else{
                print("Error fetching on function call")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return EntryController.shared.entries.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)
        
        let entry = EntryController.shared.entries[indexPath.row]
        cell.textLabel?.text = entry.title
        
        return cell
    }
    
    
     // MARK: - Navigation
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditEntry" {
            guard let destinationVC = segue.destination as? EntryDetailViewController, let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let entryToSend = EntryController.shared.entries[indexPath.row]
            
            destinationVC.entry = entryToSend
            
        }
     }
     
    
}
