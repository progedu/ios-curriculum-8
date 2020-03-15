//
//  MessageCollectionViewController.swift
//  TodoLog
//
//  Created by Kouki Saito on 12/1/19.
//  Copyright © 2019 Kouki Saito. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class MessageCollectionViewController: UICollectionViewController {
    var messageList = [
        Chat(message: "買い物、忘れないように", createdAt: Date()),
        Chat(message: "カレーを作るから、鶏肉と玉ねぎ、それと人参", createdAt: Date()),
        Chat(message: "ジャガイモとルーは家に余っているから大丈夫", createdAt: Date()),
        Chat(message: "ついでに洗剤も買ってきてね〜", createdAt: Date()),
        Chat(message: "人参もらったからいらなくなった！", createdAt: Date()),
        Chat(message: "買うものは、鶏肉、玉ねぎ", createdAt: Date()),
        Chat(message: "あとは洗剤！", createdAt: Date()),
        Chat(message: "食器洗いの洗剤ね！", createdAt: Date())
    ]

    lazy var textInputView: TextInputView! = {
        // swiftlint:disable:next force_cast
        let inputView = Bundle.main.loadNibNamed("TextInputView", owner: self, options: nil)?.first as! TextInputView
        inputView.messageSentCallback = { [weak self] message in
            guard let self = self else { return }
            let indexPath = IndexPath(row: self.messageList.count, section: 0)
            self.messageList.append(Chat(message: message, createdAt: Date()))
            self.collectionView.insertItems(at: [indexPath])
        }
        return inputView
    }()

    override var inputAccessoryView: UIView? {
        return textInputView
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionViewLayout.invalidateLayout()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messageList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MessageCollectionViewCell
        cell.configureCell(chat: messageList[indexPath.row])
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}


extension MessageCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell = collectionView.dataSource?.collectionView(collectionView, cellForItemAt: indexPath) else {
            return .zero
        }

        cell.bounds.size = CGSize(
            width: collectionView.bounds.width,
            height: 0
        )
        cell.layoutIfNeeded()

        let size = cell.systemLayoutSizeFitting(
            UIView.layoutFittingExpandedSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel)

        return size
    }
}
