//
//  ERImagePicker.swift
//  Demo
//
//  Created by Mahmudul Hasan on 2020/03/31.
//  Copyright © 2020 Matrix Solution Ltd. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import MobileCoreServices

protocol ERImagePickerDelegate: class {
    func ERImagePickerDelegate(canUseCamera accessIsAllowed: Bool, delegatedForm: ERImagePicker)
    func ERImagePickerDelegate(canUseGallery accessIsAllowed: Bool, delegatedForm: ERImagePicker)
    func ERImagePickerDelegate(didSelect image: UIImage, delegatedForm: ERImagePicker)
    func ERImagePickerDelegate(didCancel delegatedForm: ERImagePicker)
}

let LivePhoto = kUTTypeLivePhoto as String
let GIF = kUTTypeGIF as String

class ERImagePicker: NSObject {

    private weak var controller: UIImagePickerController?
    weak var delegate: ERImagePickerDelegate? = nil

    func present(parent viewController: UIViewController, sourceType: UIImagePickerController.SourceType, mediaTypes: [String]) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = sourceType
        if (mediaTypes.count >= 1) {
            controller.mediaTypes = mediaTypes
        }
        self.controller = controller
        DispatchQueue.main.async {
            viewController.present(controller, animated: true, completion: nil)
        }
    }

    func dismiss() { controller?.dismiss(animated: true, completion: nil) }
}

extension ERImagePicker {

    private func showAlert(targetName: String, completion: @escaping (Bool)->()) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let alertVC = UIAlertController(title: "Access to the \(targetName)",
                                            message: "Please provide access to your \(targetName)",
                                            preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Settings", style: .default, handler: { action in
                guard   let settingsUrl = URL(string: UIApplication.openSettingsURLString),
                    UIApplication.shared.canOpenURL(settingsUrl) else { completion(false); return }
                UIApplication.shared.open(settingsUrl, options: [:]) {
                    [weak self] _ in self?.showAlert(targetName: targetName, completion: completion)
                }
            }))
            alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in completion(false) }))
            UIApplication.shared.delegate?.window??.rootViewController?.present(alertVC, animated: true, completion: nil)
        }
    }

    func cameraAsscessRequest() {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            delegate?.ERImagePickerDelegate(canUseCamera: true, delegatedForm: self)
        } else {
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard let self = self else { return }
                if granted {
                    self.delegate?.ERImagePickerDelegate(canUseCamera: granted, delegatedForm: self)
                } else {
                    self.showAlert(targetName: "camera") { self.delegate?.ERImagePickerDelegate(canUseCamera: $0, delegatedForm: self) }
                }
            }
        }
    }

    func photoGalleryAsscessRequest() {
        PHPhotoLibrary.requestAuthorization { [weak self] result in
            guard let self = self else { return }
            if result == .authorized {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.ERImagePickerDelegate(canUseGallery: result == .authorized, delegatedForm: self)
                }
            } else {
                self.showAlert(targetName: "photo gallery") { self.delegate?.ERImagePickerDelegate(canUseCamera: $0, delegatedForm: self) }
            }
        }
    }
}

extension ERImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            delegate?.ERImagePickerDelegate(didSelect: image, delegatedForm: self)
            return
        }

        if let image = info[.originalImage] as? UIImage {
            delegate?.ERImagePickerDelegate(didSelect: image, delegatedForm: self)
        } else {
            print("Other source")
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        delegate?.ERImagePickerDelegate(didCancel: self)
    }
}
