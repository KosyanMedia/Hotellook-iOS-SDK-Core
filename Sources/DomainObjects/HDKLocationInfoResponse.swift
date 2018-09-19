import Foundation

public class HDKLocationListResponse: NSObject {
    public let cities: [String: HDKLocationInfoResponse]

    internal init(proto: PBLocationInfoResponse) {
        let districtsDict: [String: HDKDistrict] = proto.districts.hdk_map { districtId, value in
            let districtIdString = String(districtId)
            let district = HDKDistrict(proto: value, districtId: districtIdString)
            return (districtIdString, district)
        }

        let trustyouDict = proto.trustyou.hdk_map { hotelId, value in (String(hotelId), HDKTrustyou(proto: value)) }

        let poiDict: [String: HDKLocationPoint] = proto.pois.hdk_map { pointId, value in
            let pointIdString = String(pointId)
            let point = HDKLocationPoint(proto: value, pointId: pointIdString)
            return (pointIdString, point)
        }

        let knownGuestsByHotelId: [String: HDKKnownGuests] = proto.hotelsKnownGuests.hdk_map { hotelId, pbknownGuests in
            let hotelIdString = String(hotelId)
            let knownGuests = HDKKnownGuests(proto: pbknownGuests)
            return (hotelIdString, knownGuests)
        }

        let hotelsAmenities: [String: HDKAmenityShort] = proto.hotelsAmenities.hdk_map { amenityId, pbamenity in
            let amenityIdString = String(amenityId)
            let amenity = HDKAmenityShort(proto: pbamenity, amenityId: amenityIdString)
            return (amenityIdString, amenity)
        }

        let hotelsRoomsPhotoPreviewInfo: [String: HDKHotelRoomPhoto] = proto.hotelsRoomPhotos.hdk_map { hotelId, pbHotelRoomsPhotoPreviewInfo in
            let hotelIdString = String(hotelId)
            let hotelRoomsPhotoPreviewInfo = HDKHotelRoomPhoto(proto: pbHotelRoomsPhotoPreviewInfo)
            return (hotelIdString, hotelRoomsPhotoPreviewInfo)
        }

        var hotelsByCityId: [String: [HDKHotel]] = [:]
        for (hotelId, pbhotel) in proto.hotels {
            let hotelIdString = String(hotelId)
            let hotel = HDKHotel(fromCityDumpHotelProto: pbhotel,
                                 hotelId: hotelIdString,
                                 districtsDict: districtsDict,
                                 poiDict: poiDict,
                                 trustyouDict: trustyouDict,
                                 knownGuests: knownGuestsByHotelId[hotelIdString],
                                 shortAmenitiesDict: hotelsAmenities,
                                 hotelRoomsPhotoPreviewInfo: hotelsRoomsPhotoPreviewInfo[hotelIdString])

            let cityId = String(pbhotel.locationID)
            if hotelsByCityId[cityId] == nil {
                hotelsByCityId[cityId] = []
            }
            hotelsByCityId[cityId]!.append(hotel)
        }

        var cities: [String: HDKLocationInfoResponse] = [:]
        for (cityId, pblocation) in proto.locations {
            let cityIdString = String(cityId)

            let hotels = hotelsByCityId[cityIdString] ?? []

            let city = HDKCity(proto: pblocation, pois: poiDict)

            cities[cityIdString] = HDKLocationInfoResponse(city: city, hotels: hotels)
        }

        self.cities = cities
    }

}

public class HDKLocationInfoResponse: NSObject {
    public let hotels: [HDKHotel]
    public let city: HDKCity

    public init(city: HDKCity, hotels: [HDKHotel]) {
        self.city = city
        self.hotels = hotels
    }
}
