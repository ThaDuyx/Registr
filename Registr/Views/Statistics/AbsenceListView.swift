//
//  AbsenceListView.swift
//  Registr
//
//  Created by Christoffer Detlef on 01/04/2022.
//

import SwiftUI

struct AbsenceListView: View {
    @EnvironmentObject var childrenViewModel: ChildrenViewModel
    @StateObject var errorHandling = ErrorHandling()
    @State var showModal = false
    
    var selectedStudent: String
    var studentName: String
    let student: Student
    
    init(selectedStudent: String, studentName: String, student: Student) {
        self.selectedStudent = selectedStudent
        self.studentName = studentName
        self.student = student
    }
    
    var body: some View {
        ZStack {
            List() {
                Section(
                    header: Text("al_intervals".localize)
                        .bigBodyTextStyle(color: .fiftyfifty, font: .poppinsMedium)
                ) {
                    ForEach(childrenViewModel.absences, id: \.self) { absence in
                        if absence.studentID == selectedStudent && absence.endDate != nil {
                            AbsenceReportSection(absence: absence)
                                .padding(.bottom, 20)
                        }
                    }
                    .listRowSeparator(.hidden)
                }
                Section(
                    header: Text("al_absences_days".localize)
                        .bigBodyTextStyle(color: .fiftyfifty, font: .poppinsMedium)
                ) {
                    ForEach(childrenViewModel.absences, id: \.self) { absence in
                        if absence.studentID == selectedStudent && absence.endDate == nil {
                            AbsenceReportSection(absence: absence)
                                .padding(.bottom, 20)
                                .sheet(isPresented: $showModal) {
                                    ParentAbsenceRegistrationView(report: nil, absence: absence, child: student, shouldUpdate: false, isAbsenceChange: true)
                                }
                                .onTapGesture {
                                    showModal = true
                                }
                        }
                    }
                    .listRowSeparator(.hidden)
                }
                
            }
            .fullScreenCover(item: $errorHandling.appError, content: { appError in
                ErrorView(title: appError.title, error: appError.description) {
                    childrenViewModel.fetchChildren(parentID: DefaultsManager.shared.currentProfileID) { result in
                        if result {
                            childrenViewModel.attachAbsenceListeners()
                        }
                    }
                    childrenViewModel.attachReportListeners()
                }
            })
            .navigationTitle(studentName)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    struct AbsenceListView_Previews: PreviewProvider {
        static var previews: some View {
            AbsenceListView(selectedStudent: "", studentName: "", student: Student(name: "", className: "", email: "", classInfo: ClassInfo(isDoubleRegistrationActivated: false, name: "", classID: ""), associatedSchool: "", cpr: ""))
        }
    }
}
