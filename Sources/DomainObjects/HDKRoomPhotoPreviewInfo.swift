import UIKit

public final class HDKRoomPhotoPreviewInfo: NSObject, NSCoding {

    public let previewPhotoId: String
    public let totalPhotosCount: Int

    internal init(proto: PBRoomPhotos) {
        guard let firstPhoto = proto.photosIds.first else {
            assertionFailure()
            previewPhotoId = ""
            totalPhotosCount = 0
            return
        }
        previewPhotoId = String(firstPhoto)
        totalPhotosCount = Int(proto.count)
    }

    public init?(coder aDecoder: NSCoder) {
        guard let previewPhotoId = aDecoder.decodeObject(forKey: "previewPhotoId") as? String,
            let totalPhotosCount = aDecoder.decodeObject(forKey: "totalPhotosCount") as? Int
            else { return nil }

        self.previewPhotoId = previewPhotoId
        self.totalPhotosCount = totalPhotosCount
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(previewPhotoId, forKey: "previewPhotoId")
        aCoder.encode(totalPhotosCount, forKey: "totalPhotosCount")
    }
}
