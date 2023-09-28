//
//  ContentView.swift
//  SIP
//
//  Created by Tirupati Balan on 15/05/23.
//

import SwiftUI
import CoreData
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var settingsViewModel: SettingViewModel
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FocusState private var isInputActive: Bool
    @State private var monthlyInvestment: String = ""
    @State private var period: Double = 0
    @State private var rateOfReturn: Double = 0
    @State private var actualAmount: Double = 0
    @State private var timesRolledOver: Double = 0
    @State private var netReturn: Double = 0
    @State private var showingHistory = false
    @State private var showSetting = false
    @State private var isBookmarkFilled = false
    @GestureState private var isPressing = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section {
                        HStack (spacing: 20) {
                            StatisticBoxView(title: "Actual Amount", value: String(format: "%.0f", actualAmount), isAmount: true)
                            StatisticBoxView(title: "Expected Amount", value: String(format: "%.0f", actualAmount + netReturn), isAmount: true)
                        }
                    }
                    Section {
                        HStack(alignment: .center) {
                            Spacer()
                            Text(formattedValue(netReturn))
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(netReturn > 0 ? .green : .red)
                                .multilineTextAlignment(.center)
                            Spacer()
                        }
                    } header: {
                        Text("Profit Gain")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                    Section {
                        TextField("Enter Amount", text: $monthlyInvestment)
                            .keyboardType(.numberPad)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .textFieldStyle(.plain)
                            .multilineTextAlignment(.center)
                            .focused($isInputActive)
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .background(Color(.clear))
                            .lineLimit(1)
                            .cornerRadius(12)
                            .animation(.default.repeatCount(3, autoreverses: true).speed(6), value: isInputActive)
                    } header: {
                        Text("Amount per month")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                    
                    Section {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Period (Years)")
                                    .font(
                                        .footnote)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text(String(format: "%.0f", period)).font(.headline)
                            }
                            Slider(value: $period, in: 0...40, step: 1)
                                .padding(.vertical)
                                .tint(Color.appTheme)
                        }
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Rate of Return (%)")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text(String(format: "%.1f", rateOfReturn)).font(.headline)
                            }
                            Slider(value: $rateOfReturn, in: 0...30, step: 0.1)
                                .padding(.vertical)
                                .tint(Color.appTheme)
                        }
                    } footer: {
                        Text("Return can vary based on market trends")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                    .listRowSeparator(.hidden)
                    .onChange(of: monthlyInvestment) { _ in
                        calculateSIP()
                    }
                    .onChange(of: period) { _ in
                        calculateSIP()
                    }
                    .onChange(of: rateOfReturn) { _ in
                        calculateSIP()
                    }
                }
                .listStyle(.insetGrouped)
                .navigationTitle("Sippy")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarTitleDisplayMode(isInputActive ? .inline : .large)
                .touchToDismissKeyboard()
                .refreshable {
                    if actualAmount > 0 && isBookmarkFilled == false {
                        isBookmarkFilled = true
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        saveResults()
                    } else {
                        isInputActive = true
                    }
                }
                .onAppear {
                    UIRefreshControl.appearance().tintColor = Color.appTheme.uiColor()
                    UIRefreshControl.appearance().attributedTitle = try? NSAttributedString(markdown: "Pull down to save")
                }

            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(systemName: "gear")
                        .imageScale(.large)
                        .foregroundColor(Color.appTheme)
                        .onTapGesture {
                            showSetting.toggle()
                        }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: isBookmarkFilled ? "bookmark.fill" : "bookmark")
                        .imageScale(.large)
                        .foregroundColor(Color.appTheme)
                        .onTapGesture {
                            showingHistory.toggle()
                        }
                }
            }
            .sheet(isPresented: $showingHistory) {
                NavigationView {
                    HistoryView()
                }
            }
            .sheet(isPresented: $showSetting) {
                NavigationView {
                    SettingView()
                        .preferredColorScheme(settingsViewModel.getTheme())
                        .environmentObject(settingsViewModel)
                }
            }
            
        }
    }
    
    private func formattedValue(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = Locale.current.currencySymbol ?? "$"
        return formatter.string(from: NSNumber(value: max(value > 0 ? value: 0, 0))) ?? "$0"
    }
    
    private func saveResults() {
        let newItem = Item(context: viewContext)
        newItem.timestamp = Date()
        newItem.actualAmount = "\(actualAmount)"
        newItem.netReturn = "\(netReturn)"
        newItem.period = "\(period)"
        newItem.rateOfReturn = "\(rateOfReturn)"
        newItem.timesRolledOver = "\(timesRolledOver)"
        
        do {
            try viewContext.save()
            
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func calculateSIP() {
        isBookmarkFilled = false
        guard let amount = Double(monthlyInvestment), period > 0, rateOfReturn > 0 else {
            actualAmount = 0
            timesRolledOver = 0
            netReturn = 0
            return
        }
        
        let periodMonthly = Double(period) * 12.0
        let rateOfReturnMonthly = rateOfReturn / 12.0 / 100.0
        
        actualAmount = amount * periodMonthly
        
        let futureAmount = futureSipValue(rateOfReturnMonthly, nper: periodMonthly, pmt: amount)
        netReturn = futureAmount - actualAmount
        timesRolledOver = actualAmount == 0 ? 0 : futureAmount / actualAmount
    }
    
    func futureSipValue(_ rate: Double, nper: Double, pmt: Double) -> Double {
        let futureValue = pmt * ((pow(1 + rate, nper) - 1) / rate) * (1 + rate)
        return futureValue
    }
    
}

struct StatisticBoxView: View {
    var title: String
    var value: String
    var isAmount: Bool
    
    private func formattedValue() -> String {
        if isAmount {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencySymbol = Locale.current.currencySymbol ?? "$"
            return formatter.string(from: NSNumber(value: max(Int(value) ?? 0, 0))) ?? "$0"
        } else {
            return "\(max(Int(value) ?? 0, 0))"
        }
    }
    
    var body: some View {
        VStack (spacing: 5) {
            Text(formattedValue())
                .minimumScaleFactor(0.1)
                .lineLimit(1)
                .font(.title)
                .fontWeight(.bold)
                .frame(height: 30)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(height: 20)
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .frame(height: 60)
        .cornerRadius(10)
        .shadow(color: Color.primary.opacity(0.1), radius: 1, x: 0, y: 1)
    }
}

extension View {
    func touchToDismissKeyboard() -> some View {
        return modifier(TouchToDismissKeyboard())
    }
}

struct TouchToDismissKeyboard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                let keyWindow = UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive})
                    .map({$0 as? UIWindowScene})
                    .compactMap({$0})
                    .first?.windows
                    .filter({$0.isKeyWindow}).first
                keyWindow?.endEditing(true)
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
