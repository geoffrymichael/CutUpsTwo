//
//  TextInputController.swift
//  CutUpsTwo
//
//  Created by Geoffry Gambling on 1/12/20.
//  Copyright © 2020 Geoffry Gambling. All rights reserved.
//

import UIKit
import Vision
import VisionKit

class ScrapsToShareData: Codable {
    var array: [String] = []
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
}

class TextInputController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate  {
    
    
    
    
     
    var textScraps = ScrapsToShareData()
    

    

    
    let activityIN = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        //Remove the "back" text from the back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        //Account for viewcontroller color depending on load interface style
        if traitCollection.userInterfaceStyle == .light {
                   self.view.backgroundColor = UIColor.white
               } else {
                   self.view.backgroundColor = UIColor.black
               }
        
        
    
        self.lyricTextView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
        let edit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(handleSend))
        self.navigationItem.leftBarButtonItem = edit
        
        
        let randomButton = UIBarButtonItem(title: "Random", style: .plain, target: self, action: #selector(onRandom))
        
        let helpButton = UIBarButtonItem(title: "Help", style: .plain, target: self, action: #selector(onHelp))
        
        let automaticButton = UIBarButtonItem(image: UIImage(systemName: "scissors"), style: .plain, target: self, action: #selector(automaticCut))
        
        
        let cameraButton = UIBarButtonItem(image: UIImage(systemName: "camera"), style: .plain, target: self, action: #selector(onCamera))
        
        let foldInButton = UIBarButtonItem(title: "Fold-in", style: .plain, target: self, action: #selector(foldIn))
        
        
        self.navigationItem.setRightBarButtonItems([helpButton, randomButton, cameraButton, foldInButton, automaticButton], animated: true)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(clipboardChanged),
        name: UIPasteboard.changedNotification, object: nil)        
        
        //Keyboard hide and view observers
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
                
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//        let vc = LyricsController()
//        vc.scrapsSendDelegate = self
        

        setupLyricTextView()
        setupVision()
        
    
    }
    
    @objc func foldIn() {
        let vc = FoldinViewController()
        
        vc.fromTextInput = textScraps.array
        
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: Vision License
    /*
        The Vision implimentation for Cut-ups uses code modified from apple provided source code. Please see license information below
        
       Copyright © 2019 Apple Inc.

       Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

       The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

       THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

     */
    
    
    //MARK: Camera Scanning and Vision Implimentation
    
    //The camera button sends to the documentscanner controller or to photo library to scan and recognize text
    @objc func onCamera() {
//         let documentCameraViewController = VNDocumentCameraViewController()
//               documentCameraViewController.delegate = self
//               present(documentCameraViewController, animated: true)
        
        let prompt = UIAlertController(title: "Choose a Photo",
                                       message: "Please choose a photo.",
                                       preferredStyle: .actionSheet)
        
        //UIAlert view definitions necessary for iPad
        prompt.popoverPresentationController?.sourceView = self.view
        prompt.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY,width: 0,height: 0)
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
                
        func presentCamera(_ _: UIAlertAction) {
            let documentCameraViewController = VNDocumentCameraViewController()
            documentCameraViewController.delegate = self
            present(documentCameraViewController, animated: true)
//            imagePicker.sourceType = .camera
//            self.present(imagePicker, animated: true)
        }
        
        let cameraAction = UIAlertAction(title: "Camera",
                                         style: .default,
                                         handler: presentCamera)
        
        func presentLibrary(_ _: UIAlertAction) {
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true)
        }
        
        let libraryAction = UIAlertAction(title: "Photo Library",
                                          style: .default,
                                          handler: presentLibrary)
        
//        func presentAlbums(_ _: UIAlertAction) {
//            imagePicker.sourceType = .savedPhotosAlbum
//            self.present(imagePicker, animated: true)
//        }
//
//        let albumsAction = UIAlertAction(title: "Saved Albums",
//                                         style: .default,
//                                         handler: presentAlbums)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil)
        
        prompt.addAction(cameraAction)
        prompt.addAction(libraryAction)
//        prompt.addAction(albumsAction)
        prompt.addAction(cancelAction)
        
        self.present(prompt, animated: true, completion: nil)
    }
    
    
    // Vision requests to be performed on each page of the scanned document.
    private var requests = [VNRequest]()
    // Dispatch queue to perform Vision requests.
    private let textRecognitionWorkQueue = DispatchQueue(label: "TextRecognitionQueue",
                                                         qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    private var resultingText = ""
    
    // Setup Vision request as the request can be reused
    private func setupVision() {
        let textRecognitionRequest = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                print("The observations are of an unexpected type.")
                return
            }
            // Concatenate the recognised text from all the observations.
            let maximumCandidates = 1
            for observation in observations {
                guard let candidate = observation.topCandidates(maximumCandidates).first else { continue }
                self.resultingText += candidate.string + "\n"
            }
        }
        // specify the recognition level
        textRecognitionRequest.recognitionLevel = .accurate
        self.requests = [textRecognitionRequest]
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //Adjust scroll view height on keyboard will show
    @objc func handleKeyboardWillShow(notification: NSNotification) {
        print("keyboard shows")
        
        let keyBoardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        textViewBottomanchor?.constant = -keyBoardHeight.height
        
    }
    
    //Back to full screen when keyboard hides
    @objc func handleKeyboardWillHide(notification: NSNotification) {
        let margins = view.layoutMargins
        
        textViewBottomanchor?.constant = margins.bottom
        lyricTextView.layoutIfNeeded()
        
    }
    
    //Change view controller color depending on interface style
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.userInterfaceStyle == .light {
            self.view.backgroundColor = UIColor.white
        } else {
            self.view.backgroundColor = UIColor.black
        }
    }
    
    //Placeholder logic for initial help text underlay
    var placeholderLabel = UILabel()
    
    func textViewDidChange(_ textView: UITextView) {
           placeholderLabel.isHidden = !textView.text.isEmpty
       }
    
   
    //MARK: Laybout textview on first load with temporary instructions underlay and activity indicator
    lazy var lyricTextView: UITextView = {
        let view = UITextView()

        view.font = UIFont.systemFont(ofSize: 16)

        activityIN.center = CGPoint(x: 180, y: 180)
        activityIN.hidesWhenStopped = true
        
        activityIN.style = UIActivityIndicatorView.Style.large
        activityIN.stopAnimating()
        view.addSubview(activityIN)

        
        let placeholderText =
                                """
                                Type or copy/paste in some text.

                                Click on the scissors to cut the text by specific sizes.

                                Or click Fold-in to "fold" two pages of texts together. 

                                Click on edit to rearrange the chunks into new and intersting ideas.

                                Click on the camera to scan in some physical text if you like.

                                Click on random to get a random snippet of a passage from an old book. (This feature requires that you be connected to the internet)

                                Blend it all together and cut-it-up to make something new. How fun.
                                
                                Click the ⏍ button to export your Cut-up to your favorite notes app, a text, etc.
                                
                                Click on Help for more detailed instructions.

                                

                                """

        
        placeholderLabel.text = placeholderText
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: 13)
        placeholderLabel.sizeToFit()
        
        placeholderLabel.numberOfLines = 0
        view.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (view.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !view.text.isEmpty
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
    
        
        view.delegate = self

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    
    
    //ToDo, perhaps impliment landscape orientation contextual changes
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { context in
            
            print(UIDevice.current.orientation.isLandscape)
            
        })
    }
    
    
    
    
    //MARK: Layout initial lyric view text box
    var textViewBottomanchor: NSLayoutConstraint?
    
    func setupLyricTextView() {

        let margins = view.layoutMarginsGuide

        
        view.addSubview(lyricTextView)
        
        NSLayoutConstraint.activate([
            lyricTextView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            lyricTextView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            lyricTextView.widthAnchor.constraint(equalTo: margins.widthAnchor),
            lyricTextView.topAnchor.constraint(equalTo: margins.topAnchor),
//            lyricTextView.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        
        ])
        
        textViewBottomanchor = lyricTextView.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        textViewBottomanchor?.isActive = true
        
        placeholderLabel.widthAnchor.constraint(equalTo: lyricTextView.widthAnchor).isActive = true
        
        
    }
    
   
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @objc func clipboardChanged(){
        let pasteboardString: String? = UIPasteboard.general.string
        if let theString = pasteboardString {
//            scrap = theString
//            scrapsToShare.append(theString)
            
            textScraps.array.append(theString)
            
            
            
        }
    }
    
    @objc func handleSend() {
        let textVC = LyricsController()
        
//        textVC.scrapsSendDelegate = self


        
        textVC.lyricScraps = textScraps.array
        
        print(lyricTextView.text!)
        
        


        navigationController?.pushViewController(textVC, animated: true)
        
        
    }
    
    
    //MARK: Function to retrieve random passages from project gutenberg
    @objc func onRandom() {
            print("Random was pressed")
            
           
            
            let rando = Int.random(in: 0...1600)
            
            let url = "http://www.gutenberg.org/cache/epub/\(rando)/pg\(rando).txt"
            let session = URLSession.shared
            
        activityIN.startAnimating()
            session.dataTask(with: URL(string: url)!) { (data, response, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        self.lyricTextView.text = "Cut-ups error. Something went wrong, please make sure you are conected to the internet to use the random feature."
                        self.activityIN.stopAnimating()
                    }
                } else {
                    let str = String(decoding: data!, as: UTF8.self)
                    
                    
                    let randomInt = Int.random(in: 400...str.count - 301)
                                                                             
                    let substring = str[randomInt..<randomInt + 300]
                    
                    
                    
                    let myString = str.components(separatedBy: .newlines)
                    
                    // Print source author and work of gutenberg text
                    print(myString[0])

                    DispatchQueue.main.async {
                        self.activityIN.stopAnimating()
                        self.placeholderLabel.text = ""
                        
                        self.lyricTextView.text = substring
                       

                    }
                    
                    
                }
            }.resume()
    }
    
    
    
    
    //MARK: Main function to choose how sections of text will be split
    @objc func automaticCut() {
        
        
        
        let prompt = UIAlertController(title: "Choose How Finely You Want to Split Your Text",
                                       message: nil,
                                       preferredStyle: .actionSheet)
        
        //UIAlert view definitions necessary for iPad
        prompt.popoverPresentationController?.sourceView = self.view
        prompt.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY,width: 0,height: 0)
        
        
        func byLine(_ _: UIAlertAction) {
            lyricTextView.text.enumerateLines { line, _ in
                
                self.textScraps.array.append(line)
                
            }
            
            
            lyricTextView.text = ""
        }
        
        //Split text by single words
        func byWord(_ _: UIAlertAction) {
            
            let wordArray = lyricTextView.text.components(separatedBy: " ")
            
            for (_, word) in wordArray.enumerated() {
                textScraps.array.append(word)
            }
            
            
            lyricTextView.text = ""
        }
        
        func byFiveWords(_ _: UIAlertAction) {
            
            //Replace new lines with spaces
            let newString = lyricTextView.text.replacingOccurrences(of: "\n", with: " ", options: .literal, range: nil)
            
            //Use array chunk extension to split by chosen iterator
            let array = newString.split(separator: " ").chunked(into: 5)
            
            //Append the newly defined lines into the data array
            for (_ , thing) in array.enumerated() {
                textScraps.array.append(thing.joined(separator: " "))
                print(thing)
            }
            
            lyricTextView.text = ""
            
        }
        
        func byThreeWords(_ _: UIAlertAction) {
            
            //Replace new lines with spaces
            let newString = lyricTextView.text.replacingOccurrences(of: "\n", with: " ", options: .literal, range: nil)
            
            //Use array chunk extension to split by chosen iterator
            let array = newString.split(separator: " ").chunked(into: 3)
            
            //Append the newly defined lines into the data array
            for (_ , thing) in array.enumerated() {
                textScraps.array.append(thing.joined(separator: " "))
                print(thing)
            }
            
            lyricTextView.text = ""
            
        }
        
        
        let byLineAction = UIAlertAction(title: "Individual Lines",
                                         style: .default,
                                         handler: byLine)
        
        let byWordAction = UIAlertAction(title: "Single Words", style: .default, handler: byWord)
        
        let byFiveWordsAction = UIAlertAction(title: "Every Fifth Word", style: .default, handler: byFiveWords)
        
        let byThreeWordsAction = UIAlertAction(title: "Every Third Word", style: .default, handler: byThreeWords)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil)
        
        prompt.addAction(byLineAction)
        prompt.addAction(byWordAction)
        prompt.addAction(byFiveWordsAction)
        prompt.addAction(byThreeWordsAction)
        prompt.addAction(cancelAction)
        
        self.present(prompt, animated: true, completion: nil)
        
        
        
        
        
    }
    
    
    @objc func onHelp() {
        print("Help Pressed")
        
        let vc = HelpViewController()
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
    
}

