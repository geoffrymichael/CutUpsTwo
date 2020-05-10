//
//  DocumentBrowserViewController.swift
//  CutupsTwoUIDocument
//
//  Created by Geoffry Gambling on 5/5/20.
//  Copyright © 2020 Geoffry Gambling. All rights reserved.
//

import UIKit


class DocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        allowsDocumentCreation = true
        allowsPickingMultipleItems = false
        
        // Update the style of the UIDocumentBrowserViewController
        // browserUserInterfaceStyle = .dark
        // view.tintColor = .white
        
        // Specify the allowed content types of your application via the Info.plist.
        
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: UIDocumentBrowserViewControllerDelegate
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
        
        let baseDirectory = URL(fileURLWithPath: NSTemporaryDirectory())
        let filename = baseDirectory.appendingPathComponent("CutUp.txt")
        
        let document = Document(fileURL: filename)
        
        document.save(to: filename, for: .forCreating) { (success) in
            document.close { (success) in
                importHandler(filename, .move)
            }
        }
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        guard let sourceURL = documentURLs.first else { return }
        
        // Present the Document View Controller for the first document that was picked.
        // If you support picking multiple items, make sure you handle them all.
        presentDocument(at: sourceURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        // Present the Document View Controller for the new newly created document
        presentDocument(at: destinationURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
        // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
    }
    
    // MARK: Document Presentation
    
    func presentDocument(at documentURL: URL) {
        
        
        let documentViewController = TextInputController()
        documentViewController.document = Document(fileURL: documentURL)
        documentViewController.modalPresentationStyle = .fullScreen
        
        let navController = UINavigationController(rootViewController: documentViewController)
        
        present(navController, animated: true, completion: nil)
    }
}

