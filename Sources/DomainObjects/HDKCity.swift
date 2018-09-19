@objcMembers
public final class HDKCity: NSObject, NSCoding, NSCopying {
    public let cityId: String
    public let name: String?
    public let latinName: String?
    public let fullName: String?
    public let countryName: String?
    public let countryLatinName: String?
    public let countryCode: String?
    public let state: String?
    public let latitude: Double
    public let longitude: Double
    public let cityCode: String?
    public let hotelsCount: Int
    public let points: [HDKLocationPoint]
    public let seasons: [HDKSeason]

    internal init(proto: PBLocation, pois: [String: HDKLocationPoint] = [:]) {
        cityId = String(proto.id)
        name = proto.name
        latinName = proto.latinName
        fullName = proto.fullName
        countryName = proto.countryName
        countryLatinName = proto.latinCountryName
        countryCode = String(proto.countryID)
        state = proto.stateCode
        latitude = Double(proto.centerCoords.lat)
        longitude = Double(proto.centerCoords.lon)
        cityCode = proto.code
        hotelsCount = Int(proto.propertyTypesCount.total)
        points = proto.poisIds.compactMap { pois[String($0)] }
        seasons = proto.seasons.flatMap { category, pbseason -> [HDKSeason] in
            var seasonDates: [PBLocation.SeasonDate] = []
            if pbseason.hasCurrentSeason {
                seasonDates.append(pbseason.currentSeason)
            }
            if pbseason.hasNextSeason {
                seasonDates.append(pbseason.nextSeason)
            }
            return seasonDates.compactMap { try? HDKSeason(proto: $0, category: category) }
        }
    }

    public init(cityId: String,
                name: String? = nil,
                latinName: String? = nil,
                fullName: String? = nil,
                countryName: String? = nil,
                countryLatinName: String? = nil,
                countryCode: String? = nil,
                state: String? = nil,
                latitude: Double = 0,
                longitude: Double = 0,
                hotelsCount: Int = 0,
                cityCode: String? = nil,
                points: [HDKLocationPoint] = [],
                seasons: [HDKSeason] = []) {

        self.cityId = cityId
        self.name = name
        self.latinName = latinName
        self.fullName = fullName
        self.countryName = countryName
        self.countryLatinName = countryLatinName
        self.countryCode = countryCode
        self.state = state
        self.latitude = latitude
        self.longitude = longitude
        self.hotelsCount = hotelsCount
        self.cityCode = cityCode
        self.points = points
        self.seasons = seasons
    }

    public func isValid() -> Bool {
        guard let name = name, latitude != 0, longitude != 0 else {
            return false
        }

        return name.count > 0
    }

    private func hasPoints(with category: String) -> Bool {
        return points.hdk_atLeastOneConfirms { $0.category == category }
    }

    public func seasonCategory(at checkIn: Date, and checkOut: Date) -> String {
        for season in seasons {

            if season.contains(checkIn: checkIn, orCheckOut: checkOut) {

                if season.category == HDKSeason.kBeachSeasonCategory && !hasPoints(with: HDKLocationPointCategory.kBeach) {
                    continue
                }
                if season.category == HDKSeason.kSkiSeasonCategory && !hasPoints(with: HDKLocationPointCategory.kSkilift) {
                    continue
                }

                return season.category
            }
        }

        return HDKSeason.kNoSeasonCategory
    }

    public static func citiesIds(fromCities cities: [HDKCity]) -> [String] {
        return Array(Set(cities.map { $0.cityId }))
    }

    // MARK: - isEqual

    override public func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? HDKCity else { return false }

        if cityId != other.cityId {
            return false
        }

        return true
    }

    override public var hash: Int {
        return cityId.hash
    }

    // MARK: - NSCoding

    public init?(coder aDecoder: NSCoder) {
        guard let cityId = aDecoder.decodeObject(forKey: "cityId") as? String else {
            return nil
        }

        self.cityId = cityId

        name = aDecoder.decodeObject(forKey: "name") as? String
        latinName = aDecoder.decodeObject(forKey: "latinName") as? String
        fullName = aDecoder.decodeObject(forKey: "fullName") as? String
        countryName = aDecoder.decodeObject(forKey: "countryName") as? String
        countryLatinName = aDecoder.decodeObject(forKey: "countryLatinName") as? String
        countryCode = aDecoder.decodeObject(forKey: "countryCode") as? String
        state = aDecoder.decodeObject(forKey: "state") as? String
        latitude = aDecoder.decodeDouble(forKey: "latitude")
        longitude = aDecoder.decodeDouble(forKey: "longitude")
        cityCode = aDecoder.decodeObject(forKey: "cityCode") as? String
        hotelsCount = aDecoder.decodeInteger(forKey: "hotelsCount")
        points = (aDecoder.decodeObject(forKey: "points") as? [HDKLocationPoint]) ?? []
        seasons = (aDecoder.decodeObject(forKey: "seasons") as? [HDKSeason]) ?? []
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(cityId, forKey: "cityId")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(latinName, forKey: "latinName")
        aCoder.encode(fullName, forKey: "fullName")
        aCoder.encode(countryName, forKey: "countryName")
        aCoder.encode(countryLatinName, forKey: "countryLatinName")
        aCoder.encode(countryCode, forKey: "countryCode")
        aCoder.encode(state, forKey: "state")
        aCoder.encode(latitude, forKey: "latitude")
        aCoder.encode(longitude, forKey: "longitude")
        aCoder.encode(cityCode, forKey: "cityCode")
        aCoder.encode(hotelsCount, forKey: "hotelsCount")
        aCoder.encode(points, forKey: "points")
        aCoder.encode(seasons, forKey: "seasons")
    }

    // MARK: - NSCopying

    public func copy(with zone: NSZone? = nil) -> Any {
        let archived = NSKeyedArchiver.archivedData(withRootObject: self)
        return NSKeyedUnarchiver.unarchiveObject(with: archived)!
    }
}
