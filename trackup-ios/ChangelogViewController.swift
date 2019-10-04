//
//  ChangelogViewController.swift
//  trackup-ios
//
//  Created by Vincent Tourraine on 09/03/2018.
//  Copyright © 2018 Studio AMANgA. All rights reserved.
//

import UIKit
import TrackupCore

class ChangelogViewController: UITableViewController {

    init() {
        super.init(style: .plain)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func documentReleasedVersions(document: TrackupDocument) -> [TrackupVersion] {
        return document.versions.compactMap({ (version) -> TrackupVersion? in
            return (version.createdDate != nil) ? version : nil
        })
    }

    func configureView() {
        self.title = representedDocument?.title
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.configureView()
    }

    var representedDocument: TrackupDocument? {
        didSet {
            self.configureView()
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let document = self.representedDocument
            else { return 0 }

        return documentReleasedVersions(document: document).count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let document = self.representedDocument
            else { return nil }

        return documentReleasedVersions(document: document)[section].title
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        guard let version = representedDocument?.versions[indexPath.section]
            else { return cell }

        cell.textLabel?.numberOfLines = 0
        let text = NSMutableAttributedString()
        let fontSize = UIFont.preferredFont(forTextStyle: .body).pointSize

        for (index, item) in version.items.enumerated() {
            let weight = (item.status == .major) ? UIFont.Weight.bold : UIFont.Weight.regular
            text.append(NSAttributedString(string: "– \(item.title)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: weight)]))
            if index != (version.items.count - 1) {
                text.append(NSAttributedString(string: "\n"))
            }
        }
        cell.textLabel?.attributedText = text
        cell.selectionStyle = .none
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
