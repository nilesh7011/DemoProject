//
//  ViewController.swift
//  DemoProject
//
//  Created by m8nilesh on 01/05/24.
//

import UIKit

struct Post: Codable {
    let id: Int
    let title: String
    // Add more properties if needed
}

class tableviewcell : UITableViewCell{
    
    @IBOutlet weak var backview: UIView!
    
    @IBOutlet weak var idlbl: UILabel!
    
    @IBOutlet weak var titlelbl: UILabel!
    
}


class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var btn: UIButton!
    var posts: [Post] = []
       var currentPage = 1
    var postId: Int?
       var detailText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btn.layer.cornerRadius = 50
        btn.layer.masksToBounds = true
        tableView.delegate = self
               tableView.dataSource = self
               
               // Fetch initial data
               fetchData(page: currentPage)
    }
    func fetchData(page: Int) {
           guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts?_page=\(page)") else {
               print("Invalid URL")
               return
           }
        URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, error == nil else {
                        print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                        return
                    }
                    
                    do {
                        let fetchedPosts = try JSONDecoder().decode([Post].self, from: data)
                        self.posts.append(contentsOf: fetchedPosts)
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    } catch {
                        print("Error decoding data: \(error.localizedDescription)")
                    }
                }.resume()
            }

   }

//tableview
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableviewcell", for: indexPath) as! tableviewcell
        let post = posts[indexPath.row]
        cell.idlbl.text = "ID: \(post.id)"
        cell.titlelbl.text = "TITLE: \(post.title)"
        
       print( "ID: \(post.id), Title: \(post.title)")
        cell.backview.layer.cornerRadius = 5
        cell.backview.layer.masksToBounds = true
        cell.backview.layer.shadowOpacity = 0.5
        cell.backview.layer.shadowRadius = 1.0
        cell.backview.layer.shadowOffset = CGSize.zero
        cell.backview.layer.shadowColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha:1).cgColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = posts.count - 1
        if indexPath.row == lastElement {
            currentPage += 1
            fetchData(page: currentPage)
        }
    }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let post = posts[indexPath.row]
            
            // Perform heavy computation and log the time taken
            let startTime = CFAbsoluteTimeGetCurrent()
            let result = performHeavyComputation(post: post)
            let endTime = CFAbsoluteTimeGetCurrent()
            let elapsedTime = endTime - startTime
            print("Heavy computation time for post \(post.id): \(elapsedTime) seconds")
            
            // Proceed with displaying the result or performing other actions
            print("Heavy computation result: \(result)")
        }
        
        // Placeholder function for heavy computation
        func performHeavyComputation(post: Post) -> String {
            // Simulate heavy computation
            var result = ""
            for _ in 0..<1_000_000 {
                result = "\(post.id): \(post.title)"
            }
            return result
        }
    func heavyComputation(postId: Int) -> String {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        // Simulate heavy computation
        var result = "Computed result for post ID \(postId)"
        for _ in 0..<1_000_000 {
            // Simulate computation
            result = result.uppercased()
        }
        
        let endTime = CFAbsoluteTimeGetCurrent()
        let elapsedTime = endTime - startTime
        print("Heavy computation time for post ID \(postId): \(elapsedTime) seconds")
        
        return result
    }
}


extension ViewController {
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationVC = segue.destination as! DetailViewController
                destinationVC.postId = posts[indexPath.row].id
                
                let postId = posts[indexPath.row].id
                                
                                // Check if the result is already computed, otherwise compute it
                                
                                // Pass necessary data to the detailed view controller
                                destinationVC.postId = postId
            }
        }

        
        
    }
}
