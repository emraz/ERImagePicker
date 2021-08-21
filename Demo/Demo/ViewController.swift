//
//  ViewController.swift
//  Demo
//
//  Created by Mahmudul Hasan on 2020/03/31.
//  Copyright © 2020 Matrix Solution Ltd. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController {

    private lazy var imagePicker = ERImagePicker()
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }

    @IBAction func cameraButtonPressed(_ sender: Any) {
        imagePicker.presentERImagePicker(from: self, pickerType: .commonCamera)
    }
    
    @IBAction func photoCameraButtonPressed(_ sender: Any) {
        imagePicker.presentERImagePicker(from: self, pickerType: .photoCamera)
    }
    
    @IBAction func videoCameraButtonPressed(_ sender: Any) {
        imagePicker.presentERImagePicker(from: self, pickerType: .videoCamera)
    }
    
    @IBAction func photoLibraryButtonPressed(_ sender: Any) {
        imagePicker.presentERImagePicker(from: self, pickerType: .photoVideoLibrary)
    }
    
    @IBAction func onlyPhotosButtonPressed(_ sender: Any) {
        imagePicker.presentERImagePicker(from: self, pickerType: .photoLibrary)
    }
    
    @IBAction func onlyVideosButtonPressed(_ sender: Any) {
        imagePicker.presentERImagePicker(from: self, pickerType: .videoLibrary)
    }
}

extension ViewController: ERImagePickerDelegate {
    func ERImagePickerDidCancel() {
        // Cancel
    }
    
    func ERImagePickerDelegate(didSelect image: UIImage, delegatedForm: ERImagePicker) {
        // Done
    }

}

