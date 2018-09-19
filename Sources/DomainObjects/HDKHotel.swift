public final class HDKHotel: NSObject, NSCoding, NSCopying {
    public let hotelId: String
    public var type: Int = 0
    public var latitude: Float = 0
    public var longitude: Float = 0
    public var reviews: [HDKReview] = []
    public var knownGuests: HDKKnownGuests = HDKKnownGuests()
    public var popularity: Int = 0
    public var rank: Int = 0
    public var popularity2: Int = 0
    public var name: String?
    public var latinName: String?
    public var address: String?
    public var rating: Int = 0
    public var stars: Int = 0
    public var isRentals: Bool = false
    public var hasRentals: Bool = false
    public var reviewsCount: Int = 0
    public var amenitiesShort: [String: HDKAmenityShort] = [:]
    public var amenitiesV2: HDKAmenitiesList = HDKAmenitiesList()
    public var roomsCount: Int = 0
    public var yearOpened: Int = 0
    public var yearRenovated: Int = 0
    public var city: HDKCity?
    public var trustyou: HDKTrustyou?
    public var checkInTime: Date?
    public var checkOutTime: Date?
    public var districts: [HDKDistrict] = []
    public var importantPoiArray: [HDKLocationPoint] = []
    public var photosIds: [String] = []
    public var photosByRoomType: [String: [String]] = [:]
    public var hotelRoomsPhotoPreviewInfo: HDKHotelRoomPhoto?

    internal init(fromCityDumpHotelProto proto: PBHotel,
                  hotelId: String,
                  districtsDict: [String: HDKDistrict],
                  poiDict: [String: HDKLocationPoint],
                  trustyouDict: [String: HDKTrustyou],
                  knownGuests: HDKKnownGuests?,
                  shortAmenitiesDict: [String: HDKAmenityShort],
                  hotelRoomsPhotoPreviewInfo: HDKHotelRoomPhoto?) {

        self.hotelRoomsPhotoPreviewInfo = hotelRoomsPhotoPreviewInfo
        self.hotelId = hotelId
        name = proto.name
        latinName = proto.latinName
        address = proto.address
        rating = Int(proto.rating * 10)
        stars = Int(proto.stars)
        photosIds = proto.photosIds.map { String($0) }
        photosByRoomType = HDKHotel.parsePhotosByRoomType(from: proto)
        type = proto.propertyType.rawValue
        isRentals = proto.isRentals
        hasRentals = proto.hasRentals_p
        latitude = proto.location.lat
        longitude = proto.location.lon
        popularity = Int(proto.popularity)
        amenitiesV2 = HDKAmenitiesList(proto: proto.amenitiesv2)

        self.amenitiesShort = proto.amenities.hdk_toDictionary { amenityId in
            let amenityIdString = String(amenityId)
            guard let amenity = shortAmenitiesDict[amenityIdString] else { return nil }
            return (amenityIdString, amenity)
        }
        popularity2 = Int(proto.popularity2)

        self.knownGuests = knownGuests ?? HDKKnownGuests()

        trustyou = trustyouDict[hotelId]

        let distanceDict = proto.poisDistances.hdk_map { pointId, distance in (String(pointId), Int(distance)) }
        importantPoiArray = HDKHotel.points(poiDict, filledWith: distanceDict)

        districts = proto.districtsIds.compactMap { districtId in
            let districtIdString = String(districtId)
            return districtsDict[districtIdString]
        }
    }

    internal init(fromHotelDetailsProto proto: PBHotel,
                  hotelId: String,
                  districtsDict: [String: HDKDistrict],
                  poiDict: [String: HDKLocationPoint],
                  trustyouDict: [String: HDKTrustyou],
                  city: HDKCity?) {

        self.hotelId = hotelId
        name = proto.name
        latinName = proto.latinName
        address = proto.address
        rating = Int(proto.rating * 10)
        stars = Int(proto.stars)
        photosIds = proto.photosIds.map { String($0) }
        photosByRoomType = HDKHotel.parsePhotosByRoomType(from: proto)
        type = proto.propertyType.rawValue
        isRentals = proto.isRentals
        hasRentals = proto.hasRentals_p
        latitude = proto.location.lat
        longitude = proto.location.lon
        popularity = Int(proto.popularity)
        amenitiesV2 = HDKAmenitiesList(proto: proto.amenitiesv2)
        reviewsCount = Int(proto.reviewsCount)

        amenitiesShort = [:]
        trustyou = trustyouDict[hotelId]

        let distanceDict = proto.poisDistances.hdk_map { pointId, distance in (String(pointId), Int(distance)) }
        importantPoiArray = HDKHotel.points(poiDict, filledWith: distanceDict)

        districts = proto.districtsIds.compactMap { districtId in
            let districtIdString = String(districtId)
            return districtsDict[districtIdString]
        }

        roomsCount = Int(proto.roomCount)
        yearRenovated = Int(proto.yearRenovated)
        yearOpened = Int(proto.yearOpened)

        checkInTime = HDKDateUtil.time(fromString: proto.checkIn)
        checkOutTime = HDKDateUtil.time(fromString: proto.checkOut)

        self.city = city
    }

    internal init(autocompleteProto proto: PBHotel, city: HDKCity) {

        self.city = city

        hotelId = String(proto.id)
        name = proto.name
        latinName = proto.latinName
        address = proto.address
        rating = Int(proto.rating * 10)
        stars = Int(proto.stars)
        type = proto.propertyType.rawValue
        isRentals = proto.isRentals
        hasRentals = proto.hasRentals_p
        latitude = proto.location.lat
        longitude = proto.location.lon
        photosIds = proto.photosIds.map { String($0) }
    }

    public init(hotelId: String) {
        self.hotelId = hotelId
    }

    public func update(byHotelDetailsHotel hotel: HDKHotel) {
        name = hotel.name
        latinName = hotel.latinName
        address = hotel.address
        rating = hotel.rating
        stars = hotel.stars
        photosIds = hotel.photosIds
        photosByRoomType = hotel.photosByRoomType
        type = hotel.type
        isRentals = hotel.isRentals
        hasRentals = hotel.hasRentals
        latitude = hotel.latitude
        longitude = hotel.longitude
        reviewsCount = hotel.reviewsCount
        amenitiesShort = hotel.amenitiesShort
        amenitiesV2 = hotel.amenitiesV2
        roomsCount = hotel.roomsCount
        yearOpened = hotel.yearOpened
        yearRenovated = hotel.yearRenovated
        trustyou = hotel.trustyou
        checkInTime = hotel.checkInTime
        checkOutTime = hotel.checkOutTime
        districts = hotel.districts
        importantPoiArray = hotel.importantPoiArray

        // Cities may be different for autocomplete and hotel details
        // We use first valid city to prevent bugs with favotites
        if city == nil || city?.cityId == hotel.city?.cityId {
            city = hotel.city
        }
    }

    private static func parsePhotosByRoomType(from proto: PBHotel) -> [String: [String]] {
        return proto.photosByRoomType.hdk_map { roomType, roomPhotos in
            let photos = roomPhotos.photosIds.map { String($0) }
            return (String(roomType), photos)
        }
    }

    private static func points(_ poiDict: [String: HDKLocationPoint], filledWith distanceDict: [String: Int]) -> [HDKLocationPoint] {
        var result: [HDKLocationPoint] = []
        for key in distanceDict.keys {
            if let point = poiDict[key] {
                guard let copy = point.copy() as? HDKLocationPoint else { continue }
                copy.distanceToHotel = Float(distanceDict[key] ?? 0)
                result.append(copy)
            }
        }
        return result
    }

    public func firstDistrictName() -> String? {
        return districts.first?.name
    }

    public func firstDistrictId() -> String? {
        return districts.first?.districtId
    }

    public func isValid() -> Bool {
        return (name?.count ?? 0) > 0
    }

    public func hotelAmenities() -> [HDKAmenity] {
        return amenitiesV2.hotel
    }

    public func roomAmenities() -> [HDKAmenity] {
        return amenitiesV2.room
    }

    public func staffLanguages() -> [HDKAmenity] {
        return amenitiesV2.language
    }

    public func thumbPhotoIdsCount(for roomType: String) -> Int {
        if let briefPhotoCount = hotelRoomsPhotoPreviewInfo?.photoPreviewInfoByRoomTypes[roomType]?.totalPhotosCount, briefPhotoCount > 0 {
            return briefPhotoCount
        } else if let originalPhotoCount = photosByRoomType[roomType]?.count {
            return originalPhotoCount
        } else {
            return 0
        }
    }

    public func photoId(for roomType: String) -> String? {
        if let briefPhotoId = hotelRoomsPhotoPreviewInfo?.photoPreviewInfoByRoomTypes[roomType]?.previewPhotoId {
            return briefPhotoId
        } else if let originalPhotoId = photosByRoomType[roomType]?.first {
            return originalPhotoId
        } else {
            return photosIds.first
        }
    }

    public override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? HDKHotel else { return false }
        if hotelId != other.hotelId {
            return false
        }
        return true
    }

    public override var hash: Int {
        return hotelId.hash
    }

    public init?(coder aDecoder: NSCoder) {
        guard let hotelId = aDecoder.decodeObject(forKey: "hotelId") as? String else {
            return nil
        }
        self.hotelId = hotelId
        address = aDecoder.decodeObject(forKey: "address") as? String

        name = aDecoder.decodeObject(forKey: "name") as? String
        latinName = aDecoder.decodeObject(forKey: "latinName") as? String
        checkInTime = aDecoder.decodeObject(forKey: "checkInTime") as? Date
        checkOutTime = aDecoder.decodeObject(forKey: "checkOutTime") as? Date
        trustyou = aDecoder.decodeObject(forKey: "trustyou") as? HDKTrustyou
        amenitiesShort = aDecoder.decodeObject(forKey: "amenitiesShort") as? [String: HDKAmenityShort] ?? [:]
        amenitiesV2 = (aDecoder.decodeObject(forKey: "amenitiesV2") as? HDKAmenitiesList) ?? HDKAmenitiesList()
        city = aDecoder.decodeObject(forKey: "city") as? HDKCity
        latitude = aDecoder.decodeFloat(forKey: "latitude")
        longitude = aDecoder.decodeFloat(forKey: "longitude")
        type = aDecoder.decodeInteger(forKey: "type")
        photosIds = aDecoder.decodeObject(forKey: "photosIds") as? [String] ?? []
        photosByRoomType = aDecoder.decodeObject(forKey: "photosByRoomType") as? [String: [String]] ?? [:]
        popularity = aDecoder.decodeInteger(forKey: "popularity")
        rating = aDecoder.decodeInteger(forKey: "rating")
        stars = aDecoder.decodeInteger(forKey: "stars")
        popularity2 = aDecoder.decodeInteger(forKey: "popularity2")
        isRentals = aDecoder.decodeBool(forKey: "isRentals")
        hasRentals = aDecoder.decodeBool(forKey: "hasRentals")
        importantPoiArray = aDecoder.decodeObject(forKey: "importantPoiArray") as? [HDKLocationPoint] ?? []
        districts = aDecoder.decodeObject(forKey: "districts") as? [HDKDistrict] ?? []
        knownGuests = (aDecoder.decodeObject(forKey: "known_guests") as? HDKKnownGuests) ?? HDKKnownGuests()
        roomsCount = aDecoder.decodeInteger(forKey: "cntRooms")
        yearOpened = aDecoder.decodeInteger(forKey: "yearOpened")
        yearRenovated = aDecoder.decodeInteger(forKey: "yearRenovated")
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(hotelId, forKey: "hotelId")
        aCoder.encode(address, forKey: "address")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(latinName, forKey: "latinName")
        aCoder.encode(checkInTime, forKey: "checkInTime")
        aCoder.encode(checkOutTime, forKey: "checkOutTime")
        aCoder.encode(trustyou, forKey: "trustyou")
        aCoder.encode(amenitiesShort, forKey: "amenitiesShort")
        aCoder.encode(amenitiesV2, forKey: "amenitiesV2")
        aCoder.encode(city, forKey: "city")
        aCoder.encode(latitude, forKey: "latitude")
        aCoder.encode(longitude, forKey: "longitude")
        aCoder.encode(type, forKey: "type")
        aCoder.encode(photosIds, forKey: "photosIds")
        aCoder.encode(photosByRoomType, forKey: "photosByRoomType")
        aCoder.encode(popularity, forKey: "popularity")
        aCoder.encode(rating, forKey: "rating")
        aCoder.encode(stars, forKey: "stars")
        aCoder.encode(popularity2, forKey: "popularity2")
        aCoder.encode(isRentals, forKey: "isRentals")
        aCoder.encode(hasRentals, forKey: "hasRentals")
        aCoder.encode(importantPoiArray, forKey: "importantPoiArray")
        aCoder.encode(districts, forKey: "districts")
        aCoder.encode(knownGuests, forKey: "known_guests")
        aCoder.encode(roomsCount, forKey: "cntRooms")
        aCoder.encode(yearOpened, forKey: "yearOpened")
        aCoder.encode(yearRenovated, forKey: "yearRenovated")
    }

    public func copy(with zone: NSZone? = nil) -> Any {
        let archived = NSKeyedArchiver.archivedData(withRootObject: self)
        return NSKeyedUnarchiver.unarchiveObject(with: archived)!
    }
}
