//
//  MessageCollectionViewController.swift
//  TodoLog
//
//  Created by Kouki Saito on 12/1/19.
//  Copyright © 2019 Kouki Saito. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "Cell"

class MessageCollectionViewController: UICollectionViewController {

    var todo: Todo!

    private var managedObjectContext: NSManagedObjectContext!
    private var fetchedResultsController: NSFetchedResultsController<Chat>!
    private var blocks: [() -> Void] = []

    lazy var textInputView: TextInputView! = {
        // swiftlint:disable:next force_cast
        let inputView = Bundle.main.loadNibNamed("TextInputView", owner: self, options: nil)?.first as! TextInputView
        inputView.messageSentCallback = { [weak self] message in
            guard let self = self else { return }
            let chat = Chat(context: self.managedObjectContext)
            chat.message = message
            chat.createdAt = Date()
            self.todo.addToChats(chat)
            try? self.managedObjectContext.save()
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
        managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Chat> = Chat.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "todo == %@", todo)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]

        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
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
        return fetchedResultsController.sections!.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections![section].numberOfObjects
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MessageCollectionViewCell
        let chat = fetchedResultsController.object(at: indexPath)
        cell.configureCell(chat: chat)
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
            CGSize(width: cell.bounds.width, height: UIView.layoutFittingExpandedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel)

        return size
    }
}

extension MessageCollectionViewController: NSFetchedResultsControllerDelegate {

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            blocks.append { [weak self] in
                self?.collectionView.deleteItems(at: [indexPath!])
            }
        case .insert:
            blocks.append { [weak self] in
                self?.collectionView.insertItems(at: [newIndexPath!])
            }
        case .move:
            blocks.append { [weak self] in
                self?.collectionView.moveItem(at: indexPath!, to: newIndexPath!)
            }
        case .update:
            blocks.append { [weak self] in
                self?.collectionView.reloadItems(at: [indexPath!])
            }
        @unknown default:
            break
        }
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        blocks.removeAll()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.performBatchUpdates({
            blocks.forEach { (block) in
                block()
            }
        }, completion: nil)
    }
}
