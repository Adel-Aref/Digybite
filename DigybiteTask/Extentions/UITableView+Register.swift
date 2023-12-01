//
//  UITableView+Register.swift
//  DigybiteTask
//
//  Created by Adel Aref on 30/11/2023.
//

import UIKit

protocol IdentifiableCell: AnyObject {
    static var cellIdentifier: String { get }
}

extension UITableViewCell: IdentifiableCell {
    static var cellIdentifier: String {
        "\(self)"
    }
}

extension UITableViewHeaderFooterView: IdentifiableCell {
    static var cellIdentifier: String {
        "\(self)"
    }
}

extension UITableView {
    
    func dequeueReusableHeader<T: IdentifiableCell>(with cell: T.Type) -> T? {
        dequeueReusableHeaderFooterView(withIdentifier: cell.cellIdentifier) as? T
    }

    func dequeueHeader<Header: UITableViewHeaderFooterView>() -> Header {
        let identifier = String(describing: Header.self)
        guard let header = self.dequeueReusableHeaderFooterView(withIdentifier: identifier) as? Header else {
            fatalError("Error in header")
        }

        return header
    }
    
    func register<T>(cell: T.Type) where T: UITableViewCell {
        register(cell.nib, forCellReuseIdentifier: cell.cellIdentifier)
    }

    func dequeueReusableCell<T: IdentifiableCell>(with cell: T.Type) -> T? {
        dequeueReusableCell(withIdentifier: cell.cellIdentifier) as? T
    }

    func dequeue<Cell: UITableViewCell>() -> Cell {
        let identifier = String(describing: Cell.self)
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier) as? Cell else {
            fatalError("Error in cell")
        }

        return cell
    }

    ///Get visible cell height
    var visibleCellsHeight: CGFloat {
        self.setNeedsLayout()
        self.layoutIfNeeded()
        return visibleCells.reduce(0) {
            $0 + $1.frame.height
        }
    }


    /// Check if cell at the specific section and row is visible
    /// - Parameters:
    /// - section: an Int reprenseting a UITableView section
    /// - row: and Int representing a UITableView row
    /// - Returns: True if cell at section and row is visible, False otherwise
    func isCellVisible(section: Int, row: Int) -> Bool {
        guard let indexes = self.indexPathsForVisibleRows else {
            return false
        }
        return indexes.contains {
            $0.section == section && $0.row == row
        }
    }

    func update(action: (() -> ())? = nil) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0) { [weak self] in
                guard let self = self else {
                    return
                }
                self.beginUpdates()
                action?()
                self.endUpdates()
                self.layoutIfNeeded()
            }
        }
    }
}

extension UITableView {
    func reloadDataWithSavingContentOffset() {
        let contentOffset = self.contentOffset
        self.reloadData()
        self.layoutIfNeeded()
        self.setContentOffset(contentOffset, animated: false)
    }
    
    func reloadTableRowsWithSavingContentOffset(at indexPaths: [IndexPath]) {
        UIView.performWithoutAnimation {
            let contentOffset = self.contentOffset
            self.reloadRows(at: indexPaths, with: .none)
            self.setContentOffset(contentOffset, animated: false)
        }
    }
    
    func reloadTableSectionsWithoutAnimation(_ sections: IndexSet) {
        UIView.performWithoutAnimation {
            let loc = self.contentOffset
            self.reloadSections(sections, with: .none)
            self.contentOffset = loc
        }
    }
}

extension UIView {
    
    static var nib: UINib {
        return UINib(nibName: "\(self)", bundle: nil)
    }
    
    static func instantiateFromNib() -> Self? {
        
        func instanceFromNib<T: UIView>() -> T? {
            return UINib(nibName: "\(self)", bundle: nil).instantiate() as? T
        }
        return instanceFromNib()
    }
    
}
extension UINib {
    func instantiate() -> Any? {
        return self.instantiate(withOwner: nil, options: nil).first
    }
}
