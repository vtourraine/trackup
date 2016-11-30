//
//  DocumentsListViewController.swift
//  trackup-ios
//
//  Created by Vincent Tourraine on 30/11/16.
//  Copyright © 2016 Studio AMANgA. All rights reserved.
//

import UIKit
import TrackupCore

class DocumentsListViewController: UITableViewController {

    var detailViewController: DocumentViewController? = nil
    var documents = [TrackupDocument]()


    override func viewDidLoad() {
        super.viewDidLoad()

        let parser = TrackupParser()
        let paths = [Bundle.main.path(forResource: "onelist", ofType: "tu.md"),
                     Bundle.main.path(forResource: "contacts", ofType: "tu.md"),
                     Bundle.main.path(forResource: "gameskeeper", ofType: "tu.md")]

        documents = paths.map({ (path) -> TrackupDocument in
            let content = try! NSString(contentsOfFile: path!, usedEncoding: nil)
            let document = parser.documentFromString(content as String)
            return document
        })

        // self.navigationItem.leftBarButtonItem = self.editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DocumentViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    func insertNewObject(_ sender: Any) {
        // documents.insert(NSDate(), at: 0)
        // let indexPath = IndexPath(row: 0, section: 0)
        // self.tableView.insertRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let document = documents[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DocumentViewController
                controller.representedDocument = document
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let document = documents[indexPath.row]
        cell.textLabel?.text = document.title
        cell.detailTextLabel?.text = "\(document.versions.count) versions"
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    /*
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            documents.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
     */
}

