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
        navigationController?.pushViewController(scanDocumentViewController, animated: true)
    }
    
    @IBAction func faceTapped(_ sender: UIButton) {
        guard let scanFaceViewController = libStoryboard.instantiateViewController(withIdentifier: "scanFaceViewController") as? ScanFaceViewController else { return }
        navigationController?.pushViewController(scanFaceViewController, animated: true)
        
    }
}
