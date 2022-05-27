//
//  TopNewsWidget.swift
//  my-news-widgetExtension
//
//  Created by Bennett Perkins on 27/5/2022.
//

import WidgetKit
import SwiftUI
import Intents

struct TopNewsWidget: Widget {
    
    static var defaultUrl = URL(string: "https://content.thewest.com.au/v4/resolve?slug=/news/visceral-dave-sharma-reveals-why-moderate-voters-turned-on-scott-morrison-c-6926869&include_premium=true&include_meta")!
    
    static var sampleUrls = [
        "https://content.thewest.com.au/v4/resolve?slug=/news/visceral-dave-sharma-reveals-why-moderate-voters-turned-on-scott-morrison-c-6926869&include_premium=true&include_meta",
        "https://content.thewest.com.au/v4/resolve?slug=/politics/federal-politics/aged-care-strikes-united-workers-union-director-carolyn-smith-says-it-is-only-way-to-make-real-change-c-6954900&include_premium=true&include_meta",
        "https://content.thewest.com.au/v4/resolve?slug=/politics/federal-election/federal-election-2022-labor-powerbrokers-jostle-for-more-wa-representation-in-anthony-albaneses-ministry-c-6947388&include_premium=true&include_meta",
    ].map {
        URL(string: $0)
    }
    
    var supportedFamilies: [WidgetFamily] {
        #if os(iOS)
        return [.systemSmall, .systemMedium, .systemLarge, .systemExtraLarge]
        #else
        return [.systemSmall, .systemMedium, .systemLarge]
        #endif
    }
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "TopNews", provider: Provider()) { entry in
            TopNewsEntryView(entry: entry)
        }
        .configurationDisplayName(
            Text("Top News",
                 comment: "The name shown for the widget when the user adds or edits it")
        )
        .description(
            Text("Displays YOUR top news, chosen by OUR team of CRACKPOT EDITORS!",
                 comment: "Description shown for the widget when the user adds or edits it")
        )
        .supportedFamilies(supportedFamilies)
    }
}

extension TopNewsWidget {

    struct Provider: TimelineProvider {
        typealias Entry = TopNewsWidget.Entry
       
        func placeholder(in context: Context) -> Entry {
            Entry(date: Date(), url: TopNewsWidget.defaultUrl)
        }
    
        func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
            let entry = Entry(date: Date(), url: TopNewsWidget.defaultUrl)
            completion(entry)
        }
        
        func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
            var entries: [Entry] = []

            let currentDate = Date()
            let urls: [URL] = [
                //TODO get these from content-api!
            ]
            for index in 0..<urls.count {
                let entryDate = Calendar.current.date(byAdding: .minute, value: index, to: currentDate)!
                let entry = Entry(date: entryDate, url: urls[index])
                entries.append(entry)
            }

            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
}

extension TopNewsWidget {
    struct Entry: TimelineEntry {
        var date: Date
        var url: URL
    }
}

struct TopNewsEntryView: View {
    var entry: TopNewsWidget.Provider.Entry
    
    @Environment(\.widgetFamily) private var widgetFamily
    
    var title: some View {
        Text(entry.url.absoluteString)
            .font(widgetFamily == .systemSmall ? Font.body.bold() : Font.title3.bold())
            .lineLimit(1)
            .minimumScaleFactor(0.1)
    }
    
//    var image: some View {
//        Rectangle()
//            .overlay {
//                entry.smoothie.image
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//            }
//            .aspectRatio(1, contentMode: .fit)
//            .clipShape(ContainerRelativeShape())
//    }
//
    var body: some View {
        ZStack {
            if widgetFamily == .systemMedium {
                HStack(alignment: .top, spacing: 20) {
                    VStack(alignment: .leading) {
                        title
//                        description
//                        calories
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .accessibilityElement(children: .combine)
                    
//                    image
                }
                .padding()
            } else {
                VStack(alignment: .leading, spacing: 10) {
                    VStack(alignment: .leading) {
                        title
                        if widgetFamily == .systemLarge {
//                            description
//                            calories
                        }
                    }
                    .accessibilityElement(children: .combine)
                    
//                    image
//                        .frame(maxWidth: .infinity, alignment: .bottomTrailing)
                }
                .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background { BubbleBackground() }
    }
}

struct FeaturedSmoothieWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TopNewsEntryView(entry: TopNewsWidget.Entry(date: Date(), url: TopNewsWidget.defaultUrl))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .redacted(reason: .placeholder)
            TopNewsEntryView(entry: TopNewsWidget.Entry(date: Date(), url: TopNewsWidget.defaultUrl))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            TopNewsEntryView(entry: TopNewsWidget.Entry(date: Date(), url: TopNewsWidget.defaultUrl))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}

