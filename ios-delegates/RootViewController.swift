//
//  RootViewController.swift
//  ios-delegates
//
//  Created by KAGE on 12/10/16.
//  Copyright © 2016 KAGE. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    fileprivate class DataSource {
        var title: String
        var toVC: UIViewController

        init(title: String, toVC: UIViewController) {
            self.title = title
            self.toVC  = toVC
        }
    }

    fileprivate class TableViewCell: UITableViewCell {
        static let identifier = "TableViewCell"

        func configure(dataSource: DataSource) {
            textLabel?.text = dataSource.title
        }
    }

    fileprivate lazy var tableView: UITableView = {
        let table = UITableView(frame: self.view.frame)
        table.delegate   = self
        table.dataSource = self
        table.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        return table
    }()

    fileprivate var dataSources = [DataSource]() {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        setupDataSources()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setupDataSources() {
        dataSources.append(DataSource(title: NSStringFromClass(UIViewController.self), toVC: UIViewController()))
        dataSources.append(DataSource(title: NSStringFromClass(UIViewController.self), toVC: UIViewController()))
        dataSources.append(DataSource(title: NSStringFromClass(UIViewController.self), toVC: UIViewController()))
        dataSources.append(DataSource(title: NSStringFromClass(UIViewController.self), toVC: UIViewController()))
        dataSources.append(DataSource(title: NSStringFromClass(UIViewController.self), toVC: UIViewController()))
    }
}

extension RootViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSources.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath)
        if let cell = cell as? TableViewCell {
            cell.configure(dataSource: dataSources[indexPath.row])
        }

        return cell
    }
}

extension RootViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = dataSources[indexPath.row].toVC
        navigationController?.pushViewController(vc, animated: true)
    }
}

