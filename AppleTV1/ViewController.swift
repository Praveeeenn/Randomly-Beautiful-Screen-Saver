//
//  ViewController.swift
//  AppleTV1
//
//  Created by Praveen on 27/02/20.
//  Copyright © 2020 Praveen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private var categories = ["Airplanes", "Beaches", "Bridges", "Cats", "Cities", "Dogs",
    "Earth", "Forest", "Galaxies", "Landmarks", "Mountains", "People", "Roads", "Sports",
    "Sunsets"
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
}
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let title = self.categories[indexPath.row]
        cell.textLabel?.text = title
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(self.categories[indexPath.row])
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ImagesViewController") as? ImagesViewController else { return }
        vc.category = categories[indexPath.row]
        self.present(vc, animated: true, completion: nil)
    }
}
