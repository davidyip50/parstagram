//
//  FeedViewController.swift
//  Parstagram
//
//  Created by David Yip on 2/17/19.
//  Copyright © 2019 David Yip. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage
import MessageInputBar


class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageInputBarDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [PFObject]()
    let commentBar  = MessageInputBar()
    var shownCommentBar = false
    var selectPost: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentBar.inputTextView.placeholder = "Add a comment.."
        commentBar.sendButton.title = "Post"
        commentBar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.keyboardDismissMode = .interactive
        // Do any additional setup after loading the view.
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeHidden(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillBeHidden(note: Notification) {
        commentBar.inputTextView.text = nil
        shownCommentBar = false
        becomeFirstResponder()
    }
    
  
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let query = PFQuery(className:"Posts")
        //fetching the actual data stored inside the pointer
        query.includeKeys(["author","comments", "comments.author"])
        query.limit = 20
        
        query.findObjectsInBackground { ( posts, error) in
            if posts != nil{
                self.posts  = posts!
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let post = posts[section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        
        return comments.count + 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.section]
       
        
        let comments = (post["comments"] as? [PFObject]) ?? []
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell") as! PostTableViewCell
            let user = post["author"] as! PFUser
            
            cell.userLabel.text = user.username
            cell.captionLabel.text = post["caption"] as! String
            
            let imageFile = post["image"]  as! PFFileObject
            
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
            
            cell.photoView.af_setImage(withURL: url)
            
            return cell
        }else if indexPath.row <= comments.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell") as! commentCell
            let comment = comments[indexPath.row - 1]
            cell.commentLabel.text = comment["text"] as? String
            
            let user = comment["author"] as! PFUser
            cell.userLabel.text = user.username
            
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "addComment")!
            return cell
        }
    }

    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOut()
        
        let main = UIStoryboard(name: "Main",
                                bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        delegate.window?.rootViewController = loginViewController
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.section]
        let comments = post["comments"] as? [PFObject] ?? []
        
        if indexPath.row == comments.count + 1
        {
            shownCommentBar = true
            becomeFirstResponder()
            commentBar.inputTextView.becomeFirstResponder()
            
            selectPost = post
        }
        
        /*
         
            */
    }
    
    override var inputAccessoryView: UIView?{
        return commentBar
    }
    
    override var canBecomeFirstResponder: Bool{
        return shownCommentBar
    }
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        let comment = PFObject(className: "Comments")
        
        comment["text"] = text
        comment["post"] = selectPost
        comment["author"] = PFUser.current()!
        
        selectPost.add(comment, forKey: "comments")
        
        selectPost.saveInBackground { (success, error) in
            if success{
                print("Comment save")
            }
            else{
                print("error saving comment")
            }
            
            // tableView.reloadData()
            
            self.commentBar.inputTextView.text = nil
            self.shownCommentBar = false
            self.becomeFirstResponder()
            self.commentBar.inputTextView.resignFirstResponder()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
