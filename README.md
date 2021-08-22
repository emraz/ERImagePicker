# ERImagePicker
*Made with love and passion*

## Introduction
* A simple ImagePicker written in Swift, compatible with Swift 5.0

## Requirements 
* Xcode 11.X +
* Swift 5.0

## Installation
1. Download the least source files.
2. Drag ERImagePicker folder to Xcode project. Make sure to select Copy items if needed.

## How To Use

// Show Camera<br />
    ```
        imagePicker.presentERImagePicker(from: self, pickerType: .commonCamera)
    ```

// Show Photo Camera Only<br />
        ```
        imagePicker.presentERImagePicker(from: self, pickerType: .photoCamera)
    ```

// Show Video Camera Only<br />
        ```
        imagePicker.presentERImagePicker(from: self, pickerType: .videoCamera)
    ```

// Show PhotoLibrary <br />
        ```
        imagePicker.presentERImagePicker(from: self, pickerType: .photoVideoLibrary)
    ```
    
// Show Only Photos<br />
        ```
        imagePicker.presentERImagePicker(from: self, pickerType: .photoLibrary)
    ```
    
// Show Only Videos<br />
        ```
            imagePicker.presentERImagePicker(from: self, pickerType: .videoLibrary)
    ```
    
## License
ERProgressHud is released under the MIT license. See LICENSE for details.


