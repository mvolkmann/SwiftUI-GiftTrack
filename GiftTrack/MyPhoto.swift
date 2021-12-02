import SwiftUI

struct MyPhoto: View {
    @EnvironmentObject var settings: Settings

    @State private var openImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    
    private let title: String
    @Binding private var image: UIImage?
    private let edit: Bool

    init(
        _ title: String,
        image: Binding<UIImage?>,
        edit: Bool
    ) {
        self.title = title
        _image = image
        self.edit = edit
    }

    var body: some View {
        if edit {
            HStack {
                IconButton(icon: "camera") {
                    sourceType = .camera
                    openImagePicker = true
                }
                IconButton(icon: "photo.on.rectangle.angled") {
                    sourceType = .photoLibrary
                    openImagePicker = true
                }
                
                if let unwrappedImage = image {
                    Image(uiImage: unwrappedImage)
                        .square(size: Settings.imageSize)
                    
                    IconButton(icon: "xmark.circle") {
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
                Image(uiImage: image)
                    .square(size: Settings.imageSize)
            } else {
                Text("\(title): none")
                    .font(.system(size: 20))
                    // The default foreground color is Color.primary.
                    // It is set here so it can be overridden in Settings.
                    .foregroundColor(settings.textColor)
            }
        }
    }
}
