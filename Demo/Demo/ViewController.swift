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


    private weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "camera", style: .plain, target: self,
                                                           action: #selector(cameraButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "photo", style: .plain, target: self,
                                                           action: #selector(photoButtonTapped))

        let imageView = UIImageView(frame: CGRect(x: 40, y: 80, width: 200, height: 200))
        imageView.backgroundColor = .lightGray
        view.addSubview(imageView)
        self.imageView = imageView
    }

    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        imagePicker.present(parent: self, sourceType: sourceType, mediaTypes: [])
    }

    @objc func photoButtonTapped(_ sender: UIButton) {
        imagePicker.photoGalleryAsscessRequest()
    }
    @objc func cameraButtonTapped(_ sender: UIButton) {
        imagePicker.cameraAsscessRequest()
    }
}

extension ViewController: ERImagePickerDelegate {
    
    func ERImagePickerDelegate(canUseCamera accessIsAllowed: Bool, delegatedForm: ERImagePicker) {
        if accessIsAllowed { presentImagePicker(sourceType: .camera) }
    }
    func ERImagePickerDelegate(canUseGallery accessIsAllowed: Bool, delegatedForm: ERImagePicker) {
        if accessIsAllowed { presentImagePicker(sourceType: .photoLibrary) }
    }
    func ERImagePickerDelegate(didSelect image: UIImage, delegatedForm: ERImagePicker) {
        imageView.image = image
        imagePicker.dismiss()
    }
    
    func ERImagePickerDelegate(didCancel delegatedForm: ERImagePicker) {
        imagePicker.dismiss()
    }
}

