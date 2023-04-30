import SwiftUI
import UserNotifications


struct MedsContentView: View {
    
    @ObservedObject var medsModel: MedsExpiration
    
    @State private var permissionGranted = true
    @State private var dragName = ""
    @State private var expirationDate = Date()
    @State private var daysToShowNottification = 1

    var body: some View {
        VStack {
            Text("MedsExp")
                .font(.largeTitle).padding([.top, .leading, .trailing])
            textFieldBody
            plusMinusButtons
            nottificationButtons
        }
        .onAppear {
            doOnAppear()
        }
        .padding()
        .accentColor(.blue)
    }
    
    var textFieldBody: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Drug name", text: $dragName)
                    DatePicker("Expiration date",
                               selection: $expirationDate, displayedComponents: .date)
                    Stepper(value: $daysToShowNottification, in: 1...100, step: 1) {
                        Text("Show notification beffore: \(daysToShowNottification) days")
                    }
                }
            }
        }
        
        
    }
    
    var oneWeek: some View {
        HStack {
            Button(action: { daysToShowNottification += 7 }, label: { Image(systemName: "plus.circle") })
            Text("Week")
            Button(action: { daysToShowNottification =
                (daysToShowNottification > 7) ?
                (daysToShowNottification - 7) :
                daysToShowNottification },
                   label: { Image(systemName: "minus.circle") })
        }.padding().dynamicTypeSize(/*@START_MENU_TOKEN@*/.xxxLarge/*@END_MENU_TOKEN@*/)
    }
    
    var oneMonth: some View {
        HStack {
            Button(action: { daysToShowNottification += 30 }, label: { Image(systemName: "plus.circle") })
            Text("Month")
            Button(action: { daysToShowNottification =
                (daysToShowNottification > 30) ?
                (daysToShowNottification - 30) :
                daysToShowNottification },
                   label: { Image(systemName: "minus.circle") })
        }.padding().dynamicTypeSize(/*@START_MENU_TOKEN@*/.xxxLarge/*@END_MENU_TOKEN@*/)    }
    
    var plusMinusButtons: some View {
        HStack {
            oneWeek
            Spacer()
            oneMonth
        }
    }
    
    var nottificationButtons: some View {
        ZStack {
            if permissionGranted {
                HStack {
                    Button("Save") {
                        medsModel.sendNotification(
                            test: false,
                            dragName: dragName,
                            daysToShowNottification: daysToShowNottification,
                            expirationDate: expirationDate)
                    }
                    Spacer()
                    Button("Test") {
                    medsModel.sendNotification(
                        test: true,
                        dragName: dragName,
                        daysToShowNottification: daysToShowNottification,
                        expirationDate: expirationDate)
                    }
                }.padding()
            } else {
                Button("Please give permision") {
                    medsModel.requestPermissions()
                }
            }
        }.padding([.leading, .bottom, .trailing]).dynamicTypeSize(/*@START_MENU_TOKEN@*/.xxxLarge/*@END_MENU_TOKEN@*/)
    }
    
    var space: some View {
        GeometryReader { _ in EmptyView() }
    }
    
    private func doOnAppear() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                permissionGranted = true
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let meds = MedsExpiration()
        MedsContentView(medsModel: meds)
            .preferredColorScheme(.dark)
    }
}
