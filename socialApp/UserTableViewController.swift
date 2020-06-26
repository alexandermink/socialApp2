//
//  UserTableViewController.swift
//  socialApp
//
//  Created by Александр Минк on 19.05.2020.
//  Copyright © 2020 Alexander Mink. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class User {
    let id: Int
    var name: String = ""
    var lastname: String = ""
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.name = json["first_name"].stringValue
        self.lastname = json["last_name"].stringValue
    }
    
//    convenience init(json: [String:Any]) {
////        let id = json["id"] as! Int
////        self.init(id: id)
////        self.name = json["name"] as! String
////        self.lastname = json["lastname"] as! String
//        let id = json["items"] as! Int
//        self.init(id: id)
//    }
}

class UserTableViewController: UITableViewController {
    
    

    let users: [UserList] = [UserList(name: "Alex", lastName: "Blooman", avatar: UIImage(named: "1")!),
        UserList(name: "Max", lastName: "Freeman", avatar: UIImage(named: "2")!),
        UserList(name: "John", lastName: "Travolta", avatar: UIImage(named: "3")!),
        UserList(name: "Pit", lastName: "Digger", avatar: UIImage(named: "4")!)]
    
    var filteredUsers: [UserList] = []
    
    var searchState: Bool = false
    
    var selectedRow: Int = 0
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var gesture = UITapGestureRecognizer()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

       getFriends(5)
    }
    
    func search(text: String) {
        filteredUsers.removeAll()
        if text.count == 0 {
            self.searchState = false
            self.tableView.reloadData()
        } else {
            self.searchState = true
        }
        
        for item in users {
            if item.name.lowercased().contains(text.lowercased()) || item.lastName.lowercased().contains(text.lowercased()) {
                filteredUsers.append(item)
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest: UserCollectionViewController = segue.destination as! UserCollectionViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            dest.users = users
            dest.selectedRow = indexPath.row
        }
    }

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchState {
            if filteredUsers.count == 0 {
                return 0
            } else {
                return filteredUsers.count
            }
        } else {
            return users.count
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "SomeCell", for: indexPath) as! TableViewCell
        
        if searchState {
            if filteredUsers.count == 0 {
                cell.avatarControl.avatar.image = UIImage()
                cell.nameLabel.text = ""
                cell.lastNameLabel.text = ""
            } else {
                cell.avatarControl.avatar.image = filteredUsers[indexPath.row].avatar
                cell.nameLabel.text = filteredUsers[indexPath.row].name
                cell.lastNameLabel.text = filteredUsers[indexPath.row].lastName
            }
        } else {
            
            cell.avatarControl.avatar.image = users[indexPath.row].avatar
            cell.avatarControl.addGestureRecognizer(gesture)
            
            cell.nameLabel.text = users[indexPath.row].name
            cell.lastNameLabel.text = users[indexPath.row].lastName
        }
        
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if (cell?.imageView?.image) != nil {
            print("hello")
        }
    }
    
 

}


extension UserTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.search(text: searchText)
    }
}

struct UserList {
    var name: String
    var lastName: String
    var avatar: UIImage
}



//func getFriends(_ count: Int) {
//    AF.request("https://api.vk.com/method/friends.get?order=hints&count=\(count)&access_token=\(Session.instance.token)&v=5.110").responseJSON { (response) in
//        print(response)
//    }
//}


func getFriends(_ count: Int){
    AF.request("https://api.vk.com/method/friends.get?order=hints&count=\(count)&fields=status&access_token=\(Session.instance.token)&v=5.110").responseJSON { (response) in
//        //print(response)
//
//        switch response.result {
////        case.success(let value):
////            print(value)
////            let array = response.value
////            print(array[0])
////        case.failure(let error):
////            print(error)
//        case .success(let value):
//            print("value", value)
//
//            guard let jsonArray = response.value as? [[String: Any]] else { return }
//
//            print("________________________________")
//            print("items: ", jsonArray)
//            print("1 object: ", jsonArray[0])
//            print("id: ", jsonArray[0]["id"]!)
//        case .failure(let error):
//            print(error)
//            print("________________________________")
////
//       }
        
        
//        let json = try? JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.mutableContainers)
        
        

        //let array = json as! [[String:Any]]

        //let ids = array.map { User(json: $0)}
        
        //print(ids)
        
        
        guard let json = try? JSON(data: response.data!) else {return}
        
        print(json)
        
        let users = json.map(User(json: $0.))
        
        
        
    }
}
