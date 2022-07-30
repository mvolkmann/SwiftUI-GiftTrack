// This code came from https://www.youtube.com/watch?v=tMprUZDgAxo.
import SwiftUI

struct ImagePicker {
    @Environment(\.dismiss) var dismiss

    // MARK: - Nested Types

    typealias InfoKey = UIImagePickerController.InfoKey

    final class Coordinator: NSObject,
        UIImagePickerControllerDelegate,
        UINavigationControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(
            _: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [InfoKey: Any]
        ) {
            if let image = info[InfoKey.originalImage] as? UIImage {
                parent.image = image
            }
            parent.dismiss()
        }
    }

    // MARK: - Properties

    // Valid values are .camera and .photoLibrary.
    var sourceType: UIImagePickerController.SourceType

    @Binding var image: UIImage?

    // MARK: - Methods

    func makeUIViewController(
        context: UIViewControllerRepresentableContext<ImagePicker>
    ) -> UIImagePickerController {
        print("ImagePicker: sourceType = \(sourceType)")
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
}

extension ImagePicker: UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func updateUIViewController(
        _: UIImagePickerController,
        context _: Context
    ) {}
}
