import SwiftUI

// This demonstrates capturing images with the camera
// and getting images from the photo library.
struct CameraView: View {
    @Environment(\.dismiss) var dismiss

    typealias SourceType = UIImagePickerController.SourceType

    @State private var image: UIImage? = nil
    @State private var openCamera = false
    @State private var sourceType: SourceType? = nil

    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image).circle(diameter: 250)
            } else {
                Image(systemName: "person.crop.circle").circle(diameter: 150)
            }

            HStack {
                Button(
                    action: {
                        sourceType = .camera
                        openCamera = true
                    },
                    label: {
                        Image(systemName: "camera")
                    }
                )
                .font(.system(size: 60))

                Button(
                    action: {
                        sourceType = .photoLibrary
                        openCamera = true
                    },
                    label: {
                        Image(systemName: "photo.on.rectangle.angled")
                    }
                )
                .font(.system(size: 60))
            }
        }
        // When this sheet is dismissed,
        // the openCamera binding is set to false.
        .sheet(isPresented: $openCamera) {
            if let sourceType = sourceType {
                ImagePicker(sourceType: sourceType, image: $image)
            } else {
                Text("No sourceType is set.")
            }
        }
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
