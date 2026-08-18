// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class PopUp {

    private let alert: UIAlertController
    private let uiv: UIViewController
    private let button: UIBarButtonItem
    private let title: String
    private let message: String
    private let prefersCatalystList: Bool
    private var listActions = [Action]()

    init(
        _ uiv: UIViewController,
        _ button: UIBarButtonItem,
        _ title: String,
        _ message: String = "",
        prefersCatalystList: Bool = false
    ) {
        alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.actionSheet)
        alert.view.tintColor = ColorCompatibility.label
        self.button = button
        self.uiv = uiv
        self.title = title
        self.message = message
        self.prefersCatalystList = prefersCatalystList
    }

    convenience init(_ uiv: UIViewController,
                     title: String = "Product Selection",
                     _ button: UIBarButtonItem,
                     _ list: [String],
                     _ fn: @escaping (String) -> Void,
    ) {
        self.init(uiv, button, title)
        list.forEach { item in
            var code = item
            if item.contains(":") {
                code = item.firstToken(":")
            }
            add(UIAlertAction(item) { _ in fn(code) })
        }
        finish()
    }

    convenience init(_ uiv: UIViewController,
                     title: String = "Product Selection",
                     _ button: UIBarButtonItem,
                     _ list: [Int],
                     _ fn: @escaping (Int) -> Void
    ) {
        self.init(uiv, button, title)
        list.forEach { item in
            add(UIAlertAction(To.string(item)) { _ in fn(item) })
        }
        finish()
    }

    convenience init(_ uiv: UIViewController,
                     title: String = "Product Selection",
                     _ button: UIBarButtonItem,
                     _ list: [String],
                     _ fn: @escaping (Int) -> Void
    ) {
        self.init(uiv, button, title)
        list.forEach { item in
            let index = list.firstIndex(of: item)!
            add(UIAlertAction(item) { _ in fn(index) })
        }
        finish()
    }

    convenience init(_ uiv: UIViewController,
                     _ title: String,
                     _ button: UIBarButtonItem,
                     _ list: [MenuTitle],
                     _ fn: @escaping (Int) -> Void
    ) {
        self.init(uiv, button, title)
        list.enumerated().forEach { index, title in
            add(UIAlertAction(title.title) { _ in fn(index) })
        }
        finish()
    }

    convenience init(_ uiv: UIViewController,
                     _ button: UIBarButtonItem,
                     _ list: [MenuTitle],
                     _ index: Int,
                     _ menuData: MenuData,
                     _ fn: @escaping (Int) -> Void
    ) {
        let title = list[index].title
        self.init(uiv, button, title)
        let startIdx = MenuTitle.getStart(list, index)
        let count = list[index].count
        (startIdx..<(startIdx + count)).forEach { idx in
            let paramTitle = menuData.paramLabels[idx]
            alert.addAction(UIAlertAction(paramTitle) { _ in fn(idx) })
        }
        finish()
    }

    func add(_ action: UIAlertAction) {
        alert.addAction(action)
    }

    func add(_ action: Action) {
        listActions.append(action)
        alert.addAction(action.uiAlertAction)
    }

    func finish() {
        #if targetEnvironment(macCatalyst)
        if prefersCatalystList {
            // Mac Catalyst presents large UIAlertController action sheets as horizontal alert buttons.
            let popoverList = PopUpListViewController(title: title, message: message, actions: listActions)
            popoverList.modalPresentationStyle = .popover
            popoverList.view.tintColor = ColorCompatibility.label
            if let popoverController = popoverList.popoverPresentationController {
                popoverController.barButtonItem = button
            }
            uiv.present(popoverList, animated: UIPreferences.backButtonAnimation, completion: nil)
            return
        }
        #endif
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.cancel, handler: nil))
        if let popoverController = alert.popoverPresentationController {
            popoverController.barButtonItem = button
        }
        uiv.present(alert, animated: UIPreferences.backButtonAnimation, completion: nil)
    }
}

#if targetEnvironment(macCatalyst)
private final class PopUpListViewController: UITableViewController {

    private let popupTitle: String
    private let message: String
    private let actions: [Action]
    private let cellIdentifier = "PopUpListActionCell"
    private let preferredWidth: CGFloat = 560.0
    private let maxPreferredHeight: CGFloat = 720.0

    init(title: String, message: String, actions: [Action]) {
        self.popupTitle = title
        self.message = message
        self.actions = actions
        super.init(style: .plain)
        updatePreferredContentSize(headerHeight: initialHeaderHeight)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorCompatibility.systemBackground
        tableView.backgroundColor = ColorCompatibility.systemBackground
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        configureHeader()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateHeaderSize()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        actions.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.backgroundColor = ColorCompatibility.systemBackground
        cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textColor = ColorCompatibility.label
        cell.accessoryType = .none
        if indexPath.row == actions.count {
            cell.textLabel?.text = "Dismiss"
            cell.textLabel?.textColor = ColorCompatibility.secondaryLabel
        } else {
            cell.textLabel?.text = actions[indexPath.row].label
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == actions.count {
            dismiss(animated: UIPreferences.backButtonAnimation, completion: nil)
            return
        }
        let action = actions[indexPath.row]
        dismiss(animated: UIPreferences.backButtonAnimation) {
            action.perform()
        }
    }

    private var initialHeaderHeight: CGFloat {
        if popupTitle.isEmpty && message.isEmpty {
            return 0.0
        }
        return 140.0
    }

    private func configureHeader() {
        if popupTitle.isEmpty && message.isEmpty {
            return
        }
        let container = UIView()
        container.backgroundColor = ColorCompatibility.systemBackground
        container.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 12.0, leading: 14.0, bottom: 12.0, trailing: 14.0)

        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8.0
        stack.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: container.layoutMarginsGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: container.layoutMarginsGuide.trailingAnchor),
            stack.topAnchor.constraint(equalTo: container.layoutMarginsGuide.topAnchor),
            stack.bottomAnchor.constraint(equalTo: container.layoutMarginsGuide.bottomAnchor)
        ])

        if !popupTitle.isEmpty {
            let titleLabel = UILabel()
            titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
            titleLabel.textColor = ColorCompatibility.label
            titleLabel.text = popupTitle
            titleLabel.numberOfLines = 0
            stack.addArrangedSubview(titleLabel)
        }

        if !message.isEmpty {
            let messageLabel = UILabel()
            messageLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
            messageLabel.textColor = ColorCompatibility.secondaryLabel
            messageLabel.text = message
            messageLabel.numberOfLines = 0
            stack.addArrangedSubview(messageLabel)
        }

        tableView.tableHeaderView = container
    }

    private func updateHeaderSize() {
        guard let header = tableView.tableHeaderView else { return }
        let targetSize = CGSize(width: tableView.bounds.width, height: UIView.layoutFittingCompressedSize.height)
        let size = header.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        if abs(header.frame.height - size.height) > 0.5 {
            var frame = header.frame
            frame.size.height = size.height
            header.frame = frame
            tableView.tableHeaderView = header
            updatePreferredContentSize(headerHeight: size.height)
        }
    }

    private func updatePreferredContentSize(headerHeight: CGFloat) {
        let contentHeight = headerHeight + CGFloat(actions.count + 1) * 44.0
        preferredContentSize = CGSize(
            width: preferredWidth,
            height: min(maxPreferredHeight, max(260.0, contentHeight))
        )
    }
}
#endif
