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

extension Image {
    func custom() -> some View {
        self
            .resizable()
            .frame(width: 120, height: 120)
            .clipShape(Circle())
    }
}

struct CameraView: View {
    typealias SourceType = UIImagePickerController.SourceType

    @State private var changeImage = false
    // @State private var imageSelected = UIImage()
    @State private var imageSelected = UIImage()
    @State private var openCameraRoll = false
    @State private var sourceType: SourceType = .photoLibrary

    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                Button(
                    action: {
                        print("got tap")
                        // changeImage = true
                        // openCameraRoll = true
                    },
                    label: {
                        if changeImage {
                            Image(uiImage: imageSelected).custom()
                        } else {
                            Image(systemName: "person.crop.circle").custom()
                        }
                    }
                )
                Image(systemName: "plus")
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
                    .background(.gray)
                    .clipShape(Circle())
            }

            Button("Camera") {
                sourceType = .camera
                changeImage = true
                openCameraRoll = true
            }.buttonStyle(MyButtonStyle())

            Button("Photo Library") {
                sourceType = .photoLibrary
                changeImage = true
                openCameraRoll = true
            }.buttonStyle(MyButtonStyle())
        }
        .sheet(isPresented: $openCameraRoll) {
            ImagePicker(
                selectedImage: $imageSelected,
                sourceType: sourceType
            )
        }
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
