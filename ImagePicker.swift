
import UIKit
import MobileCoreServices

open class ImagePicker : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    fileprivate let title:String
    fileprivate let allowEditing:Bool
    
    fileprivate var parentViewController:UIViewController?
    fileprivate var completion:((_ image:UIImage?) -> Void)?
    
    fileprivate struct Constants {
        static let cameraAction = "Take Photo"
        static let photoLibraryAction = "Photo Library"
        static let cancelAction = "Cancel"
    }
    
    public init(title:String, allowEditing:Bool = false) {
        self.title = title
        self.allowEditing = allowEditing
        super.init()
    }
    
    deinit {
        NSLog("[ImagePicker] deinit")
        removedParentViewController()
    }
    
    open func presentPicker(_ parentViewController:UIViewController, completion:@escaping ((UIImage?) -> Void)) {
        
        self.completion = completion
        self.parentViewController = parentViewController
        
        let imagePickerActionSheet = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        // Camera
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraButton = UIAlertAction(title: Constants.cameraAction, style: .default) { (alert) -> Void in
                
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = .camera
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.delegate = self
                imagePicker.allowsEditing = self.allowEditing
                
                parentViewController.present(imagePicker, animated: true, completion: nil)
            }
            
            imagePickerActionSheet.addAction(cameraButton)
        }
        
        // Photo library
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let libraryButton = UIAlertAction(title: Constants.photoLibraryAction, style: .default) { (alert) -> Void in
                
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = .photoLibrary
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.delegate = self
                imagePicker.allowsEditing = self.allowEditing
                
                NSLog("PickerController deleage = \(imagePicker.delegate)")
                parentViewController.present(imagePicker, animated: true, completion: nil)
            }
            
            imagePickerActionSheet.addAction(libraryButton)
        }
        
        // Cancel
        if imagePickerActionSheet.actions.count > 0 {
            let cancelButton = UIAlertAction(title: Constants.cancelAction, style: .cancel) { (alert) -> Void in
                NSLog("[ImagePicker] Image picker cancelled")
            }
            imagePickerActionSheet.addAction(cancelButton)
        }
        
        parentViewController.present(imagePickerActionSheet, animated: true, completion: nil)
        
    }
    
    open func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        NSLog("[ImagePicker] Controller image selected")
        
        let image = (allowEditing ? info[UIImagePickerControllerEditedImage] : info[UIImagePickerControllerOriginalImage]) as? UIImage
        
        let handler = self.completion
        parentViewController?.dismiss(animated: true) {
            handler?(image)
        }
        
        removedParentViewController()
    }
    
    open func imagePickerControllerDidCancel(_ picker:UIImagePickerController) {
        NSLog("[ImagePicker] Controller image selection cancelled")
        
        let handler = self.completion
        parentViewController?.dismiss(animated: true) {
            handler?(nil)
        }
        
        removedParentViewController()
    }
    
    fileprivate func removedParentViewController() {
        parentViewController = nil
        completion = nil
    }
}

