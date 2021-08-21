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

//https://ikyle.me/blog/2020/phpickerviewcontroller
//https://github.com/kylehowells/ikyle.me-code-examples/blob/master/Photo%20Picker%20Swift/Photo%20Picker%20Swift/ViewController.swift#L13
//https://stackoverflow.com/questions/66729088/how-to-use-both-uiimagepickercontroller-and-phpicker-by-adding-available

enum ERImagePickerType {
    case commonCamera
    case photoCamera
    case videoCamera
    case photoLibrary
    case videoLibrary
    case photoVideoLibrary
}

enum ComponentType: String {
    case camera = "Camera"
    case photoLibrary = "PhotoLibrary"
}

typealias CompletionWithSucess = (_ success: Bool) -> Void

protocol ERImagePickerDelegate: AnyObject {
    func ERImagePickerDelegate(didSelect image: UIImage, delegatedForm: ERImagePicker)
    func ERImagePickerDidCancel()
}

class ERImagePicker: NSObject {

    private lazy var imagePickerController =  UIImagePickerController()
    weak var delegate: ERImagePickerDelegate?
    private var rootViewController: UIViewController?

    func presentERImagePicker(from viewController: UIViewController, pickerType ImagePickerType: ERImagePickerType) {
        
        rootViewController = viewController
                
        switch ImagePickerType {
        case .commonCamera:
            showCamera()
            break
        case .photoCamera:
            showPhotoCamera()
            break
        case .videoCamera:
            showVideoCamera()
            break
        case .photoLibrary:
            showOnlyPhotos()
            break
        case .videoLibrary:
            showOnlyVideos()
            break
        case .photoVideoLibrary:
            showPhotoLibrary()
            break
        }
    }
    
    private func showCamera() {
        
        if !isCameraAvailable() {
            return
        }
        
        cameraAsscessRequest { isAuthorized in
            DispatchQueue.main.async {
                if isAuthorized {
                    self.showPicker(sourceType: .camera, mediaTypes: [kUTTypeImage as String, kUTTypeMovie as String])
                }
                else {
                    self.showAlert(for: ComponentType.camera.rawValue)
                }
            }
        }
    }
    
    private func showPhotoCamera() {
        
        if !isCameraAvailable() {
            return
        }
        
        cameraAsscessRequest { isAuthorized in
            DispatchQueue.main.async {
                if isAuthorized {
                    self.showPicker(sourceType: .camera, mediaTypes: [kUTTypeImage as String])
                }
                else {
                    self.showAlert(for: ComponentType.camera.rawValue)
                }
            }
        }
    }
    
    private func showVideoCamera() {
        
        if !isCameraAvailable() {
            return
        }
        
        cameraAsscessRequest { isAuthorized in
            DispatchQueue.main.async {
                if isAuthorized {
                    self.showPicker(sourceType: .camera, mediaTypes: [kUTTypeMovie as String])
                }
                else {
                    self.showAlert(for: ComponentType.camera.rawValue)
                }
            }
        }
    }
    
    private func showPhotoLibrary() {
        
        if !isPhotoLibraryAvailable() {
            return
        }
        
        cameraAsscessRequest { isAuthorized in
            DispatchQueue.main.async {
                if isAuthorized {
                    self.showPicker(sourceType: .photoLibrary, mediaTypes: [kUTTypeImage as String, kUTTypeMovie as String])
                }
                else {
                    self.showAlert(for: ComponentType.camera.rawValue)
                }
            }
        }
    }
    
    private func showOnlyPhotos() {
        
        if !isPhotoLibraryAvailable() {
            return
        }
        
        cameraAsscessRequest { isAuthorized in
            DispatchQueue.main.async {
                if isAuthorized {
                    self.showPicker(sourceType: .photoLibrary, mediaTypes: [kUTTypeImage as String])
                }
                else {
                    self.showAlert(for: ComponentType.camera.rawValue)
                }
            }
        }
    }
    
    private func showOnlyVideos() {
        
        if !isPhotoLibraryAvailable() {
            return
        }
        
        cameraAsscessRequest { isAuthorized in
            DispatchQueue.main.async {
                if isAuthorized {
                    self.showPicker(sourceType: .photoLibrary, mediaTypes: [kUTTypeMovie as String])
                }
                else {
                    self.showAlert(for: ComponentType.camera.rawValue)
                }
            }
        }
    }
    
    private func showPicker(sourceType: UIImagePickerController.SourceType, mediaTypes: [String]) {
        
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = sourceType
        imagePickerController.mediaTypes = mediaTypes

        switch sourceType {
        case .camera:
            imagePickerController.allowsEditing = true
            imagePickerController.videoQuality = .typeHigh

        default:
            break
        }
  
        if let rVC = rootViewController {
            imagePickerController.modalPresentationStyle = .fullScreen
            rVC.present(imagePickerController, animated: true, completion: nil)
        }
    }

    func dismissPicker() {
        imagePickerController.dismiss(animated: true, completion: nil)
    }
}

extension ERImagePicker {
    
    private func isCameraAvailable() -> Bool {
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            ERAlertController.showAlert("Error!", message: "Device has no camera!", isCancel: false, okButtonTitle: "I Understand", cancelButtonTitle: "", completion: nil)
            return false
        }
        return true
    }

    private func isPhotoLibraryAvailable() -> Bool {
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            ERAlertController.showAlert("Error!", message: "Device has no photolibrary!", isCancel: false, okButtonTitle: "I Understand", cancelButtonTitle: "", completion: nil)
            return false
        }
        return true
    }
    
    private func showAlert(for componentName: String) {
        
        ERAlertController.showAlert("Access to the \(componentName)", message: "Please provide access to your \(componentName)", isCancel: true, okButtonTitle: "Settings", cancelButtonTitle: "Cancel") { isAllow in
            if(isAllow) {
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString),
                    UIApplication.shared.canOpenURL(settingsUrl) else {
                    return
                }
                UIApplication.shared.open(settingsUrl, options: [ : ], completionHandler: nil)
            }
        }
    }

    func cameraAsscessRequest(completion: @escaping CompletionWithSucess) {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            completion(true)
        } else {
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }

    private func photoGalleryAsscessRequest(completion: @escaping CompletionWithSucess) -> Void {
        PHPhotoLibrary.requestAuthorization { result in
            if result == .authorized {
                completion(true)
            } else {
                completion(false)
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
        
        
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! String

        if mediaType.isEqual(kUTTypeImage as String) {
            // Media is an image
        }
        else if mediaType.isEqual(kUTTypeMovie as String) {
            // Media is a video
        }
        
        dismissPicker()
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismissPicker()
        delegate?.ERImagePickerDidCancel()
    }
}
