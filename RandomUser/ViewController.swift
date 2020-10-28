//
//  ViewController.swift
//  RandomUser
//
//  Created by anny on 2020/10/23.
//  Copyright © 2020 anny. All rights reserved.
//

import UIKit
import AudioToolbox

struct User {
    var name: String?
    var phone: String?
    var email: String?
    var image: String?
}

struct AllData:Codable {
    var results: [SingleData]
}

struct SingleData:Codable {
    var name: Name
    var email: String
    var phone: String
    var picture: Picture
}

struct Name:Codable {
    var first: String
    var last: String
}

struct Picture:Codable {
    var large: String
}


class ViewController: UIViewController {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    var infoTableViewController: InfoTableViewController?
    let apiAddress = "https://randomuser.me/api/"
    var isDownloading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downoadInfo(withAddress: apiAddress)
    }
    
    
    @IBAction func makeNewUser(_ sender: UIBarButtonItem) {
        if isDownloading == false{
            downoadInfo(withAddress: apiAddress)
        }
    }
    
    func downoadInfo(withAddress webAddress: String){
        if let url = URL(string: apiAddress){
            let task = URLSession.shared.dataTask(with: url, completionHandler: {
                (data, response, error) in
                if error != nil{
                    let errorCode = (error! as NSError).code
                    if errorCode == -1009{
                        DispatchQueue.main.async {
                            self.showAlert(title: "目前沒有連結網路")
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.showAlert(title: "發生錯誤！！！")
                        }
                    }
                    self.isDownloading = false
                    return
                }
                if let loadedData = data {
                    do{
                        let userData = try JSONDecoder().decode(AllData.self, from: loadedData)
                        let userName = userData.results[0].name.first + " " + userData.results[0].name.last
                        let userEmail = userData.results[0].email
                        let userPhone = userData.results[0].phone
                        let userPicture = userData.results[0].picture.large
                        let user = User(name: userName, phone: userPhone, email: userEmail, image: userPicture)
                        
                        DispatchQueue.main.async {
                            self.setInfo(user: user)
                        }
                    }
                    catch{
                        DispatchQueue.main.async {
                            self.showAlert(title: "發生錯誤！！！")
                        }
                        self.isDownloading = false
                    }
                }else{
                    self.isDownloading = false
                }
            })
            task.resume()
            isDownloading = true
        }
    }
    
    func showAlert(title:String){
        let alert = UIAlertController(title: title, message: "請稍後再試！", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func setInfo(user: User){
        userName.text = user.name ?? ""
        infoTableViewController?.userPhone.text = user.phone ?? ""
        infoTableViewController?.userEmail.text = user.email ?? ""
        
        if let imageAddress = user.image, let url = URL(string: imageAddress){
            let task = URLSession.shared.downloadTask(with: url, completionHandler: {
                (url,  response, error) in
                if error != nil{
                    DispatchQueue.main.async {
                        self.showAlert(title: "發生錯誤！！！")
                    }
                    self.isDownloading = false
                    return
                }
                if let urlImage = url{
                    do{
                        let userImage = UIImage(data: try Data(contentsOf: urlImage))
                        DispatchQueue.main.async {
                            self.userImage.image = userImage
                            AudioServicesPlayAlertSound(1000)
                        }
                        self.isDownloading = false
                    }
                    catch{
                        DispatchQueue.main.async {
                            self.showAlert(title: "發生錯誤！！！")
                        }
                        self.isDownloading = false
                    }
                }else{
                    self.isDownloading = false
                }
            })
            task.resume()
        }else{
            isDownloading = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Info"{
            infoTableViewController = segue.destination as? InfoTableViewController
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 圓形圖片
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
        userImage.clipsToBounds = true
    }


}

