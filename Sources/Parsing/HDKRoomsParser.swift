internal class HDKRoomsParser {

    func collectRooms(forDataChunk proto: PBSearchResultResponse,
                      gatesNamesMap: [String: String],
                      toDictionary hotelIdToRooms: inout [String: [HDKRoom]]) {

        for (hotelIdInt, pbhotel) in proto.hotels {
            let hotelId = String(hotelIdInt)

            let rooms = pbhotel.proposals.map { HDKRoom(proto: $0, hotelId: hotelId, gatesNamesMap: gatesNamesMap) }

            if hotelIdToRooms[hotelId] == nil {
                hotelIdToRooms[hotelId] = [HDKRoom]()
            }
            hotelIdToRooms[hotelId]?.append(contentsOf: rooms)
        }

        if proto.hotelsHighlights.count > 0 {
            addHighlights(proto.hotelsHighlights, toRooms: &hotelIdToRooms)
        }

        if proto.hotelsDiscounts.count > 0 {
            addDiscounts(proto.hotelsDiscounts, toRooms: &hotelIdToRooms)
        }
    }

    private func addHighlights(_ highlights: [UInt32: PBSearchResultResponse.Highlights], toRooms hotelIdToRooms: inout [String: [HDKRoom]]) {
        for (hotelIdString, rooms) in hotelIdToRooms {
            for room in rooms {
                guard let hotelId = UInt32(hotelIdString) else { continue }
                guard let gateId = UInt32(room.gate.gateId) else { continue }
                guard let roomId = UInt32(room.roomId) else { continue }

                guard let highlightType = highlights[hotelId]?.gates[gateId]?.room[roomId] else {
                    continue
                }

                room.highlightTypeString = highlightType
            }
        }
    }

    private func addDiscounts(_ discounts: [UInt32: PBSearchResultResponse.Discount], toRooms hotelIdToRooms: inout [String: [HDKRoom]]) {
        for (hotelIdString, rooms) in hotelIdToRooms {
            for room in rooms {
                guard let hotelId = UInt32(hotelIdString) else { continue }
                guard let gateId = UInt32(room.gate.gateId) else { continue }
                guard let roomId = UInt32(room.roomId) else { continue }

                guard let discountInfo = discounts[hotelId]?.gatesRooms[gateId]?.discounts[roomId] else { continue }
                room.discount = Int(discountInfo.changePercentage)
                room.oldPrice = discountInfo.oldPrice
            }
        }
    }

}
