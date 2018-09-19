import CoreLocation

internal extension CLLocation {
    internal convenience init(proto: PBCoords) {
        self.init(latitude: CLLocationDegrees(proto.lat), longitude: CLLocationDegrees(proto.lon))
    }
}
