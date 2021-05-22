//
//  ContentItem.swift
//  ContentManagement
//
//  Created by 田口翔也 on 2021/05/16.
//

import Foundation
import RealmSwift

class ContentItem: Object {
    @objc dynamic var content: String? = nil
}
