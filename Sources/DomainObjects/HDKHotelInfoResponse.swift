import Foundation

public class HDKHotelInfoResponse: NSObject {

    let hotels: [HDKHotel]

    internal init(proto: PBHotelInfoResponse) {
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

        let citiesDict: [String: HDKCity] = proto.locations.hdk_map { cityId, pbcity in
            let cityIdString = String(cityId)
            let city = HDKCity(proto: pbcity, pois: poiDict)
            return (cityIdString, city)
        }

        hotels = proto.hotels.map { hotelId, pbhotel in
            let hotelIdString = String(hotelId)
            let city = citiesDict[String(pbhotel.locationID)]

            let hotel = HDKHotel(fromHotelDetailsProto: pbhotel,
                                 hotelId: hotelIdString,
                                 districtsDict: districtsDict,
                                 poiDict: poiDict,
                                 trustyouDict: trustyouDict,
                                 city: city)
            return hotel
        }
    }
}
