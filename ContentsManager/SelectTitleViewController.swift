//
//  selectTitle.swift
//  ContentsManager
//
//  Created by 日野原唯人 on 2021/05/27.
//

import UIKit
import RealmSwift

class SelectTitleViewController: UIViewController{
    
    @IBOutlet weak var titleField: UITextField!
    
    var karititle = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.text = karititle
    }
}
