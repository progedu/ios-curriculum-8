//
//  CheckBox.swift
//  TodoLog
//
//  Created by Kouki Saito on 5/27/19.
//  Copyright © 2019 Kouki Saito. All rights reserved.
//

import UIKit

@IBDesignable
final class CheckBox: UIControl {

    @IBInspectable var checked: Bool = false

    override func draw(_ rect: CGRect) {
        let bundle = Bundle(for: CheckBox.self)
        let image: UIImage
        if checked {
            image = UIImage(named: "check_true", in: bundle, compatibleWith: nil)!
        } else {
            image = UIImage(named: "check_false", in: bundle, compatibleWith: nil)!
        }
        image.draw(in: bounds)
    }

    func toggle() {
        self.checked = !checked
        setNeedsDisplay()
    }
}
