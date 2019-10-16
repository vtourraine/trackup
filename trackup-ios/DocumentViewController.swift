//
//  DocumentViewController.swift
//  trackup-ios
//
//  Created by Vincent Tourraine on 30/11/16.
//  Copyright © 2016-2019 Studio AMANgA. All rights reserved.
//

import UIKit
import TrackupCore
import SafariServices

class DocumentViewController: UITableViewController {

    func configureView() {
        title = representedDocument?.title
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    var representedDocument: TrackupDocument? {
        didSet {
            self.configureView()
        }
    }

    @IBAction func presentDocumentWebsite(_ sender: UIBarButtonItem) {
        if let website = representedDocument?.website {
            let safariViewController = SFSafariViewController(url: website)
            present(safariViewController, animated: true, completion: nil)
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let document = self.representedDocument
            else { return 0 }

        return document.versions.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return representedDocument?.versions[section].title
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let document = self.representedDocument
            else { return 0 }

        return document.versions[section].items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let item = representedDocument?.versions[indexPath.section].items[indexPath.row]
        cell.textLabel?.text = item?.title
        cell.selectionStyle = .none
        return cell
    }
}
