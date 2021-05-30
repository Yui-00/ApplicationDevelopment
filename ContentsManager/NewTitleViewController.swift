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
    
    //前画面からジャンル名を受け取る
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
    
    //ふりがなを取得する関数
    func changeToKatakanaString(str: String) -> String {

        let inputText = str as NSString

        let outputText = NSMutableString()

        var range: CFRange = CFRangeMake(0, inputText.length)
        let locale: CFLocale = CFLocaleCopyCurrent()

        /* トークナイザーを作成 */
        let tokenizer: CFStringTokenizer = CFStringTokenizerCreate(kCFAllocatorDefault, inputText as CFString, range, kCFStringTokenizerUnitWordBoundary, locale)

        /* 最初の位置に */
        var tokenType: CFStringTokenizerTokenType = CFStringTokenizerGoToTokenAtIndex(tokenizer, 0)

        /* 形態素解析 */
        while tokenType != [] {
            range = CFStringTokenizerGetCurrentTokenRange(tokenizer)

            /* ローマ字を得る */
            let latin: CFTypeRef = CFStringTokenizerCopyCurrentTokenAttribute(tokenizer, kCFStringTokenizerAttributeLatinTranscription)
            let romaji = latin as! NSString

            /* カタカナに変換 */
            let furigana: NSMutableString = romaji.mutableCopy() as! NSMutableString
            CFStringTransform(furigana as CFMutableString, nil, kCFStringTransformLatinKatakana, false)

            outputText.append(furigana as String)
            tokenType = CFStringTokenizerAdvanceToNextToken(tokenizer)
        }

        return outputText as String
    }
    
    @objc private func tappedNavRightBarButton(_ sender: Any) {
       
        let name: String = titleName.text!
        
        //重複チェック
        //まず現在選択してるジャンルのリストを取得する
        let list = titleItem.objects(TitleItem.self).filter("genre == %@", genre)
        
        for i in 0..<list.count {
            
            if list[i].title == name{
                print("existance")
                DuplicateAlert()
                return
            }
        }
        
        let newTitle = TitleItem()
        //並び替えのためにルビをつける
        let furi = changeToKatakanaString(str: name)
        
        //新規レコードに値を付与
        newTitle.genre = genre
        newTitle.title = name
        newTitle.furi = furi
        newTitle.addDay = Date()
        newTitle.review = 4.5
        
        //れるむに追加
        try! titleItem.write {
            titleItem.add(newTitle)
        }
        
        //一個前の画面に遷移
        self.navigationController?.popViewController(animated: true)
    }
    
    func DuplicateAlert(){
        //アラートのスタイル
        let alert: UIAlertController = UIAlertController(title: "重複エラー", message: "そのタイトルはすでに存在しています", preferredStyle:  UIAlertController.Style.alert)
        
        // ボタンのアクションを設定
        let closeAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("OK")
        })
        
        //UIAlertControllerにActionを追加
        alert.addAction(closeAction)
        
        //アラートの表示
        present(alert, animated: true, completion: nil)
    }
    
    
}
