//
//  TypeChipView.swift
//  iosApp
//
//  Created by Akash K on 13/04/26.
//

import SwiftUI

struct TypeChipView: View {

    let type: String

    var body: some View {
        Text(type.capitalized)
            .font(.system(.caption, weight: .bold))
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(TypeColors.color(for: type).gradient)
            )
    }
}
