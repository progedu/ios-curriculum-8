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
    private var checkBoxModifiedCallback: ((Bool) -> Void)?

    @IBAction func checkBoxTapped(_ sender: CheckBox) {
        checkBox.toggle()
        checkBoxModifiedCallback?(sender.checked)
    }

    func configureCell(todo: Todo, checkBoxModifiedCallback: @escaping (Bool) -> Void) {
        title.text = todo.title
        caption.text = todo.caption
        checkBox.checked = todo.done
        self.checkBoxModifiedCallback = checkBoxModifiedCallback
    }
}
