@objcMembers
public final class HDKAutocompleteResponse: NSObject {
    public let hotels: [HDKHotel]
    public let cities: [HDKCity]
    public let airports: [HDKAirport]

    internal init(proto: PBCompleteResponse) {

        let citiesMap = proto.locations.hdk_map { cityId, pbcity in
            return (String(cityId), HDKCity(proto: pbcity))
        }

        hotels = proto.hotels.compactMap { pbhotel in
            guard let city = citiesMap[String(pbhotel.locationID)] else {
                assertionFailure()
                return nil
            }
            return HDKHotel(autocompleteProto: pbhotel, city: city)
        }
        cities = proto.cities.map { HDKCity(proto: $0) }
        airports = proto.airports.map { HDKAirport(proto: $0) }
    }
}
