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
            accessoryType   = .detailButton
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
        navigationItem.rightBarButtonItem = editButtonItem

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

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        sampleTableView.isEditing = editing
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

    /*
     * 引数で与えられたindexPathに対するcellの設定を行います．
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SampleTableViewCell.identifier, for: indexPath)
        if let cell = cell as? SampleTableViewCell {
            cell.configure(dataSource: dataSources[indexPath.section][indexPath.row])
        }

        return cell
    }

    /*
     * セクションの数を指定します．
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSources.count
    }

    /*
     * 各sectionの行数を指定します．
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSources[section].count
    }

    /*
     * tableViewの右に表示するインデックスリストの各セクションのタイトルを指定します．
     * この場合は偶数セクションのみインデックスリストに表示するようにしています．
     */
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        var titles = [String]()
        for section in 0 ..< dataSources.count {
            if section % 2 == 0 {
                titles.append(String(section))
            }
        }

        return titles
    }

    /*
     * インデックスリストの各項目がタップされた際のジャンプ先のセクションを指定します．
     * titleにはsectionIndexTitles(for:)で指定した配列内の各文字列が，
     * indexにはsectionIndexTitles(for:)で指定した配列内におけるインデックスが渡されます．
     */
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        guard let section = Int(title) else {
            return 0
        }

        return section
    }

    /*
     * 各セクションのヘッダに表示する文字列を設定します．
     * アルファベットは全て大文字に変換されるようです．
     */
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // return "header for section:\(section)"
        return "header for section: \(section)"
    }

    /*
     * 各セクションのフッタに表示する文字列を設定します．
     * こちらはアルファベットの大文字変換はされないようです．
     */
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "footer for section: \(section)"
    }

    // MARK: - Inserting or Deleting Table Rows

    /*
     * 各indexPathのcellのスワイプメニューのうちいずれかがタップされた際に呼ばれます．
     * tableView(_:editActionsForRowAt:)でスワイプメニューをカスタマイズしている際には
     * そのメソッド内で設定したクロージャが呼ばれ，本メソッドは呼ばれません．
     */
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print("commit: \(editingStyle), \(indexPath)")
    }

    /*
     * 各indexPathのcellが編集(削除，移動等)を行えるか指定します．
     * また，tableViewが編集モードにはいった際にも呼ばれます．
     */
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // MARK: - Reordering Table Rows

    /*
     * 各indexPathのcellが編集モード中に移動できるか指定します．
     * なお，cellがスワイプされ，スワイプメニューが表示された際に呼ばれます．また，tableViewは編集モードに入った際にも呼ばれます．
     */
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    /*
     * cellが移動された際に呼び出されます．
     */
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var ds = dataSources
        let data = dataSources[sourceIndexPath.section][sourceIndexPath.row]
        ds[sourceIndexPath.section].remove(at: sourceIndexPath.row)
        ds[destinationIndexPath.section].insert(data, at: destinationIndexPath.row)

        dataSources = ds
    }
}

extension SampleTableViewController: UITableViewDelegate {
    // MARK: - Configuring Rows for the Table View

