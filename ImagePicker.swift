
import UIKit
import MobileCoreServices

public protocol ImagePickerDelegate {
    
    // Called when the image controller needs to be presented
    func presentPicker(picker: UIImagePickerController)
    
    // Called whne the image controller is either selected or cancelled
    func dismissPicker(picker: UIImagePickerController, selectedImage:UIImage?)
}

//
//  Provides once off image picker
//
public class ImagePicker : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public var delegate:ImagePickerDelegate?
    
    private var imagePickerController:UIImagePickerController?
    
    deinit {
        removeImagePickerController()
    }
    
    public func presentPicker(allowEditing:Bool = true) {
        
        if self.imagePickerController == nil {
            self.imagePickerController = UIImagePickerController()
        }
        
        let controler = self.imagePickerController!
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            controler.sourceType = .Camera
        } else if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            controler.sourceType = .PhotoLibrary
        } else {
            controler.sourceType = .SavedPhotosAlbum
        }
        
        controler.mediaTypes = [kUTTypeImage as String]
        controler.allowsEditing = allowEditing
        controler.delegate = self
        
        delegate?.presentPicker(controler)
    }
    
    public func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerEditedImage] as? UIImage
        
        delegate?.dismissPicker(picker, selectedImage:image)
        removeImagePickerController()
    }
    
    public func imagePickerControllerDidCancel(picker:UIImagePickerController) {
        delegate?.dismissPicker(picker, selectedImage:nil)
        removeImagePickerController()
    }
    
    private func removeImagePickerController() {
        
        if let controller = self.imagePickerController {
            controller.delegate = nil
            delegate = nil
        }
        
        self.imagePickerController = nil
    }
}

