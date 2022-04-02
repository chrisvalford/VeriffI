/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 View controller from which to invoke the document scanner.
 */

import UIKit
import VeriffLib
import VisionKit
import Vision

class HomeViewController: UIViewController {
    
    @IBOutlet weak var scanDocumentButton: UIButton!
    @IBOutlet weak var facelandmarkButton: UIButton!
    @IBOutlet weak var noCameraView: NoCameraView!
    
    lazy var libStoryboard: UIStoryboard = {
        let storyboard = UIStoryboard(name: "SDK", bundle: VeriffLib.libBundle)
        return storyboard
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            scanDocumentButton.isEnabled = false
            facelandmarkButton.isEnabled = false
            noCameraView.title = "Your device doesn't have a camera."
            noCameraView.message = "You need a camera to scan your documents and face."
            noCameraView.isHidden = false
            noCameraView.layoutSubviews()
        }
    }
    
    @IBAction func documentTapped(_ sender: UIButton) {
        guard let scanDocumentViewController = libStoryboard.instantiateViewController(withIdentifier: "scanDocumentViewController") as? ScanDocumentViewController else { return }
        scanDocumentViewController.modalPresentationStyle = .fullScreen
        scanDocumentViewController.modalTransitionStyle = .coverVertical
        show(scanDocumentViewController, sender: self)
        //self.present(scanDocumentViewController, animated: false, completion: nil)
    }
    
    @IBAction func faceTapped(_ sender: UIButton) {
        guard let scanFaceViewController = libStoryboard.instantiateViewController(withIdentifier: "scanFaceViewController") as? ScanFaceViewController else { return }
        scanFaceViewController.modalPresentationStyle = .fullScreen
        scanFaceViewController.modalTransitionStyle = .coverVertical
        self.present(scanFaceViewController, animated: true, completion: nil)
    }
}
