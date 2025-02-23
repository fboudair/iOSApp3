//
//  RomStoreDevData.swift
//  Chapter22
//
//  Created by Louise Rennick on 2025-02-19.
//

import Foundation

extension RomStore {
    
      func createDevData() {
        objects = [
          Object(
            objectID: 28263,
            title: "An Esquimaux,Portrait of Ogemawwah Chack, The Spirit Chief, Inuit",
            creditLine: "1849-1856",
            objectURL: "https://collections.rom.on.ca/internal/media/dispatcher/28263/preview",
            isPublicDomain: true,
            primaryImageSmall: "https://collections.rom.on.ca/internal/media/dispatcher/28263/preview"),
          Object(
            objectID: 241715,
            title: "Terracotta oil lamp",
            creditLine: "The Cesnola Collection, Purchased by subscription, 1874–76",
            objectURL: "https://www.metmuseum.org/art/collection/search/241715",
            isPublicDomain: false,
            primaryImageSmall: ""),
          Object(
            objectID: 452648,
            title: "Gushtasp Slays the Rhino-Wolf",
            creditLine: "Bequest of Monroe C. Gutman, 1974",
            objectURL: "https://www.metmuseum.org/art/collection/search/452648",
            isPublicDomain: true,
            primaryImageSmall: "https://images.metmuseum.org/CRDImages/is/web-large/DP108572.jpg")
        ]
      }
    }

