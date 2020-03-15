//
//  TextInputView.swift
//  TodoLog
//
//  Created by Kouki Saito on 3/15/20.
//  Copyright © 2020 Kouki Saito. All rights reserved.
//

import UIKit

class TextInputView: UIView, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.delegate = self
        }
    }
    private let maxHeight: CGFloat = 150
    private let minHeight: CGFloat = 50
    private let padding: CGFloat = 8

    var messageSentCallback: ((String) -> Void)?

    override var intrinsicContentSize: CGSize {
        // textViewのsizeをsizeThatFitsで計算するために、isScrollEnabeledをfalseにする必要がある
        textView.isScrollEnabled = false
        let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: maxHeight))
        let heightWithPadding = size.height + padding*2
        if heightWithPadding <= maxHeight {
            return CGSize(width: bounds.width, height: max(heightWithPadding, minHeight))
        } else {
            textView.isScrollEnabled = true
            return CGSize(width: bounds.width, height: maxHeight)
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        invalidateIntrinsicContentSize()
    }

    @IBAction func sendButtonTapped(_ sender: UIButton) {
        textView.resignFirstResponder()
        messageSentCallback?(textView.text)
        textView.text = ""
        invalidateIntrinsicContentSize()
    }
}
