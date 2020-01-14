//
//  TodoTableViewCell.swift
//  TodoLog
//
//  Created by Kouki Saito on 1/14/20.
//  Copyright © 2020 Kouki Saito. All rights reserved.
//

import UIKit

class TodoTableViewCell: UITableViewCell {
    @IBOutlet var title: UILabel!
    @IBOutlet var caption: UILabel!
    @IBOutlet var checkBox: CheckBox!

    func configureCell(todo: Todo) {
        title.text = todo.title
        caption.text = todo.caption
        checkBox.checked = todo.done
    }
}
