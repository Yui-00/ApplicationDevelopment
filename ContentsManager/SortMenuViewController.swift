//
//  SortMenuViewController.swift
//  ContentsManager
//
//  Created by 日野原唯人 on 2021/05/29.
//

import UIKit
import RealmSwift

class SortMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var sortMenuTableView: UITableView!
    let sortList = ["追加順", "タイトル順"]
    var genre = ""
    
    let realmInstance = try! Realm()
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        sortMenuTableView.dataSource = self
        sortMenuTableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //cell is how
        return sortList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = sortMenuTableView.dequeueReusableCell(withIdentifier: "sortCell") as! SortMenuTableViewCell
        
        cell.sortName.text = sortList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let realm = try! Realm()
        let resutls = realm.objects(ContentItem.self).filter("content == %@", genre)
        
        try! realm.write {
            resutls[0].sortNumber = indexPath.row
            
        }
        
        self.navigationController?.popViewController(animated: true)
        
        print(resutls[0].sortNumber)
    }
}


class SortMenuTableViewCell: UITableViewCell{
    
    
    @IBOutlet weak var sortName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super .setSelected(selected, animated: animated)
    }
    
    
}