    /*
     * 各indexPathのcellの高さを指定します．
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    /*
     * 各indexPathのcellの高さの推定値を指定します．
     * 本メソッドが実装されている場合， tableViewの表示時に [全て] のindexPathについてまず本メソッドが呼ばれます．
     * その後，cellが実際に表示されるタイミングで該当cellのtableView(_:heightForRowAt:)が呼ばれます．
     *
     * 本メソッドが実装されていない場合はtableView(_:heightForRowAt:)が全てのindexPathについて呼ばれます．
     *
     * 各cellの高さが動的に変化する場合，本メソッドを実装し推定高さを指定した後，実際の描画時に正確な高さを
     * tableView(_:heightForRowAt:)の中で計算し指定するようにします．
     */
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }


    /*
     * 各indexPathのcellのインデントのレベルを指定します．
     * cell同士に階層関係があるような場合に有用です．
     */
    func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        return indexPath.section
    }

    /*
     * 各indexPathのcellが表示される直前に呼ばれます．
     */
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? SampleTableViewCell {
            print("title: \(cell.textLabel?.text ?? "")")
        }
    }

    // MARK: - Managing Accessory Views

    /*
     * 各indexPathのcellがスワイプされた際に表示するスワイプメニューの内容(とそれぞれがタップされた際の処理を行うクロージャ)を指定します．
     * 下記のような実装をした場合は，表示される際には[rowAction3 | rowAction2 | rowAction1]の順に表示されます．
     */
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let rowAction1 = UITableViewRowAction(style: .default, title: "default") { (action: UITableViewRowAction, idx: IndexPath) in
            print("default(\(idx)) was performed")
        }
        let rowAction2 = UITableViewRowAction(style: .normal, title: "normal") { (action: UITableViewRowAction, idx: IndexPath) in
            print("normal(\(idx)) was performed")
        }
        let rowAction3 = UITableViewRowAction(style: .destructive, title: "destructive") { (action: UITableViewRowAction, idx: IndexPath) in
            print("destructive(\(idx)) was performed")
        }

        return [rowAction1, rowAction2, rowAction3]
    }

    /*
     * 各indexPathのcellのアクセサリボタンがタップされた際の処理を記述します．
     */
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print("accessory button was tapped")
    }

    // MARK: - Managing Selections

    /*
     * 各indexPathのcellがタップされた際に実際にどのcellを選択状態にするかを指定します．
     */
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath
    }

    /*
     * 各indexPathのcellがタップされた際に呼び出されます．
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt: \(indexPath)")

        // タップ後すぐ非選択状態にするには下記メソッドを呼び出します．
        // sampleTableView.deselectRow(at: indexPath, animated: true)
    }

    /*
     * 各indexPathのcellがアンタップ(非選択状態に)された際にどのcellを非選択状態にするか指定します．
     */
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        print("willDeselectRowAt: \(indexPath)")
        return indexPath
    }

    /*
     * 各indexPathのcellがアンタップ(非選択状態に)された際に呼び出されます．
     */
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("didDeselectRowAt: \(indexPath)")
    }

    // MARK: - Modifying the Header and Footer of Sections

    /*
     * 各sectionのヘッダにviewを設定します．
     * tableView(_:titleForHeaderInSection:)も実装されている場合，本メソッドが優先されます．
     * 本メソッドを実装していてもnilを返していればtableView(_:titleForHeaderInSection:)が優先されます．
     */
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    /*
     * 各sectionのフッタにviewを設定します．
     * tableView(_:titleForFooterInSection:)も実装されている場合，本メソッドが優先されます．
     * 本メソッドを実装していてもnilを返していればtableView(_:titleForFooterInSection:)が優先されます．
     */
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    /*
     * 各sectionのヘッダの高さを指定します．
     */
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    /*
     * 各sectionのヘッダの推定高さを指定します．
     * 本メソッドとtableView(_:heightForHeaderInSection:)との関係はcellのときと同様です．
     */
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    /*
     * 各sectionのフッタの高さを指定します．
     */
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }

    /*
     * 各sectionのフッタの推定高さを指定します．
     * 本メソッドとtableView(_:heightForFooterInSection:)との関係はcellのときと同様です．
     */
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 20
    }

    /*
     * 各sectionのヘッダが表示される際に呼ばれます．
     */
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        print("willDisplayingHeaderView: \(section)")
    }

    /*
     * 各sectionのフッタが表示される際に呼ばれます．
     */
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        print("willDisplayingFooterView: \(section)")
    }

    // MARK: - Editing Table Rows

    /*
     * 各indexPathのcellが横にスワイプされスワイプメニューが表示される際に呼ばれます．
     */
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        print("willBeginEditingRow: \(indexPath)")
    }

    /*
     * 各indexPathのcellのスワイプメニューが非表示になった際に呼ばれます．
     */
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        print("didEndEditingRow: \(indexPath)")
    }

    /*
     * tableViewが編集モードになった際に各indexPathのcell(の左側)に表示するボタンのスタイルを指定します．
     * .insertを指定すると + ボタンが表示され，それがタップされるとtableView(_:commit:forRowAt:)が呼び出されます．
     * .deleteを指定すると - ボタンが表示され，それがタップされるとスワイプメニューが表示されます．
     */
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }

    /* 
     * 各indexPathのcellのスワイプメニューに表示するデフォルトの削除ボタンのタイトルを指定します．
     * nilを指定するとデフォルトの文字列が表示されます．
     * tableView(_:editActionsForRowAt:)でスワイプメニューをカスタマイズしている際には本メソッドは呼ばれません．
     */
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "OK?"
    }

    /*
     * tableViewが編集モードの際にtableView(_:indentationLevelForRowAt:)で指定したインデントレベルを適用するか指定します．
     */
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // MARK: - Reordering Table Rows

    /*
     * tableViewが編集モードでcellを移動している際にどのcellをずらすか指定します．
     * proposedDestinationIndexPathには移動中のcellの真下(裏)にあるcellのindexPathが渡されます．
     */
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        return proposedDestinationIndexPath
    }

    // MARK: - Tracking the Removal of Views

    /*
     * 各indexPathのcellが画面から見えなくなり，さらにtableViewそのものから除去された際に呼び出されます．
     */
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("didEndDisplayingCell: \(indexPath)")
    }

    /*
     * 各sectionのheaderが画面から見えなくなり，さらにtableViewそのものから除去された際に呼び出されます．
     */
    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        print("didEndHeaderDisplayingHeaderView: \(section)")
    }

    /*
     * 各sectionのfooterが画面から見えなくなり，さらにtableViewそのものから除去された際に呼び出されます．
     */
    func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        print("didEndDisplayingFooterView: \(section)")
    }

    // MARK: - Copying and Pasting Row Content

    /*
     * 各indexPathのcellをロングタップした際にアクションメニューを表示するか指定します．
     * アクションメニューとは，テキストを選択している際に表示される[Cut | Copy]のようなメニューです．
     */
    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    /*
     * tableView(_:shouldShowMenuForRowAt:)がtrueとなっている各indexPathのcellで，どのアクションメニューを表示するか指定します．
     * この場合は[Select All]アクションのみを表示します
     */
    func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        if NSStringFromSelector(action) == "selectAll:" {
            return true
        }

        return false
    }

    /*
     * 各indexPathのアクションメニューのうちいずれかのアクションがタップされた際の挙動を指定します．
     */
    func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        print("performAction: \(action), \(indexPath), \(sender)")
    }

    // MARK: - Managing Table View Highlighting

    /*
     * 各indexPathのcellをハイライトできるか指定します．
     */
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    /*
     * 各indexPathのcellがハイライトされた際に呼ばれます．
     * あるcellがタップされた際は，didHighlight → didUnhighlight → willSelect → didSelectの順に呼び出されます．
     * さらにその状態で別のcellがタップされた際は，didHighlight → didUnhighlight → willSelect → willDeselect → didDeselect → didSelectの順に呼び出されます．
     */
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        print("didHighlightRowAt: \(indexPath)")
    }

    /*
     * 各indexPathのcellがアンハイライトされた際に呼ばれます．
     * 基本的にtableView(_:didHighlightRowAt:)が呼ばれた直後に呼ばれます．
     */
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        print("didUnhighlightRowAt: \(indexPath)")
    }

    // MARK: - Managing Table View Focus

    /*
     * 各indexPathのcellがフォーカスできるか指定します．
     */
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    /*
     * あるindexPathのcellからある別のindexPathのcellにフォーカスを移せるか指定します．
     */
    func tableView(_ tableView: UITableView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool {
        return true
    }

    /*
     * フォーカスが移された際に呼び出されます．
     */
    func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        print("didUpdateFocusIn: \(context), \(coordinator)")
    }

    /*
     * 初めにフォーカスされるcellのindexPathを指定します．
     */
    func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath? {
        return IndexPath(row: 0, section: 0)
    }
}
