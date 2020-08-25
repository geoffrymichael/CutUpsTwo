//
//  LyricsController.swift
//  CutUpsTwo
//
//  Created by Geoffry Gambling on 1/13/20.
//  Copyright © 2020 Geoffry Gambling. All rights reserved.
//

import UIKit

class FilesManager {
    enum Error: Swift.Error {
        case fileAlreadyExists
        case invalidDirectory
        case writtingFailed
        case fileNotExists
        case readingFailed
    }
    let fileManager: FileManager
    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }
    func save(fileNamed: String, data: Data) throws {
        guard let url = makeURL(forFileNamed: fileNamed) else {
            throw Error.invalidDirectory
        }
       
        do {
            try data.write(to: url, options: .atomicWrite)
        } catch {
            debugPrint(error)
            throw Error.writtingFailed
        }
    }
    private func makeURL(forFileNamed fileName: String) -> URL? {
        
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(fileName)
    }
    
    func read(fileNamed: String) throws -> Data {
        guard let url = makeURL(forFileNamed: fileNamed) else {
            throw Error.invalidDirectory
        }
        //Read was failing here at check if file exists. I presume i am cchecking in the wrong location as it appears the do statement below it is able to retrieve data. 
//        guard fileManager.fileExists(atPath: url.absoluteString) else {
//            throw Error.fileNotExists
//        }
        do {
            return try Data(contentsOf: url)
        } catch {
            debugPrint(error)
            throw Error.readingFailed
        }
    }
    
}

//protocol SendScrapsArrayDelegate: class {
//    func onSend(scraps: [String])
//}

class LyricsController: UITableViewController, UITableViewDragDelegate, UITableViewDropDelegate {
    
//    var scraps = ["If there is a bustle in your headgrow", "Dont't be alarmed then", "It's only a sprinkling for the may queen", "There's a lady who's sure", "And she's buying a stairway to heaven", "Rings of smoke through the trees"]
    
//    weak var scrapsSendDelegate: SendScrapsArrayDelegate?
    
    
    let scrapCell = "scrapCell"
    
    var scrapsToShareData = ScrapsToShareData()
    
    lazy var lyricScraps = scrapsToShareData.array
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Shuffle", style: .plain, target: self, action: #selector(onShuffle))
        
//        let shuffleButton = UIBarButtonItem(title: "Shuffle", style: .done, target: self, action: #selector(onShuffle))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(back))
        
        
        let shuffleButton = UIBarButtonItem(image: UIImage(systemName: "shuffle"), style: .plain, target: self, action: #selector(onShuffle))
        
//        let shareButton = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(onShare))
        
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(onShare))
        
//        let clearButton = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(onClear))
        
        let clearButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(onClear))
        
        let saveButton = UIBarButtonItem(image: UIImage(systemName: "arrow.down.doc.fill"), style: .plain, target: self, action: #selector(onSave))
        
        let loadButton = UIBarButtonItem(image: UIImage(systemName: "arrow.up.doc.fill"), style: .plain, target: self, action: #selector(onLoad))
        
        
        self.navigationItem.setRightBarButtonItems([clearButton,shareButton,shuffleButton, saveButton, loadButton], animated: true)
        
        //This is needed to account for safe area. For now, the app is portrait mode only so this is commented out
//        if UIDevice.current.orientation.isLandscape {
//            tableView.contentInset = UIEdgeInsets(top: 0, left: UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.left ?? 0.0, bottom: 0, right: 0.0)
//        }
        
        
        tableView.dragDelegate = self
        tableView.dragInteractionEnabled = true
        tableView.dropDelegate = self
        
        
        tableView.register(ScrapTableViewCell.self, forCellReuseIdentifier: scrapCell)
    }
    
    
    @objc func back() {
        print("back button was pressed" )
        
        let vc = TextInputController()
        
        vc.textScraps.array = lyricScraps
        
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    @objc func onShuffle() {
        
        tableView.performBatchUpdates( { lyricScraps.shuffle() } )
         
        tableView.reloadData()
    }
    
    @objc func onShare() {
        print("shared")
        
        print(lyricScraps.joined())
        
        let joinedScraps = lyricScraps.joined(separator: "\n")
        
        let activityVC = UIActivityViewController(activityItems: [joinedScraps], applicationActivities: nil)
        
        
        //Ipad share support
        if let popoverController = activityVC.popoverPresentationController {
            popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
            popoverController.sourceView = self.view
            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }
        

        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @objc func onClear() {
        
        let alert = UIAlertController(title: "Are you sure you want to delete your Cut-Up?", message: "If you haven't shared it, your data will be lost", preferredStyle: .alert)

        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        self.present(alert, animated: true)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            self.lyricScraps.removeAll()
            self.tableView.reloadData()
        }))
        
        
        
         
    }
    
    @objc func onSave() {
        
                
        let scrapsShare = ScrapsToShareData()
        
        scrapsShare.array = lyricScraps
        
        let fileManager = FilesManager()
        
        
        do {
            let data = scrapsShare.json
            print(data as Any)
            try fileManager.save(fileNamed: "EditingBoard", data: data!)
        } catch {
            print("Something went wrong")
        }
        
        
        
        print("save was pressed")
        
   
    }
    
    @objc func onLoad() {
        let fileManager = FilesManager()
        
        do {
            let data = try fileManager.read(fileNamed: "EditingBoard")
            
            let decoder = JSONDecoder()
            
            let loadedLines = try? decoder.decode(ScrapsToShareData.self, from: data)
            
            print(loadedLines as Any, "This is your loaded line")
            
            print(data, "well at least its not an error")
        } catch {
            print(error)
        }
        
        
        
        
    }
    
    
    //To account for safe area in landscape mode. for now the app is portrait mode only so this is commented out
//    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
//        coordinator.animate(alongsideTransition: { context in
//            
//            if UIDevice.current.orientation.isLandscape {
//                self.tableView.contentInset = UIEdgeInsets(top: 0, left: UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.left ?? 0.0, bottom: 0, right: 0.0)
//                self.tableView.reloadData()
//                
//            }
//            
//        })
//    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return lyricScraps.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scrapCell", for: indexPath) as! ScrapTableViewCell
        
        cell.labelText = lyricScraps[indexPath.row]
        
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
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//
//
//            self.dismiss(animated: true, completion: {
//                print("something")
//                self.scrapsSendDelegate?.onSend(scraps: self.lyricScraps)
//            })
//
//    }
    
    //Delete functionality
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        print("Deleted")

        self.lyricScraps.remove(at: indexPath.row)
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
                    
                    tableView.performBatchUpdates( { lyricScraps.swapAt(sourceIndexPath.item, destinationIndexPath.item) ; tableView.deleteRows(at: [sourceIndexPath], with: .fade); tableView.insertRows(at: [destinationIndexPath], with: .fade) } )
                    
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




