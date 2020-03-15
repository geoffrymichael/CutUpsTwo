//
//  LyricsController.swift
//  CutUpsTwo
//
//  Created by Geoffry Gambling on 1/13/20.
//  Copyright © 2020 Geoffry Gambling. All rights reserved.
//

import UIKit

protocol SendScrapsArrayDelegate: class {
    func onSend(scraps: [String])
}

class LyricsController: UITableViewController, UITableViewDragDelegate, UITableViewDropDelegate {
    
//    var scraps = ["If there is a bustle in your headgrow", "Dont't be alarmed then", "It's only a sprinkling for the may queen", "There's a lady who's sure", "And she's buying a stairway to heaven", "Rings of smoke through the trees"]
    
    weak var scrapsSendDelegate: SendScrapsArrayDelegate?
    
    
    let scrapCell = "scrapCell"
    
    var scrapsToShareData = ScrapsToShareData()
    
    lazy var scraps = scrapsToShareData.array
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Shuffle", style: .plain, target: self, action: #selector(onShuffle))
        
        let shuffleButton = UIBarButtonItem(title: "Shuffle", style: .plain, target: self, action: #selector(onShuffle))
        
        let shareButton = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(onShare))
        
        self.navigationItem.setRightBarButtonItems([shareButton,shuffleButton], animated: true)
        
        //This is needed to account for safe area
        if UIDevice.current.orientation.isLandscape {
            tableView.contentInset = UIEdgeInsets(top: 0, left: UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.left ?? 0.0, bottom: 0, right: 0.0)
        }
        
        
        tableView.dragDelegate = self
        tableView.dragInteractionEnabled = true
        tableView.dropDelegate = self
        
        
        tableView.register(ScrapTableViewCell.self, forCellReuseIdentifier: scrapCell)
    }
    
    @objc func onShuffle() {
        print("Shuffled")
        tableView.performBatchUpdates( { scraps.shuffle() } )
         
        tableView.reloadData()
    }
    
    @objc func onShare() {
        print("shared")
        
        let joinedPoem = scrapsToShareData.array.joined()
        print(joinedPoem)
        
        let activityVC = UIActivityViewController(activityItems: [joinedPoem], applicationActivities: nil)
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { context in
            
            if UIDevice.current.orientation.isLandscape {
                self.tableView.contentInset = UIEdgeInsets(top: 0, left: UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.left ?? 0.0, bottom: 0, right: 0.0)
                self.tableView.reloadData()
                
            }
            
        })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return scraps.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scrapCell", for: indexPath) as! ScrapTableViewCell
        
        cell.labelText = scraps[indexPath.row]
        
        return cell
    }
    
    private func dragItems(at indexPath: IndexPath) -> [UIDragItem] {
        
            if let imageCell = (tableView.cellForRow(at: indexPath) as? ScrapTableViewCell)?.labelText {
                let dragItem = UIDragItem(itemProvider: NSItemProvider(object: imageCell as NSItemProviderWriting))
                dragItem.localObject = imageCell
                return [dragItem]
            } else {
                return []
            }
    }
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return dragItems(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if tableView.hasActiveDrag {
            if session.items.count > 1 {
                return UITableViewDropProposal(operation: .cancel)
            } else {
                return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            }
        } else {
            return UITableViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
        }
    }
    
    //TODO: This is to do stuff when the view dismisses. Currently it is empty 
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent {
            
            self.dismiss(animated: true, completion: {
                print("something")
                self.scrapsSendDelegate?.onSend(scraps: self.scraps)
            })
        }
    }
    
    //Delete functionality
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        print("Deleted")

        self.scraps.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
      }
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        let destinationIndexPath: IndexPath
        
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            // Get last index path of table view.
            let section = tableView.numberOfSections - 1
            let row = tableView.numberOfRows(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        
        //Drop implimentation for local context
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath {
                if let lyric = item.dragItem.localObject as! NSString? {
//                    tableView.performBatchUpdates( { scraps.remove(at: sourceIndexPath.item); scraps.insert(lyric as String, at: destinationIndexPath.item) ; tableView.deleteRows(at: [sourceIndexPath], with: .automatic); tableView.insertRows(at: [destinationIndexPath], with: .automatic) } )
                    
                    tableView.performBatchUpdates( { scraps.swapAt(sourceIndexPath.item, destinationIndexPath.item) ; tableView.deleteRows(at: [sourceIndexPath], with: .automatic); tableView.insertRows(at: [destinationIndexPath], with: .automatic) } )
                    
                    print(lyric)
                    tableView.reloadData()
                }
                
            }
        
        }
    }
    
    
}

extension Int {
    
    ///
    /// Get a random number between `self` and 0. If `self` is zero,
    /// zero will be returned.
    ///
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        }
        else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        }
        else {
            return 0
        }
        
    }
}

extension MutableCollection {
    
    /// Shuffle the elements of `self` in-place.
    mutating func shuffle() {
        
        // Shuffle logic retrieved from:
        // https://stackoverflow.com/questions/37843647/shuffle-array-swift-3/37843901
        
        // Empty and single-element collections don't shuffle
        if count < 2 { return }
        
        // Shuffle them
        for i in indices.dropLast() {
            let diff = distance(from: i, to: endIndex)
            let j = index(i, offsetBy: numericCast(arc4random_uniform(numericCast(diff))))
            swapAt(i, j)
        }
    }
}


#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct LyricsPreview: PreviewProvider {
    
    static var previews: some View {
//        Text("preview view")
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        func makeUIViewController(context: UIViewControllerRepresentableContext<LyricsPreview.ContainerView>) -> UIViewController {
            return LyricsController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<LyricsPreview.ContainerView>) {
            
        }
  
        
    }
    
}

//@available(iOS 13.0, *)
//struct SwiftLeeViewController_Preview: PreviewProvider {
//    static var previews: some View {
//        SwiftLeeViewRepresentable()
//    }
//}
#endif
