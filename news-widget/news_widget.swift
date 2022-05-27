//
//  news_widget.swift
//  news-widget
//
//  Created by Bennett Perkins on 26/5/2022.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    public let date: Date
    
}

struct news_widgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text(entry.date, style: .time)
    }
}

@main
struct news_widget: Widget {
    let kind: String = "news_widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            news_widgetEntryView(entry: entry)
        }
        .configurationDisplayName("Top Stories")
        .description("Shows the top stories from thewest.com.au")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct news_widget_Previews: PreviewProvider {
    static var previews: some View {
        news_widgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

struct NewsView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var urls: [URL]

    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall: TopArticlesView(news: urls)
        case .systemMedium: TopArticlesView(news: urls)
        case .systemLarge: TopArticlesView(news: urls)
        default: ArticlesNotAvailable()
        }
    }
}
