//
//  NewTitleViewController.swift
//  ContentsManager
//
//  Created by 日野原唯人 on 2021/05/22.
//

import UIKit
import RealmSwift

class NewTitleViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    // Realmのインスタンスを取得
    let titleItem = try! Realm()
    
    var genre = ""
    var str = ""
    
    @IBOutlet weak var titleName: UITextField!
    @IBOutlet weak var memo: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        
        memo.layer.borderColor = UIColor.black.cgColor
        
        navigationController?.navigationBar.barTintColor = .rgb(red: 39, green: 49, blue: 69)
        navigationItem.title = genre
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        let RightAddButton = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(tappedNavRightBarButton))
        navigationItem.rightBarButtonItem = RightAddButton
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        titleName.text = str
    }
    
    @objc private func tappedNavRightBarButton(_ sender: Any) {
       
        let name = titleName.text
        let newTitle = TitleItem()
        newTitle.genre = genre
        newTitle.title = name
        newTitle.addDay = "2021/05/12"
        try! titleItem.write {
            titleItem.add(newTitle)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
