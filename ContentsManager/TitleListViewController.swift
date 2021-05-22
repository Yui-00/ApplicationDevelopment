//
//  TitleListViewController.swift
//  ContentsManager
//
//  Created by 日野原唯人 on 2021/05/07.
//

import UIKit
import RealmSwift

class TitleListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //ここで
    
    @IBOutlet weak var titleListTableView: UITableView!
    private let cellid = "cellid"

    //前の画面から受け取るジャンル名を入れるはこ
    var genre = ""
    
    // Realmのインスタンスを取得
    let titleItem = try! Realm()
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //cell is how
        let titleItemList = titleItem.objects(TitleItem.self).filter("genre == %@", genre)
        return titleItemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let titleItemList = titleItem.objects(TitleItem.self).filter("genre == %@", genre)
        
        let cell = titleListTableView.dequeueReusableCell(withIdentifier: cellid) as! TitleListTableViewCell
        
        let temp = titleItemList[indexPath.row]
        
        cell.titleName.text = temp.title
        cell.addDate!.text = temp.addDay
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleListTableView.dataSource = self
        titleListTableView.delegate = self
        
        navigationController?.navigationBar.barTintColor = .rgb(red: 39, green: 49, blue: 69)
        navigationItem.title = genre
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        let RightAddButton = UIBarButtonItem(title: "新規追加", style: .plain, target: self, action: #selector(tappedNavRightBarButton))
        navigationItem.rightBarButtonItem = RightAddButton
        navigationItem.rightBarButtonItem?.tintColor = .white
        
    }
    
    @objc private func tappedNavRightBarButton(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "NewTitle", bundle: nil)//遷移先のStoryboardを設定
        let nextView = storyboard.instantiateViewController(withIdentifier: "NewTitleViewController") as! NewTitleViewController//遷移先のViewControllerを設定
        
        nextView.genre = genre
        
        self.navigationController?.pushViewController(nextView, animated: true)//遷移する
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let titleItemList = titleItem.objects(TitleItem.self).filter("genre == %@", genre)
      
        let deleteAction = UIContextualAction(style: .destructive,title: "削除"){(action, view, completionHandler) in
            
            try! self.titleItem.write {
                self.titleItem.delete(titleItemList[indexPath.row])
            }
            
            self.titleListTableView.reloadData()
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "NewTitle", bundle: nil)//遷移先のStoryboardを設定
        let nextView = storyboard.instantiateViewController(withIdentifier: "NewTitleViewController") as! NewTitleViewController//遷移先のViewControllerを設定
        
        
        
        self.navigationController?.pushViewController(nextView, animated: true)//遷移する
    }
    
    /// 画面再表示
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titleListTableView.reloadData()
    }
     
    
}

class TitleListTableViewCell: UITableViewCell{
    
    @IBOutlet weak var titleName: UILabel!
    
    @IBOutlet weak var addDate: UILabel!
    
    @IBOutlet weak var addImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func tapCellButton(_ sender: UIButton) {
        print("hello")
    }
    
}


