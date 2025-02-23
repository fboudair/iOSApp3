struct MuseumItem: Codable {
    let id: String
    let itemType: String?
    let docRepository: String
    let docCollectionName: String
    let docTitle: String?
    let docOtherTitle: String?
    let docExtent: String?
    let docOriginalDate: String?
    let docScope: String?
    let docLocation: String?
    let docLegacyID: String?
    let docKeywords: String?
    let docRights: String?
    let docRecord_Created: String?
    let docRecord_LastUpdated: String?
    let docRecord_CreatedEpoch: String?
    let docRecord_LastUpdatedEpoch: String?
    let docWebThumb: String?
    let docWebImage: String?
    let objType: String?
    enum CodingKeys: String, CodingKey {
        case id, itemType, docRepository, docCollectionName, docTitle, docOtherTitle,
             docExtent, docOriginalDate, docScope, docLocation, docLegacyID,
             docKeywords, docRights, docRecord_Created, docRecord_LastUpdated,
             docRecord_CreatedEpoch, docRecord_LastUpdatedEpoch, docWebThumb, docWebImage,
             objType
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        itemType = try container.decodeIfPresent(String.self, forKey: .itemType)
        docRepository = try container.decode(String.self, forKey: .docRepository)
        docCollectionName = try container.decode(String.self, forKey: .docCollectionName)
        docTitle = try container.decodeIfPresent(String.self, forKey: .docTitle)
        docOtherTitle = try container.decodeIfPresent(String.self, forKey: .docOtherTitle)
        docExtent = try container.decodeIfPresent(String.self, forKey: .docExtent)
        docOriginalDate = try container.decodeIfPresent(String.self, forKey: .docOriginalDate)
        docScope = try container.decodeIfPresent(String.self, forKey: .docScope)
        docLocation = try container.decodeIfPresent(String.self, forKey: .docLocation)
        docLegacyID = try container.decodeIfPresent(String.self, forKey: .docLegacyID)
        docKeywords = try container.decodeIfPresent(String.self, forKey: .docKeywords)
        docRights = try container.decodeIfPresent(String.self, forKey: .docRights)
        docRecord_Created = try container.decodeIfPresent(String.self, forKey: .docRecord_Created)
        docRecord_LastUpdated = try container.decodeIfPresent(String.self, forKey: .docRecord_LastUpdated)
        docWebThumb = try container.decodeIfPresent(String.self, forKey: .docWebThumb)
        docWebImage = try container.decodeIfPresent(String.self, forKey: .docWebImage)
        objType = try container.decodeIfPresent(String.self, forKey: .objType)

        docRecord_CreatedEpoch = MuseumItem.decodeEpoch(from: container, forKey: .docRecord_CreatedEpoch)
        docRecord_LastUpdatedEpoch = MuseumItem.decodeEpoch(from: container, forKey: .docRecord_LastUpdatedEpoch)
    }

    private static func decodeEpoch(from container: KeyedDecodingContainer<CodingKeys>, forKey key: CodingKeys) -> String? {
        if let intValue = try? container.decode(Int.self, forKey: key) {
            return String(intValue)
        } else if let stringValue = try? container.decode(String.self, forKey: key) {
            return stringValue
        } else {
            return nil
        }
    }

    func toObject() -> Object {
        let objectID = Int(id) ?? -1
        let defaultImage = "https://example.com/default.jpg"

        return Object(
            objectID: objectID,
            title: docTitle ?? "Unknown Title",
            creditLine: objType ?? "Unknown Type",
            objectURL: docWebImage ?? defaultImage,
            isPublicDomain: true,
            primaryImageSmall: docWebThumb ?? docWebImage ?? defaultImage
        )
    }
}
