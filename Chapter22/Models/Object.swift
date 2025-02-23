//
//  Object.swift
//  Chapter22
//
//  Created by Louise Rennick on 2025-02-19.
//

import Foundation

struct Object: Codable, Hashable {
  let objectID: Int
  let title: String
  let creditLine: String
  let objectURL: String
  let isPublicDomain: Bool
  let primaryImageSmall: String
}

struct ObjectIDs: Codable {
  let total: Int
  let objectIDs: [Int]
}
