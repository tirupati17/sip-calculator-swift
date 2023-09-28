//
//  HistoryView.swift
//  SIP
//
//  Created by Tirupati Balan on 15/05/23.
//

import Foundation
import SwiftUI

extension String {
    func formattedValue(type: ValueType) -> String {
        guard let doubleValue = Double(self), !doubleValue.isNaN else { return "0" }
        
        switch type {
        case .amount:
            return "\(Locale.current.currencySymbol ?? "$")\(Int(ceil(doubleValue)))"
        case .rateOfReturn:
            return "\(Int(ceil(doubleValue)))%"
        case .period:
            return "\(Int(ceil(doubleValue))) Years"
        case .other:
            return "\(Int(ceil(doubleValue)))"
        }
    }
}

enum ValueType {
    case amount
    case rateOfReturn
    case period
    case other
}

struct DetailView: View {
    let title: String
    let value: String
    var type: ValueType = .other
    var isPositive: Bool = true
    
    private func formattedValue(for value: String, type: ValueType) -> String {
        guard let doubleValue = Double(value), !doubleValue.isNaN else { return "0" }
        
        switch type {
        case .amount:
            return "\(Locale.current.currencySymbol ?? "$")\(Int(ceil(doubleValue)))"
        case .rateOfReturn:
            return "\(Int(ceil(doubleValue)))%"
        case .period:
            return "\(Int(ceil(doubleValue))) Years"
        case .other:
            return "\(Int(ceil(doubleValue)))"
        }
    }
    
    var body: some View {
        HStack {
            Text(title + ":")
                .fontWeight(.medium)
            Spacer()
            Text(formattedValue(for: value, type: type))
                .fontWeight(type == .amount ? .bold : .regular)
                .foregroundColor(type == .amount ? (isPositive ? .green : .red) : .primary)
        }
    }
}

struct ItemView: View {
    let item: Item
    @State private var isShare = false
    
    var body: some View {
        ZStack {
            ShareLink(item: "https://apps.apple.com/in/app/sip-calculator/id1092822415", subject: Text("Download Sippy iOS app"), message: Text(shareMessage)) {

            }
            VStack(alignment: .leading, spacing: 8) {
                DetailView(title: "Actual Amount",
                           value: item.actualAmount ?? "0",
                           type: .amount)
                DetailView(title: "Profit Gain",
                           value: item.netReturn ?? "0",
                           type: .amount,
                           isPositive: (Double(item.netReturn ?? "0") ?? 0) > 0)
                DetailView(title: "Period",
                           value: item.period ?? "0",
                           type: .period)
                DetailView(title: "Rate of Return",
                           value: item.rateOfReturn ?? "0",
                           type: .rateOfReturn)
                DetailView(title: "Times Rolled",
                           value: item.timesRolledOver ?? "0",
                           type: .other)
            }
        }
    }
    
    private var shareMessage: String {
        let actualAmount = item.actualAmount?.formattedValue(type: .amount) ?? "0"
        let profitGain = item.netReturn?.formattedValue(type: .amount) ?? "0"
        let period = item.period?.formattedValue(type: .period) ?? "0"
        let rateOfReturn = item.rateOfReturn?.formattedValue(type: .rateOfReturn) ?? "0"
        let timesRolled = item.timesRolledOver?.formattedValue(type: .other) ?? "0"
        
        return """
        Find below your investment outcome via Sippy:
        - Actual Amount: \(actualAmount)
        - Profit Gain: \(profitGain)
        - Investment Period: \(period)
        - Rate of Return: \(rateOfReturn)
        - Times Rolled Over: \(timesRolled)
        """
    }
}

struct HistoryView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    @Environment(\.presentationMode) var presentationMode
    
    private var itemsByDate: [String: [Item]] {
        Dictionary(grouping: items) {
            dateFormatter.string(from: $0.timestamp ?? Date())
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium // or any style that suits your needs
        formatter.timeStyle = .none
        return formatter
    }
    
    var body: some View {
        List {
            ForEach(itemsByDate.keys.sorted(), id: \.self) { key in
                Section(header: Text(key)) {
                    ForEach(itemsByDate[key]!, id: \.self) { item in
                        ItemView(item: item)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("History")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.primary)
                .fontWeight(.bold)
            }
        }
        
    }
}

extension DateFormatter {
    static let item: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
