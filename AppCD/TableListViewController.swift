//
//  ViewController.swift
//  AppCD
//
//  Created by Кирилл Крамар on 30.06.2020.
//  Copyright © 2020 Кирилл Крамар. All rights reserved.
//

import UIKit

class TableListViewController: UITableViewController {
    
    //MARK: - Private Property
    private var tasks: [Task] = []
    private let cellID = "cell"
    
    //MARK : - Life Cycles ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tasks = StoredManager.shared.fetchTask() ?? []
    }
    
    //MARK : - Override Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            StoredManager.shared.deleteTask(for: indexPath.row)
            tasks.remove(at: indexPath.row)
            let deleteIndexPath = IndexPath(row: indexPath.row, section: 0)
            tableView.deleteRows(at: [deleteIndexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        changeTaskAlert(with: "Сhange task", and: "Enter change", for: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK : - Private Property
    private func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        let navBarApperance = UINavigationBarAppearance()
        navBarApperance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarApperance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarApperance.configureWithOpaqueBackground()
        navBarApperance.backgroundColor = UIColor(red: 21/255,
                                                  green: 101/255,
                                                  blue: 192/255,
                                                  alpha: 194/255)
        navigationController?.navigationBar.standardAppearance = navBarApperance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarApperance
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addTask))
        navigationController?.navigationBar.tintColor = .white
        
        
    }
    
    private func addTaskAlert(with title: String, and message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save",style: .default) { [weak self] _ in
            guard let self = self else { return }
            guard let title = alert.textFields?.first?.text , !title.isEmpty else { return }
            StoredManager.shared.saveTask(title: title)
            self.tasks = StoredManager.shared.fetchTask() ?? []
            let indexPath = IndexPath(row: self.tasks.count - 1, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField()
        present(alert,animated: true)
        
    }
    private func changeTaskAlert(with title: String, and message: String,for index: Int) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Change",style: .default) { [weak self] _ in
            guard let self = self else { return }
            guard let title = alert.textFields?.first?.text , !title.isEmpty else { return }
            StoredManager.shared.changeTask(for: index, newTitle: title)
            self.tasks[index].title = title
            let indexPath = IndexPath(row: index, section: 0)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField()
        alert.textFields?.first?.text = tasks[index].title
        present(alert,animated: true)
    }
    
    //MARK : - Selectors
    @objc private func addTask() {
        addTaskAlert(with: "New Task", and: "What do you want to do")
    }
}

