//
//  ViewController.swift
//  project-7
//
//  Created by Pipe Carrasco on 23-08-21.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(showMessageInfo))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(filterAlert))
        
        //let urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        
        performSelector(inBackground: #selector(fetchJSON), with: nil)
    }
    
    @objc func fetchJSON(){
        let urlString: String
        if navigationController?.tabBarItem.tag == 0{
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        }else{
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url){
                // we're OK to parse
                parse(json: data)
                return
            }
        }
        
        //performSelector(onMainThread: #selector(showMessage(title: "Loading error", message: "There was a problem loading feed; please check your connection and try again.")), with: nil, waitUntilDone: false)
        performSelector(onMainThread: #selector(showMessageInfo), with: nil, waitUntilDone:     false)
    }
    
    @objc func showMessageInfo(){
        showMessage(title: "Information", message: "you're using API We The People API of the Whitehouse.")
    }
    
    @objc func filterAlert(){
        
        let ac = UIAlertController(title: "Filter", message: "Word to search", preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] action in
            
            guard let text = ac?.textFields?[0].text else { return }
            //self?.addProductToList(product)
            self?.filterListNews(by: text)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        ac.addAction(submitAction)
        ac.addAction(cancelAction)
        present(ac, animated: true)
        
        
        
    }
    
    func filterListNews(by text: String){
        let petitionsAux: [Petition] = petitions.filter { $0.body.lowercased().contains(text.lowercased()) }
        petitions = petitionsAux
        tableView.reloadData()
        print(petitionsAux)
    }
    
    @objc func showMessage(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
        
    }
    
    func parse(json: Data){
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
            
        }else{
            performSelector(onMainThread: #selector(showMessageInfo), with: nil, waitUntilDone: false)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        
    }
}

