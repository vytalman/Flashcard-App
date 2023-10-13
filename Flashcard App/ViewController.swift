//
//  ViewController.swift
//  Flashcard App
//
//  Created by Ryan Mesa on 4/20/23.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var cardContentLabel: UILabel!
    @IBOutlet weak var subjectTextField: UITextField!
    
    enum DisplayMode {
        case questionFirst
        case answerFirst
    }
    var currentDisplayMode: DisplayMode = .questionFirst
    
    var managedObjectContext: NSManagedObjectContext!
    var listOfCards = [Flashcard]()
    var currentCard: Flashcard?
    var listOfSubjects = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        fetchCards()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchCards()
    }
    
    func fetchCards() {
        let fetchRequest: NSFetchRequest<Flashcard> = Flashcard.fetchRequest()
        
        do {
            listOfCards = try managedObjectContext.fetch(fetchRequest)
            print("Flashcards fetched successfully")
            //printCards()
            if !listOfCards.isEmpty {
                for card in listOfCards {
                    if !listOfSubjects.contains(card.subject!) {
                        listOfSubjects.append(card.subject!)
                    }
                }
            }
        } catch {
            print("Could not fetch data from managedObjectContext")
        }
    }
    
    func printCards() {
        for card in listOfCards {
            print(card.question!)
            print(card.answer!)
        }
    }

    @IBAction func chooseDisplayModeAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0:
                currentDisplayMode = .questionFirst
            case 1:
                currentDisplayMode = .answerFirst
            default:
                currentDisplayMode = .questionFirst
        }
    }
    
    func displayCard() {
        if listOfCards.count < 1 {
            cardContentLabel.text = "No cards to display"
            return
        }
        let randomIndex = Int(arc4random_uniform(UInt32(listOfCards.count)))
        currentCard = listOfCards[randomIndex]
        if let displayCard = currentCard {
            guard let subjectText = subjectTextField.text else { return }
            if subjectText == "" {
                displayQuestionOrAnswer(cardToDisplay: displayCard)
            } else if !listOfSubjects.contains(subjectText) {
                cardContentLabel.text = "No cards with that subject"
            } else if displayCard.subject == subjectText {
                displayQuestionOrAnswer(cardToDisplay: displayCard)
            } else {
                self.displayCard()
            }
        } else {
            cardContentLabel.text = "No cards to display"
        }
    }
    
    func displayQuestionOrAnswer(cardToDisplay card: Flashcard) {
        switch currentDisplayMode {
            case .questionFirst:
                cardContentLabel.text = card.question
            case .answerFirst:
                cardContentLabel.text = card.answer
        }
    }
    
    @IBAction func swipeUpAction(_ sender: UISwipeGestureRecognizer) {
        displayCard()
    }
    
    @IBAction func swipeRightAction(_ sender: UISwipeGestureRecognizer) {
        if let card = currentCard {
            cardContentLabel.text = card.question
        }
    }
    
    @IBAction func swipeLeftAction(_ sender: UISwipeGestureRecognizer) {
        if let card = currentCard {
            cardContentLabel.text = card.answer
        }
    }
    
    @IBAction func deleteCardAction(_ sender: UIButton) {
        if currentCard == nil {
            return
        } else {
            managedObjectContext.delete(currentCard!)
        }
        
        do {
            try managedObjectContext.save()
            print("Flashcard deleted successfully")
            fetchCards()
            displayCard()
        } catch {
            print("Could not save managedObjectContext state, flashcard not deleted")
        }
    }

}

