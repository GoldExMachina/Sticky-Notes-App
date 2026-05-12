//
//  StickyNoteWidgetBundle.swift
//  StickyNoteWidget
//
//  Created by Alexander Smith on 03/01/2025.
//

import WidgetKit
import SwiftUI

@main
struct StickyNoteWidgetBundle: WidgetBundle {
    var body: some Widget {
        StickyNoteWidget()
        StickyNoteWidgetControl()
        StickyNoteWidgetLiveActivity()
    }
}
