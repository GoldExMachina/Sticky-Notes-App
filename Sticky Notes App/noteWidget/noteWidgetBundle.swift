//
//  noteWidgetBundle.swift
//  noteWidget
//
//  Created by Alexander Smith on 21/12/2024.
//

import WidgetKit
import SwiftUI

@main
struct noteWidgetBundle: WidgetBundle {
    var body: some Widget {
        StickyNoteWidget()
        noteWidgetControl()
        noteWidgetLiveActivity()
    }
}
