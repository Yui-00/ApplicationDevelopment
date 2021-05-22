//
//  TitleItem.swift
//  ContentsManager
//
//  Created by 日野原唯人 on 2021/05/10.
//

import UIKit
import RealmSwift

class TitleItem: Object {
    @objc dynamic var genre: String? = nil
    @objc dynamic var title: String? = nil
    @objc dynamic var addDay: String? = nil
    @objc dynamic var review: String? = nil
}
