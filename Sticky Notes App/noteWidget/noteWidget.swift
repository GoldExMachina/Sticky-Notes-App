//
//  noteWidget.swift
//  noteWidget
//
//  Created by Alexander Smith on 21/12/2024.
//

import WidgetKit
import SwiftUI
import os

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> StickyNoteEntry {
        StickyNoteEntry(date: Date(), text: "Loading...", color: .white)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> StickyNoteEntry {
        loadWidgetData()
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<StickyNoteEntry> {
        let entry = loadWidgetData()
        
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 5, to: Date()) ?? Date().addingTimeInterval(300) // Update every 5 minutes
        return Timeline(entries: [entry], policy: .after(nextUpdate))
    }
    
    func loadWidgetData() -> StickyNoteEntry {
        let sharedDefaults = UserDefaults(suiteName: "group.com.FrostByte.StickyNotesWidget")
        
        let text = sharedDefaults?.string(forKey: "widget_text") ?? "Default Note Text"
        let colorData = sharedDefaults?.data(forKey: "widget_color")
        
        //sharedDefaults?.set("Try again people hold on", forKey: "widget_text")
        sharedDefaults?.synchronize()
        
        WidgetCenter.shared.reloadAllTimelines() // Ensure it's called here
            print("Widget timelines reloaded.")
        
        print("LOL Saved text: \(sharedDefaults?.string(forKey: "widget_text") ?? "No text found")")

        
        let color: UIColor = {
            if let data = colorData,
               let decodedColor = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIColor {
                return decodedColor
            }
            return .orange
        }()
        return StickyNoteEntry(date: Date(), text: text, color: color)
    }
}


struct StickyNoteEntry: TimelineEntry {
    let date: Date
    let text: String
    let color: UIColor
}


struct StickyNoteWidgetEntryView: View {
    var entry: StickyNoteEntry

    var body: some View {
        ZStack {
            Color(uiColor: entry.color) // Use Color to display UIColor
                .edgesIgnoringSafeArea(.all)
            Text(entry.text)
                .font(.headline)
                .padding()
                .foregroundColor(.black)
                
        }
        .containerBackground(.fill, for: .widget) // Add this line

    }
}

extension Color {
    init(uiColor: UIColor) {
        self.init(red: Double(uiColor.cgColor.components?[0] ?? 0),
                  green: Double(uiColor.cgColor.components?[1] ?? 0),
                  blue: Double(uiColor.cgColor.components?[2] ?? 0),
                  opacity: Double(uiColor.cgColor.alpha))
    }
}


struct StickyNoteWidget: Widget {
    let kind: String = "noteWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            StickyNoteWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Sticky Note")
        .description("Displays your latest sticky note.")
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}



#Preview(as: .systemSmall) {
    StickyNoteWidget()
} timeline: {
        StickyNoteEntry(date: .now, text: "Sample Note", color: .yellow) // Static placeholder data
        StickyNoteEntry(date: .now, text: "Another Note", color: .blue)  // Static placeholder data
}