//Extension for having keyboard dissapear on "done" button click
extension UITextView {
    
    func addDoneButton(title: String, target: Any, selector: Selector) {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))//1
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)//3
        toolBar.setItems([flexible, barButton], animated: false)//4
        self.inputAccessoryView = toolBar//5
    }
}

// MARK: VNDocumentCameraViewControllerDelegate
// For vision text scanning via Document Scan camera
extension TextInputController: VNDocumentCameraViewControllerDelegate {
    
    public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        // Clear any existing text.
        lyricTextView.text = ""
        // dismiss the document camera
        controller.dismiss(animated: true)
        
        activityIN.isHidden = false
        activityIN.startAnimating()
        
        textRecognitionWorkQueue.async {
            self.resultingText = ""
            for pageIndex in 0 ..< scan.pageCount {
                let image = scan.imageOfPage(at: pageIndex)
                if let cgImage = image.cgImage {
                    let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                    
                    do {
                        try requestHandler.perform(self.requests)
                    } catch {
                        print(error)
                    }
                }
                self.resultingText += "\n\n"
            }
            DispatchQueue.main.async(execute: {
                self.lyricTextView.text = self.resultingText
                self.placeholderLabel.text = ""
                self.activityIN.isHidden = true
            })
        }

    }
}


//Extension for photo library vision text scan
extension TextInputController: UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
       
        
        lyricTextView.text = ""
        // dismiss the document camera
        dismiss(animated: true, completion: nil)
        
        activityIN.isHidden = false
        activityIN.startAnimating()
        
        textRecognitionWorkQueue.async {
            self.resultingText = ""
            
            let image: UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
                if let cgImage = image.cgImage {
                    let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                    
                    do {
                        try requestHandler.perform(self.requests)
                    } catch {
                        print(error)
                    }
                }
                self.resultingText += "\n\n"
            
            DispatchQueue.main.async(execute: {
                self.lyricTextView.text = self.resultingText
                self.placeholderLabel.text = ""
                self.activityIN.isHidden = true
            })
        }
    }
    
    
}



//String Extension to allow for selecting string sections via integers
extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}

//MARK: Array extension to split an array into chosen denominations. Used in this app for selected cut-ups section sizes
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
