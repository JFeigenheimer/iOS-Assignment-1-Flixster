//
//  MoviesViewController.swift
//  flixster
//
//  Created by Jacob on 9/20/21.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var tableView: UITableView!
    
    var movies = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

                    // TODO: Get the array of movies
                    // TODO: Store the movies in a property to use elsewhere
                    // TODO: Reload your table view data
                self.movies = dataDictionary["results"] as! [[String:Any]]
                
                self.tableView.reloadData() // Calls the functions again.
                print(dataDictionary)
                
             }
        }
        task.resume()
    }
    // These functions are originally only called when the screen is brought up, but the movies will not have been picked up yet. So movies.count is originally considered 0. Need the tableview.reloadData().
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    // Function is called 50 times to display rows.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell//reuseable cells recycles offscreen cells. Taking of identifier 'MovieCell' class / object
        
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String// "title" derived from the json for the movie titles
        let synopsis = movie["overview"] as! String
        //cell.textLabel!.text = title (Used previously)
        
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        cell.posterView.af.setImage(withURL: posterUrl!) // af.setImage comes from dependency
        
        
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        // Tasks are:
        // 1. Find the selected movie
        let cell = sender as! UITableViewCell  // Cell that was tapped on
        let indexPath = tableView.indexPath(for: cell)! // path for that cell
        let movie = movies[indexPath.row] // access the array for that path.
        // 2. Pass the selected movie to the details view controller.
        let detailsViewController = segue.destination as! MovieDetailsViewController
        detailsViewController.movie = movie
        
        tableView.deselectRow(at: indexPath, animated:true) // stops the highlighting for cell
    }
    /*
    // Notes for Flix part 1:
     To design to create arbitrary custom cell
     design cell
     create swift file
     Click cell, and place in custom class and views identifier
     Go to views controller and use dequeue method to then gain access to cell methods: cell.titleLabel.text, cell.synopsisLabel.text
     
     Had to install pods inorder to use dependency AlamofireImage
     
     Also in views properties for image set to aspect fill, using clip to bounds so that
     it will spill over, causing an image to fill the view, and clip the edges.
    */

}
