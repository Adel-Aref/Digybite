//
//  CoreDataHelper.swift
//  DigybiteTask
//
//  Created by Adel Aref on 29/11/2023.
//

import Foundation
import UIKit
import CoreData


class CoreDataHelper {
    static let shared = CoreDataHelper()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    private lazy var mainManagedObjectContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    private lazy var privateManagedObjectContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = mainManagedObjectContext
        return privateContext
    }()
    
    private func saveMainContext() {
        if mainManagedObjectContext.hasChanges {
            do {
                try mainManagedObjectContext.save()
            } catch {
                print("Error saving main managed object context: \(error)")
            }
        }
    }
    
    private func savePrivateContext() {
        if privateManagedObjectContext.hasChanges {
            do {
                try privateManagedObjectContext.save()
            } catch {
                print("Error saving private managed object context: \(error)")
            }
        }
    }
    
    private func saveChanges() {
        savePrivateContext()
        mainManagedObjectContext.performAndWait {
            saveMainContext()
        }
    }
    
    func saveData<T: NSManagedObject>(objects: [T]) {
        privateManagedObjectContext.perform {
            // Insert the objects into the private context
            for object in objects {
                self.privateManagedObjectContext.insert(object)
            }
            
            // Save changes to the private context and merge to the main context
            self.saveChanges()
        }
    }
    
    func createNewGameEntity(_ games: [GameModel]) {
        for game in games {
            let newGameEntity = GameEntity(context: context)
            newGameEntity.id = game.id
            newGameEntity.name = game.name ?? ""
            newGameEntity.gameDescription = game.description ?? ""
            newGameEntity.imagePath = game.backgroundImage
            newGameEntity.reddit = game.redditUrl
            newGameEntity.website = game.website
            newGameEntity.isRead = game.isRead ?? false
            newGameEntity.isFavorite = game.isFavorite ?? false
            let newGenreEntity = GenreEntity(context: context)
            for genre in game.genres ?? [] {
                newGenreEntity.id = Int32(genre.id)
                newGenreEntity.name = genre.name ?? ""
            }
            newGameEntity.addToGenres(newGenreEntity)
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
    
    func fetchGames(completion: @escaping (([GameModel])->Void)) {
        let fetchRequest = NSFetchRequest<GameEntity>(entityName: "GameEntity")
        do {
            let results = try context.fetch(fetchRequest)
            let games = results.map { entity in
                let genreEntities = entity.genres?.allObjects as? [GenreEntity]
                    let genreModels = genreEntities?.map { GenreModel(from: $0) }                                
                return GameModel(id: entity.id,
                                 name: entity.name,
                                 backgroundImage: entity.imagePath, description: entity.gameDescription,
                                 website: entity.website, redditUrl: entity.reddit, genres: genreModels,
                                 isFavorite: entity.isFavorite, isRead: entity.isRead)
                
            }
            completion(games)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func updateGameFavorite(isFavorite: Bool, id: Int32) {
        let fetchRequest: NSFetchRequest<GameEntity> = GameEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", String(id))

        do {
            let entities = try context.fetch(fetchRequest)
            if let entityToUpdate = entities.first {
                entityToUpdate.isFavorite = isFavorite
                try context.save()
            }
        } catch let error as NSError {
            // Handle error
            print("Error fetching: \(error), \(error.userInfo)")
        }
    }
    
    func updateGameIsRead(isRead: Bool, id: Int32) {
        let fetchRequest: NSFetchRequest<GameEntity> = GameEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", String(id))

        do {
            let entities = try context.fetch(fetchRequest)
            if let entityToUpdate = entities.first {
                entityToUpdate.isRead = isRead
                try context.save()
            }
        } catch let error as NSError {
            // Handle error
            print("Error fetching: \(error), \(error.userInfo)")
        }
    }
    
    func updateData<T: NSManagedObject>(objects: [T]) {
        privateManagedObjectContext.perform {
            // Update the objects in the private context
            for object in objects {
                if object.managedObjectContext == self.privateManagedObjectContext {
                    // If the object is already in the private context, update it directly
                    object.managedObjectContext?.refresh(object, mergeChanges: true)
                } else {
                    // If the object is not in the private context, fetch and update it
                    let fetchRequest = NSFetchRequest<T>(entityName: object.entity.name!)
                    fetchRequest.predicate = NSPredicate(format: "SELF == %@", object)
                    fetchRequest.fetchLimit = 1
                    
                    if let fetchedObject = try? self.privateManagedObjectContext.fetch(fetchRequest).first {
                        fetchedObject.setValuesForKeys(object.dictionaryWithValues(forKeys: object.entity.attributesByName.keys.map { $0 }))
                    }
                }
            }
            
            // Save changes to the private context and merge to the main context
            self.saveChanges()
        }
    }
    
    func deleteData<T: NSManagedObject>(objects: [T]) {
        privateManagedObjectContext.perform {
            // Delete the objects from the private context
            for object in objects {
                if object.managedObjectContext == self.privateManagedObjectContext {
                    self.privateManagedObjectContext.delete(object)
                } else {
                    if let objectInContext = self.privateManagedObjectContext.object(with: object.objectID) as? T {
                        self.privateManagedObjectContext.delete(objectInContext)
                    }
                }
            }
            
            // Save changes to the private context and merge to the main context
            self.saveChanges()
        }
    }
}
    
