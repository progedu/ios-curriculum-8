//
//  MessageCollectionViewCell.swift
//  TodoLog
//
//  Created by Kouki Saito on 1/14/20.
//  Copyright © 2020 Kouki Saito. All rights reserved.
//

import UIKit

class MessageCollectionViewCell: UICollectionViewCell {
    @IBOutlet var message: UILabel!

    func configureCell(chat: Chat) {
        message.text = chat.message
    }
}
