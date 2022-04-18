//
//  RegistrationManager.swift
//  Registr
//
//  Created by Simon Andersen on 10/03/2022.
//

import Foundation
import FirebaseFirestore

class RegistrationManager: ObservableObject {
    
    // Collections
    @Published var registrations = [Registration]()
    @Published var students = [Student]()
    @Published var classes = [String]()
    @Published var studentRegistrationList = [Registration]()
    
    // Firestore db reference
    private let db = Firestore.firestore()
    
    // Selectors
    private var selectedClass = String()
    private var selectedDate = String()
    private var selectedStudent = String()
    
    // Counters
    private var illegalCounter: Int64 = 0
    private var illnessCounter: Int64 = 0
    private var lateCounter: Int64 = 0
    
    init() {
        fetchClasses()
    }
    
    func setAbsenceReason(absenceReason: String, index: Int) {
        registrations[index].reason = absenceReason
    }
    
    // MARK: - Firestore actions
    /**
     Fetches all the registration of a selected class and will not fetch repeatedly if the selected class or date has not changed.
     
     - parameter className:      The unique name specifier of the class
     - parameter date:           A date string in the format: dd-MM-yyyy
     */
    func fetchRegistrations(className: String, date: String) {
        // If 'selectedClass' is the same as the className input we have already fetched the registration.
        // In this case will not have to fetch it again.
        if selectedClass != className || selectedDate != date {
            registrations.removeAll()
            selectedClass = className
            selectedDate = date
            
            db
                .collection("fb_classes_path".localize)
                .document(className)
                .collection("fb_date_path".localize)
                .document(date)
                .collection("fb_registrations_path".localize)
                .getDocuments() {  (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            do {
                                if let registration = try document.data(as: Registration.self) {
                                    self.registrations.append(registration)
                                    self.registrations.sort {
                                        $0.studentName < $1.studentName
                                    }
                                }
                            }
                            catch {
                                print(error)
                            }
                        }
                    }
                }
        }
    }
    
    // Retrieves every class name
    func fetchClasses() {
        db
            .collection("fb_classes_path".localize)
            .getDocuments { querySnapshot, err in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        self.classes.append(document.documentID)
                    }
                }
            }
    }
    
    /**
     Retrieves all the students' data from a given class
     
     - parameter className:      The unique name specifier of the class
     */
    func fetchStudents(className: String) {
        if selectedClass != className {
            students.removeAll()
            selectedClass = className
            
            db
                .collection("fb_classes_path".localize)
                .document(className)
                .collection("fb_students_path".localize)
                .getDocuments { querySnapshot, err in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let studentID = document.documentID
                            self.db.collection("fb_students_path".localize)
                                .document(studentID)
                                .getDocument { studentDoc, error in
                                    if let data = studentDoc {
                                        do {
                                            if let student = try data.data(as: Student.self) {
                                                self.students.append(student)
                                                self.students.sort {
                                                    $0.name < $1.name
                                                }
                                            }
                                        }
                                        catch {
                                            print(error)
                                        }
                                    }
                                }
                        }
                    }
                }
        }
    }
    
    /**
     Retrieves all the students' data from a given class
     
     - parameter className:      The unique name specifier of the class.
     - parameter date:           A date string in the format: dd-MM-yyyy.
     - parameter completion:     A Callback that returns if the write to the database went through.
     */
    func saveRegistrations(className: String, date: String, completion: @escaping (Bool) -> ()) {
        if !registrations.isEmpty {
            // Create new write batch that will pushed at the same time.
            let batch = db.batch()
            
            for (var registration) in registrations {
                if !registration.reason.isEmpty {
                    let registrationRef = db
                        .collection("fb_classes_path".localize)
                        .document(className)
                        .collection("fb_date_path".localize)
                        .document(date)
                        .collection("fb_registrations_path".localize)
                        .document(registration.studentID)
                    
                    let registrationStudentRef = db
                        .collection("fb_students_path".localize)
                        .document(registration.studentID)
                        .collection("fb_absense_path".localize)
                        .document(date)
                    
                    registration.isAbsenceRegistered = true
                    
                    do {
                        batch.updateData(["reason" : registration.reason, "isAbsenceRegistered": true], forDocument: registrationRef)
                        try batch.setData(from: registration, forDocument: registrationStudentRef)
                    } catch {
                        print("Decoding failed")
                    }
                } else if registration.isAbsenceRegistered && registration.reason.isEmpty {
                    let registrationRef = db
                        .collection("fb_classes_path".localize)
                        .document(className)
                        .collection("fb_date_path".localize)
                        .document(date)
                        .collection("fb_registrations_path".localize)
                        .document(registration.studentID)
                    
                    let registrationStudentRef = db
                        .collection("fb_students_path".localize)
                        .document(registration.studentID)
                        .collection("fb_absense_path".localize)
                        .document(date)
                    
                    
                    batch.updateData(["reason" : registration.reason, "isAbsenceRegistered" : false], forDocument: registrationRef)
                    batch.deleteDocument(registrationStudentRef)
                }
            }
            
            // Writing our big batch of data to firebase
            batch.commit() { err in
                if let err = err {
                    print("Error writing batch \(err)")
                    completion(false)
                } else {
                    print("Batch write succeeded.")
                    completion(true)
                    self.writeClassStats(className: className)
                }
            }
        }
    }
    
    func fetchStudentAbsence(studentID: String) {
        if selectedStudent != studentID {
            studentRegistrationList.removeAll()
            
            db
                .collection("fb_students_path".localize)
                .document(studentID)
                .collection("fb_absense_path".localize)
                .getDocuments { querySnapshot, err in
                    if let err = err {
                        // TODO: Error Handling
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            do {
                                if let registration = try document.data(as: Registration.self) {
                                    self.studentRegistrationList.append(registration)
                                }
                            }
                            catch {
                                print(error)
                            }
                        }
                    }
                }
        }
    }
    
    // MARK: - Class Statistics
    
    func resetStatCounters() {
        illnessCounter = 0; illegalCounter = 0; lateCounter = 0
    }
    
    private func writeClassStats(className: String) {
        let statisticsClassRef = db
            .collection("fb_classes_path".localize)
            .document(className)
        
        // If one of the following counters are zero we do not want to use them
        if illegalCounter != 0 {
            statisticsClassRef.updateData(["illegal" : FieldValue.increment(illegalCounter)])
        }
        
        if illnessCounter != 0 {
            statisticsClassRef.updateData(["illness" : FieldValue.increment(illnessCounter)])
        }
        
        if lateCounter != 0 {
            statisticsClassRef.updateData(["late" : FieldValue.increment(lateCounter)])
        }
    }
    
    func updateClassStatistics(oldValue: String, newValue: String) {
        // If the new value is empty and old is not, it means we have removed a field and do not have to increment.
        if newValue.isEmpty && !oldValue.isEmpty {
            decrementCounters(value: oldValue)
        } else {
            // We are in- & decrementing the respective counters
            incrementCounters(value: newValue)
            decrementCounters(value: oldValue)
        }
    }
    
    private func incrementCounters(value: String) {
        switch value {
        case AbsenceReasons.illegal.rawValue:
            illegalCounter += 1
        case AbsenceReasons.illness.rawValue:
            illnessCounter += 1
        case AbsenceReasons.late.rawValue:
            lateCounter += 1
        default:
            break
        }
    }
    
    private func decrementCounters(value: String) {
        switch value {
        case AbsenceReasons.illegal.rawValue:
            illegalCounter -= 1
        case AbsenceReasons.illness.rawValue:
            illnessCounter -= 1
        case AbsenceReasons.late.rawValue:
            lateCounter -= 1
        default:
            break
        }
    }
}
