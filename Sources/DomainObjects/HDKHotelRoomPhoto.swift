import UIKit

@objcMembers
public final class HDKHotelRoomPhoto: NSObject, NSCoding {

    public let photoPreviewInfoByRoomTypes: [String: HDKRoomPhotoPreviewInfo]

    internal init(proto: PBHotelRoomPhoto) {
        photoPreviewInfoByRoomTypes = proto.rooms.hdk_map { roomId, pbRoomPhotos in (String(roomId), HDKRoomPhotoPreviewInfo(proto: pbRoomPhotos)) }
    }

    public init?(coder aDecoder: NSCoder) {
        guard let photoPreviewInfoByRoomTypes = aDecoder.decodeObject(forKey: "photoPreviewInfoByRoomTypes") as? [String: HDKRoomPhotoPreviewInfo] else { return nil }

        self.photoPreviewInfoByRoomTypes = photoPreviewInfoByRoomTypes
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(photoPreviewInfoByRoomTypes, forKey: "photoPreviewInfoByRoomTypes")
    }
}
