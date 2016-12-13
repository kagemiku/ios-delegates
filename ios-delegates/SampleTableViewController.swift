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
        let tableView = UITableView(frame: self.view.frame, style: .grouped)
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.register(SampleTableViewCell.self, forCellReuseIdentifier: SampleTableViewCell.identifier)
        return tableView
    }()

    fileprivate var dataSources = [[DataSource]]() {
        didSet {
            sampleTableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "TableView"

        view.addSubview(sampleTableView)
        setupDataSources()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        sampleTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setupDataSources() {
        for section in 0 ..< 5 {
            var rowDataSources = [DataSource]()
            for row in 0 ..< 10 {
                rowDataSources.append(DataSource(title: "\(section) - \(row)"))
            }
            dataSources.append(rowDataSources)
        }
    }
}

extension SampleTableViewController: UITableViewDataSource {
    // MARK: - Configuring a Table View

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SampleTableViewCell.identifier, for: indexPath)
        if let cell = cell as? SampleTableViewCell {
            cell.configure(dataSource: dataSources[indexPath.section][indexPath.row])
        }

        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSources.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSources[section].count
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        var titles = [String]()
        for section in 0 ..< dataSources.count {
            titles.append("s: \(section)")
        }

        return titles
    }

    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "header for section: \(section)"
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "footer for section: \(section)"
    }

    // MARK: - Inserting or Deleting Table Rows

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print("\(editingStyle), \(indexPath)")
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // MARK: - Reordering Table Rows

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("\(sourceIndexPath), \(destinationIndexPath)")
    }
}

extension SampleTableViewController: UITableViewDelegate {
    // MARK: - Configuring Rows for the Table View

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }


    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }


    func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        return indexPath.section
    }


    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("willDispaly")
    }

    // MARK: - Managing Accessory Views

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let rowAction1 = UITableViewRowAction(style: .default, title: "default") {
            print("\($1)'s \($0) is performed")
        }
        let rowAction2 = UITableViewRowAction(style: .normal, title: "normal") {
            print("\($1)'s \($0) is performed")
        }
        let rowAction3 = UITableViewRowAction(style: .destructive, title: "destructive") {
            print("\($1)'s \($0) is performed")
        }

        return [rowAction1, rowAction2, rowAction3]
    }

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
    }

    // MARK: - Managing Selections

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sampleTableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    }

    // MARK: - Modifying the Header and Footer of Sections

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    }

    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
    }

    // MARK: - Editing Table Rows

    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
    }

    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return nil
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // MARK: - Reordering Table Rows

    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        return sourceIndexPath
    }

    // MARK: - Tracking the Removal of Views

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }

    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
    }

    func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
    }

    // MARK: - Copying and Pasting Row Content

    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
    }

    // MARK: - Managing Table View Highlighting

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
    }

    // MARK: - Managing Table View Focus

    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
    }

    func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath? {
        return nil
    }
}
