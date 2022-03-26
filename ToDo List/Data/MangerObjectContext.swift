//
//  MangerObjectContext.swift
//  ToDo List
//
//  Created by Idwall Go Dev 001 on 26/03/22.
//

import Foundation
import UIKit
import CoreData

// This is used to return the result of database request
enum DataResult {
    case Success
    case Error(String)
}

// callback to return the result
typealias onCompletion = (DataResult) -> Void

protocol managedProtocol {
    func save(task: Task, onCompletion: onCompletion)
}

protocol managedDeleteProtocol {
    func delete(uuid: String, onCompletion: onCompletion)
}

protocol managedListProtocol {
    func list(onCompletion: onCompletion) -> [Task]
}

protocol managedUpdateProtocol {
    func update(task: Task, onCompletion: onCompletion)
}

class ManagedObjectContext {
    private let entity = "Task_"
    
    static var shared: ManagedObjectContext = {
        let instance = ManagedObjectContext()
        
        return instance
    }()
        
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.persistentContainer.viewContext
    }
    
    func saveData(_ task: Task, id: UUID?) throws {
        let context = getContext();
        
        guard let entity = NSEntityDescription.entity(forEntityName: entity, in: context) else { return }
        
        let transaction = NSManagedObject(entity: entity, insertInto: context)
        
        transaction.setValue(id ?? task.id, forKey: "id")
        transaction.setValue(task.title, forKey: "title")
        transaction.setValue(task.status, forKey: "status")
        transaction.setValue(task.description, forKey: "taskDescription")
        
        try context.save()
    }
}

extension ManagedObjectContext: managedProtocol {
    func save(task: Task, onCompletion: (DataResult) -> Void) {
        do {
            try saveData(task, id: UUID())
        } catch {
            onCompletion(.Error("Erro ao salvar dados"))
        }
    }
}

extension ManagedObjectContext: managedListProtocol {
    func list(onCompletion: (DataResult) -> Void) -> [Task] {
        var taskList: [Task] = []
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity)
        
        do {
            
            guard let tasks = try getContext().fetch(fetchRequest) as? [NSManagedObject] else { return taskList}
            
            for item in tasks {
                if let id = item.value(forKey: "id") as? UUID,
                   let description = item.value(forKey: "taskDescription") as? String,
                   let status = item.value(forKey: "status") as? Bool,
                   let title = item.value(forKey: "title") as? String
                {
                    let task = Task(id: id, description: description, status: status, title: title)
                    
                    taskList.append(task)
                }
            }
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return taskList
    }
}

extension ManagedObjectContext: managedDeleteProtocol {
    func delete(uuid: String, onCompletion: (DataResult) -> Void) {
        let context = getContext()
        
        let predicate = NSPredicate(format: "id == %@", "\(uuid)")
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity)
                
        fetchRequest.predicate = predicate
        
        do {
            
            let fetchResults = try context.fetch(fetchRequest) as! [NSManagedObject]
            
            if let entityToDelete = fetchResults.first {
                context.delete(entityToDelete)
            }
            
            try context.save()
            
            onCompletion(.Success)
            
        } catch let error as NSError {
            print(error.localizedDescription)
            onCompletion(.Error("Erro ao deletar os dados"))
        }
    }
}

extension ManagedObjectContext: managedUpdateProtocol {
    func update(task: Task, onCompletion: (DataResult) -> Void) {
        let context = getContext()
        
        let predicate = NSPredicate(format: "id == %@", "\(task.id)")
    
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity)
                
        fetchRequest.predicate = predicate
        
        do {
            
            let fetchResults = try context.fetch(fetchRequest) as! [NSManagedObject]
            
            if let entityToDelete = fetchResults.first {
                context.delete(entityToDelete)
            }
            
            try context.save()
            
            onCompletion(.Success)
            
            try saveData(task, id: nil)
            
        } catch let error as NSError {
            print(error.localizedDescription)
            onCompletion(.Error("Erro ao deletar os dados"))
        }
        
        
    }
}




