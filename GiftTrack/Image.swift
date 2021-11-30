import CoreData
import SwiftUI

extension Image {
    func circle(diameter: CGFloat) -> some View {
        self
            .resizable()
            .scaledToFill()
            .frame(width: diameter, height: diameter)
            .clipShape(Circle())
    }

    func square(size: CGFloat) -> some View {
        self
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
        // .clipShape(Rectangle())
    }
}

/*
 func saveJpeg(image: UIImage, entityName: String, moc: NSManagedObjectContext) {
     let data = image.jpegData(compressionQuality: 1.0)
     let entityDesc = NSEntityDescription.entity(
         forEntityName: entityName,
         in: moc)!
     let image = NSManagedObject(entity: entityDesc, insertInto: moc)
     image.setValue(data, forKeyPath: "Your Attribute Name")
     return image
 }
 */

/*
 func retrieveJpeg() {
     return UIImage(data: imageData)
 }
 */
