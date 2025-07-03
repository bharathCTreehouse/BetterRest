//
//  ContentView.swift
//  BetterRest
//
//  Created by Bharath Chandrashekar on 18/06/25.
//

import SwiftUI
import CoreML

/*struct ContentView: View {
    @State private var sleepDurationHrs: Double = 7.0
    @State private var wakeUpTime: Date = Date.now
    @ViewBuilder var body: some View {
        Stepper("Sleep for \(sleepDurationHrs.formatted()) hours", value: $sleepDurationHrs, in: 4.0 ... 12.0, step: 0.25).padding()
        
        DatePicker("Select date", selection: $wakeUpTime, in: Date.now..., displayedComponents: [.date, .hourAndMinute]).labelsHidden()
    }
}*/

/*struct BetterRestContentView: View {
    @State private var wakeUpTime: Date = Date.now
    @State private var sleepDurationHrs: Double = 7.0
    @State private var coffeeIntake: Int = 1
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    var body: some View {
        NavigationStack {
            Form {
                //Spacer()
                VStack(alignment: .leading, spacing: 10.0) {
                    Text("When do you wish to wake up?").font(.headline)
                    DatePicker("Enter time", selection: $wakeUpTime, displayedComponents: .hourAndMinute).labelsHidden()
                }
                //Spacer()
                
                VStack(alignment: .leading, spacing: 0.0) {
                    Text("Desired amount of sleep").font(.headline)
                    Stepper("\(sleepDurationHrs.formatted()) hours", value: $sleepDurationHrs, in: 4 ... 9, step: 0.25).padding()
                }
                //Spacer()
                
                VStack(alignment: .leading, spacing: 0.0) {
                    Text("Daily coffee intake").font(.headline)
                    Stepper("\(coffeeIntake) cup(s)", value: $coffeeIntake, in: 1 ... 20).padding()
                }
                //Spacer()
            }.navigationTitle("BetterRest").navigationBarTitleDisplayMode(.automatic).toolbar {
                Button("Calculate", action: calculateBedTime).alert(alertTitle, isPresented: $showingAlert) {
                    Button("OK", action: {})
                } message: {
                    Text(alertMessage)
                }
            }
        }
    }
    
    private func calculateBedTime() {
        do {
            let modelConfig: MLModelConfiguration = MLModelConfiguration()
            let sleepCalcModel: SleepCalculator = try SleepCalculator(configuration: modelConfig)
            
            let dateComp: DateComponents = Calendar.current.dateComponents([.hour, .minute], from: wakeUpTime)
            let wakeUpHourSeconds: Int = (dateComp.hour ?? 0) * 60 * 60
            let wakeUpMinSeconds: Int = (dateComp.minute ?? 0) * 60
            let totalWakeUpSeconds: Int = wakeUpHourSeconds + wakeUpMinSeconds
            
            //Make the prediction.
            let prediction: SleepCalculatorOutput = try sleepCalcModel.prediction(wake: Double(totalWakeUpSeconds), estimatedSleep: sleepDurationHrs, coffee: Double(coffeeIntake))
            let sleepTime: Date = wakeUpTime - prediction.actualSleep
            alertTitle = "Your ideal bed time is"
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        }
        catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
        }
        showingAlert = true
    }
}*/


//Only change: Using a 'Picker' for coffee intake instead of 'Stepper'.
//Tried using enums to manage state. But enums with associated values can't be used for that purpose since they are dynamic (mutable in nature) :(
//However enums with raw values can indeed be used.
//enum BetterRestUserInput  {
//    case wakeupTime(Date)
//    case desiredSleepDuration(Double)
//    case coffeeIntake(Int)
//}

struct BetterRestContentView: View {
    
//    @State private var wakeUpTimeNew: BetterRestUserInput = .wakeupTime(Date.now)
//    @State private var sleepDurationNew: BetterRestUserInput = .desiredSleepDuration(7.0)
//    @State private var coffeeIntakeNew: BetterRestUserInput = .coffeeIntake(1)


    @State private var wakeUpTime: Date = Date.now
    @State private var sleepDurationHrs: Double = 7.0
    @State private var coffeeIntakePickerValue: Int = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    var body: some View {
        NavigationStack {
            Form {
                VStack(alignment: .leading, spacing: 10.0) {
                    Spacer()
                    Text("When do you wish to wake up?").font(.headline)
                    DatePicker("Enter time", selection: $wakeUpTime, displayedComponents: .hourAndMinute).labelsHidden()
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 0.0) {
                    Spacer()
                    Text("Desired amount of sleep").font(.headline)
                    Stepper("\(sleepDurationHrs.formatted()) hours", value: $sleepDurationHrs, in: 4 ... 9, step: 0.25).padding()
                }
                
                VStack(alignment: .leading, spacing: 0.0) {
                    Spacer()
                    Text("Daily coffee intake: \(coffeeIntakePickerValue) cup(s)").font(.headline)
                    Picker("Coffee Intake", selection: $coffeeIntakePickerValue) {
                        ForEach(1 ... 20, id: \.self) { cupNum in
                            Text("\(cupNum)")
                        }
                    }.pickerStyle(.wheel)
                }
            }.navigationTitle("BetterRest").navigationBarTitleDisplayMode(.automatic).toolbar {
                Button("Calculate", action: calculateBedTime).alert(alertTitle, isPresented: $showingAlert) {
                    Button("OK", action: {})
                } message: {
                    Text(alertMessage)
                }
            }
        }
    }
    
//    private var wakeUpTimeFromEnum: Date {
//        var wakeUp: Date = Date.now
//        switch (wakeUpTimeNew) {
//            case .wakeupTime(let date):
//                wakeUp = date
//            default: break
//        }
//        return wakeUp
//    }
    
    private func calculateBedTime() {
        do {
            let modelConfig: MLModelConfiguration = MLModelConfiguration()
            let sleepCalcModel: SleepCalculator = try SleepCalculator(configuration: modelConfig)
            
            let dateComp: DateComponents = Calendar.current.dateComponents([.hour, .minute], from: wakeUpTime)
            let wakeUpHourSeconds: Int = (dateComp.hour ?? 0) * 60 * 60
            let wakeUpMinSeconds: Int = (dateComp.minute ?? 0) * 60
            let totalWakeUpSeconds: Int = wakeUpHourSeconds + wakeUpMinSeconds
            
            //Make the prediction.
            let prediction: SleepCalculatorOutput = try sleepCalcModel.prediction(wake: Double(totalWakeUpSeconds), estimatedSleep: sleepDurationHrs, coffee: Double(coffeeIntakePickerValue))
            let sleepTime: Date = wakeUpTime - prediction.actualSleep
            alertTitle = "Your ideal bed time is"
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        }
        catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
        }
        showingAlert = true
    }
}


#Preview {
    BetterRestContentView()
}
