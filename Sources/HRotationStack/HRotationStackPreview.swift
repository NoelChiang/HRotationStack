//
//  HRotationStackPreview.swift
//  HRotationStack
//
//  Created by noel_chiang on 2025/7/16.
//

import SwiftUI

struct HRotationStackPreview: PreviewProvider {
    static let colors: [Color] = [
        .red,
        .orange,
        .yellow,
        .green,
        .blue
    ]
    static var previews: some View {
        HRotationStack(viewAmount: 5) { index in
            colors[index]
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}
