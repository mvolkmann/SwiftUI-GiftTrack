// This code came from https://www.youtube.com/watch?v=tMprUZDgAxo.
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss

    // Valid values are .camera and .photoLibrary.
    var sourceType: UIImagePickerController.SourceType

    @Binding var selectedImage: UIImage?

    func makeUIViewController(
        context: UIViewControllerRepresentableContext<ImagePicker>
    ) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }

    // This function is required to conform to the
    // UIViewControllerRepresentable protocol,
    // but it doesn't need to do anything.
    func updateUIViewController(
        _ uiViewController: UIImagePickerController,
        context: Context
    ) {}

    final class Coordinator: NSObject,
        UIImagePickerControllerDelegate,
        UINavigationControllerDelegate
    {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        typealias InfoKey = UIImagePickerController.InfoKey

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [InfoKey: Any]
        ) {
            if let image = info[InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.dismiss()
        }
    }

    // This function is required to conform to the
    // UIViewControllerRepresentable protocol.
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
