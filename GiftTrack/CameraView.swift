import SwiftUI

/*
 To enable camera access:
 1. In the Navigator, select the root group to open the project editor.
 2. In the project editor, select the target.
 3. Select the "Info" tab.
 4. Click the "+" after any existing key to create a new key.
 5. For the key name enter "Privacy - Camera Usage Description".
 6. For the key value, enter something like "Please allow camera access."

 The Preview and Simulator cannot access the camera.
 To test camera access, run the app on a real device.
 */

struct CameraView: View {
    @Environment(\.dismiss) var dismiss

    typealias SourceType = UIImagePickerController.SourceType

    @State private var image: UIImage? = nil
    @State private var needImage = false
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
                        needImage = true
                    },
                    label: {
                        Image(systemName: "camera")
                    }
                )
                .font(.system(size: 60))

                Button(
                    action: {
                        sourceType = .photoLibrary
                        needImage = true
                    },
                    label: {
                        Image(systemName: "photo.on.rectangle.angled")
                    }
                )
                .font(.system(size: 60))
            }
        }
        // When this sheet is dismissed,
        // the needImage binding is set to false.
        .sheet(isPresented: $needImage) {
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
