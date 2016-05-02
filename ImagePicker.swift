
import UIKit
import MobileCoreServices

public class ImagePicker : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let title:String
    private let allowEditing:Bool
    
    private var parentViewController:UIViewController?
    private var completion:((image:UIImage?) -> Void)?
    
    private struct Constants {
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
    
    public func presentPicker(parentViewController:UIViewController, completion:((UIImage?) -> Void)) {
        
        self.completion = completion
        self.parentViewController = parentViewController
        
        let imagePickerActionSheet = UIAlertController(title: title, message: nil, preferredStyle: .ActionSheet)
        
        // Camera
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let cameraButton = UIAlertAction(title: Constants.cameraAction, style: .Default) { (alert) -> Void in
                
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = .Camera
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.delegate = self
                imagePicker.allowsEditing = self.allowEditing
                
                parentViewController.presentViewController(imagePicker, animated: true, completion: nil)
            }
            
            imagePickerActionSheet.addAction(cameraButton)
        }
        
        // Photo library
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            let libraryButton = UIAlertAction(title: Constants.photoLibraryAction, style: .Default) { (alert) -> Void in
                
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = .PhotoLibrary
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.delegate = self
                imagePicker.allowsEditing = self.allowEditing
                
                NSLog("PickerController deleage = \(imagePicker.delegate)")
                parentViewController.presentViewController(imagePicker, animated: true, completion: nil)
            }
            
            imagePickerActionSheet.addAction(libraryButton)
        }
        
        // Cancel
        if imagePickerActionSheet.actions.count > 0 {
            let cancelButton = UIAlertAction(title: Constants.cancelAction, style: .Cancel) { (alert) -> Void in
                NSLog("[ImagePicker] Image picker cancelled")
            }
            imagePickerActionSheet.addAction(cancelButton)
        }
        
        parentViewController.presentViewController(imagePickerActionSheet, animated: true, completion: nil)
        
    }
    
    public func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        NSLog("[ImagePicker] Controller image selected")
        
        let image = (allowEditing ? info[UIImagePickerControllerEditedImage] : info[UIImagePickerControllerOriginalImage]) as? UIImage
        
        let handler = self.completion
        parentViewController?.dismissViewControllerAnimated(true) {
            handler?(image: image)
        }
        
        removedParentViewController()
    }
    
    public func imagePickerControllerDidCancel(picker:UIImagePickerController) {
        NSLog("[ImagePicker] Controller image selection cancelled")
        
        let handler = self.completion
        parentViewController?.dismissViewControllerAnimated(true) {
            handler?(image: nil)
        }
        
        removedParentViewController()
    }
    
    private func removedParentViewController() {
        parentViewController = nil
        completion = nil
    }
}

