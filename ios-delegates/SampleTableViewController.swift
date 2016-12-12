//
//  SampleTableViewController.swift
//  ios-delegates
//
//  Created by KAGE on 12/12/16.
//  Copyright © 2016 KAGE. All rights reserved.
//

import UIKit

class SampleTableViewController: UIViewController {
    fileprivate struct DataSource {
        var title: String

        init(title: String) {
            self.title = title
        }
    }

    fileprivate class SampleTableViewCell: UITableViewCell {
        static let identifier = "SampleTableViewCell"

        func configure(dataSource: DataSource) {
            textLabel?.text = dataSource.title
        }
    }

    fileprivate lazy var sampleTableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame)
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.register(SampleTableViewCell.self, forCellReuseIdentifier: SampleTableViewCell.identifier)
        return tableView
    }()

    fileprivate var dataSources = [DataSource]() {
        didSet {
            sampleTableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(sampleTableView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        sampleTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SampleTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSources.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SampleTableViewCell.identifier, for: indexPath)
        if let cell = cell as? SampleTableViewCell {
            cell.configure(dataSource: dataSources[indexPath.row])
        }

        return cell
    }
}

extension SampleTableViewController: UITableViewDelegate { }
