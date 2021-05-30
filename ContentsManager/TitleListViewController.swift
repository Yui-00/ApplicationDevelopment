//
//  TitleListViewController.swift
//  ContentsManager
//
//  Created by 日野原唯人 on 2021/05/07.
//

import UIKit
import RealmSwift
import Cosmos

class TitleListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //ここで
    
    @IBOutlet weak var titleListTableView: UITableView!
    private let cellid = "cellid"

    //前の画面から受け取るジャンル名を入れるはこ
    var genre = ""
    
    let titleItem = try! Realm()
    var titleItemList: Results<TitleItem>!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleListTableView.dataSource = self
        titleListTableView.delegate = self
        
        titleItemList = titleItem.objects(TitleItem.self).filter("genre == %@", genre)
        
        tableSort()
        
        navigationController?.navigationBar.barTintColor = .rgb(red: 39, green: 49, blue: 69)
        navigationItem.title = genre
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        let rightAddButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tappedNavRightBarButton))
        navigationItem.rightBarButtonItem = rightAddButton
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        let rightSortButton = UIBarButtonItem(title: "並び替え", style: .done, target: self, action: #selector(tappedNavRightBarSortButton))
        navigationItem.rightBarButtonItem = rightSortButton
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        self.navigationItem.rightBarButtonItems = [rightAddButton,  rightSortButton]
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //cell is how
        return titleItemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = titleListTableView.dequeueReusableCell(withIdentifier: cellid) as! TitleListTableViewCell
        
        let temp = titleItemList[indexPath.row]
        
        cell.titleName.text = temp.title
        cell.review.settings.fillMode = .half
        cell.review.rating = Double(temp.review)
        
        //日付
        //データベースから日付を取得
        let date = temp.addDay
        
        //日付のフォーマットを指定する。
        let format = DateFormatter()
        format.dateFormat = "yyyy/MM/dd"
                
        //日付をStringに変換する
        let sDate = format.string(from: date)
        
        cell.addDate.text! = sDate
        
        return cell
    }
    
    
    @objc private func tappedNavRightBarButton(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "NewTitle", bundle: nil)//遷移先のStoryboardを設定
        let nextView = storyboard.instantiateViewController(withIdentifier: "NewTitleViewController") as! NewTitleViewController//遷移先のViewControllerを設定
        
        nextView.genre = genre
        
        self.navigationController?.pushViewController(nextView, animated: true)//遷移する
    }
    
    @objc private func tappedNavRightBarSortButton(_ sender: Any) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "SortMenu", bundle: nil)//遷移先のStoryboardを設定
        let nextView = storyboard.instantiateViewController(withIdentifier: "SortMenuViewController") as! SortMenuViewController//遷移先のViewControllerを設定
        
        nextView.genre = genre
        
        self.navigationController?.pushViewController(nextView, animated: true)//遷移する
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
      
        let deleteAction = UIContextualAction(style: .destructive,title: "削除"){(action, view, completionHandler) in
            
            try! self.titleItem.write {
                self.titleItem.delete(self.titleItemList[indexPath.row])
            }
            
            self.titleListTableView.reloadData()
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectTitle = titleItemList[indexPath.row]
        
        
        let storyboard: UIStoryboard = UIStoryboard(name: "SelectTitle", bundle: nil)//遷移先のStoryboardを設定
        let nextView = storyboard.instantiateViewController(withIdentifier: "SelectTitleViewController") as! SelectTitleViewController//遷移先のViewControllerを設定
        
        nextView.karititle = selectTitle.title!
        
        self.navigationController?.pushViewController(nextView, animated: true)//遷移する
    }
    
    /// 画面再表示
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableSort()
        
        self.titleListTableView.reloadData()
    }
    
    //sort func
    func tableSort() {
        //sortの種類を取得
        let realm = try! Realm()
        let resutls = realm.objects(ContentItem.self).filter("content == %@", genre)
        let snum = resutls[0].sortNumber
        
        if snum == 0 {
            titleItemList = titleItemList.sorted(byKeyPath: "addDay")
        } else if snum == 1{
            titleItemList = titleItemList.sorted(byKeyPath: "furi")
        }
    }
     
    
}

class TitleListTableViewCell: UITableViewCell{
    
    @IBOutlet weak var titleName: UILabel!
    
    @IBOutlet weak var addDate: UILabel!
    
    @IBOutlet weak var addImageView: UIImageView!
    
    @IBOutlet weak var review: CosmosView!
    
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


