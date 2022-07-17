import SwiftUI

struct MyPhoto: View {
    // MARK: - State

    @State private var openImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera

    // MARK: Initializer

    init(
        _ title: String,
        image: Binding<UIImage?>,
        edit: Bool = true
    ) {
        self.title = title
        _image = image
        self.edit = edit
    }

    // MARK: - Constants

    private let imageSize = 150.0

    // MARK: - Properties

    private let title: String
    @Binding private var image: UIImage?
    private let edit: Bool

    var body: some View {
        if edit {
            HStack {
                VStack(spacing: 10) {
                    IconButton(icon: "camera") {
                        sourceType = .camera
                        openImagePicker = true
                    }
                    IconButton(icon: "photo.on.rectangle.angled") {
                        sourceType = .photoLibrary
                        openImagePicker = true
                    }
                }
                
                if let unwrappedImage = image {
                    Image(uiImage: unwrappedImage)
                        .square(size: imageSize)
                    Spacer()
                    DeleteButton {
                        image = nil
                        openImagePicker = false // TODO: Why needed?
                    }
                }
            }
            // This fixes the bug with multiple buttons in a Form.
            .buttonStyle(.borderless)
            .sheet(isPresented: $openImagePicker) {
                ImagePicker(sourceType: sourceType, image: $image)
            }
        } else {
            if let image = image {
                Image(uiImage: image).square(size: imageSize)
            }
        }
    }
}
