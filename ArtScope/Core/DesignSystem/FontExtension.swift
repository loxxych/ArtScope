//
//  FontExtension.swift
//  ArtScope
//
//  Created by loxxy on 20.04.2026.
//

import SwiftUI
import UIKit

extension UIFont {
    static let ByteBounce28 = UIFont(name: "ByteBounce", size: 28) ?? .boldSystemFont(ofSize: 28)
    static let ByteBounce30 = UIFont(name: "ByteBounce", size: 30) ?? .boldSystemFont(ofSize: 30)
    static let ByteBounce35 = UIFont(name: "ByteBounce", size: 35) ?? .boldSystemFont(ofSize: 35)
    static let ByteBounce36 = UIFont(name: "ByteBounce", size: 36) ?? .boldSystemFont(ofSize: 36)
    static let ByteBounce41 = UIFont(name: "ByteBounce", size: 41) ?? .boldSystemFont(ofSize: 41)
    static let ByteBounce48 = UIFont(name: "ByteBounce", size: 48) ?? .boldSystemFont(ofSize: 48)
    static let ByteBounce49 = UIFont(name: "ByteBounce", size: 49) ?? .boldSystemFont(ofSize: 49)
    static let ByteBounce52 = UIFont(name: "ByteBounce", size: 52) ?? .boldSystemFont(ofSize: 52)

    static let InstrumentSansRegular11 = UIFont(name: "InstrumentSans-Regular", size: 11) ?? .systemFont(ofSize: 11)
    static let InstrumentSansRegular13 = UIFont(name: "InstrumentSans-Regular", size: 13) ?? .systemFont(ofSize: 13)
    static let InstrumentSansRegular14 = UIFont(name: "InstrumentSans-Regular", size: 14) ?? .systemFont(ofSize: 14)
    static let InstrumentSansRegular15 = UIFont(name: "InstrumentSans-Regular", size: 15) ?? .systemFont(ofSize: 15)
    static let InstrumentSansRegular16 = UIFont(name: "InstrumentSans-Regular", size: 16) ?? .systemFont(ofSize: 16)
    static let InstrumentSansRegular18 = UIFont(name: "InstrumentSans-Regular", size: 18) ?? .systemFont(ofSize: 18)
    static let InstrumentSansRegular41 = UIFont(name: "InstrumentSans-Regular", size: 41) ?? .systemFont(ofSize: 41)

    static let InstrumentSansBold17 = UIFont(name: "InstrumentSans-Bold", size: 17) ?? .boldSystemFont(ofSize: 17)
    static let InstrumentSansBold18 = UIFont(name: "InstrumentSans-Bold", size: 18) ?? .boldSystemFont(ofSize: 18)
    static let InstrumentSansBold20 = UIFont(name: "InstrumentSans-Bold", size: 20) ?? .boldSystemFont(ofSize: 20)
    static let InstrumentSansBold24 = UIFont(name: "InstrumentSans-Bold", size: 24) ?? .boldSystemFont(ofSize: 24)
    static let InstrumentSansBold27 = UIFont(name: "InstrumentSans-Bold", size: 27) ?? .boldSystemFont(ofSize: 27)
    static let InstrumentSansBold29 = UIFont(name: "InstrumentSans-Bold", size: 29) ?? .boldSystemFont(ofSize: 29)
    static let InstrumentSansBold31 = UIFont(name: "InstrumentSans-Bold", size: 31) ?? .boldSystemFont(ofSize: 31)

    static let InstrumentSansSemiBold15 = UIFont(name: "InstrumentSans-SemiBold", size: 15) ?? .systemFont(ofSize: 15, weight: .semibold)
    static let InstrumentSansSemiBold17 = UIFont(name: "InstrumentSans-SemiBold", size: 17) ?? .systemFont(ofSize: 17, weight: .semibold)
    static let InstrumentSansSemiBold18 = UIFont(name: "InstrumentSans-SemiBold", size: 18) ?? .systemFont(ofSize: 18, weight: .semibold)
    static let InstrumentSansSemiBold20 = UIFont(name: "InstrumentSans-SemiBold", size: 20) ?? .systemFont(ofSize: 20, weight: .semibold)
    static let InstrumentSansSemiBold26 = UIFont(name: "InstrumentSans-SemiBold", size: 26) ?? .systemFont(ofSize: 26, weight: .semibold)
}

extension Font {
    static let ByteBounce28 = Font.custom("ByteBounce", size: 28)
    static let ByteBounce34 = Font.custom("ByteBounce", size: 34)
    static let ByteBounce41 = Font.custom("ByteBounce", size: 41)
    static let ByteBounce48 = Font.custom("ByteBounce", size: 48)
    static let ByteBounce52 = Font.custom("ByteBounce", size: 52)

    static let InstrumentSansRegular11 = Font.custom("InstrumentSans-Regular", size: 11)
    static let InstrumentSansRegular13 = Font.custom("InstrumentSans-Regular", size: 13)
    static let InstrumentSansRegular15 = Font.custom("InstrumentSans-Regular", size: 15)
    static let InstrumentSansRegular16 = Font.custom("InstrumentSans-Regular", size: 16)

    static let InstrumentSansBold16 = Font.custom("InstrumentSans-Bold", size: 16)
    static let InstrumentSansBold24 = Font.custom("InstrumentSans-Bold", size: 24)
    static let InstrumentSansBold27 = Font.custom("InstrumentSans-Bold", size: 27)
    static let InstrumentSansBold29 = Font.custom("InstrumentSans-Bold", size: 29)
    static let InstrumentSansBold31 = Font.custom("InstrumentSans-Bold", size: 31)

    static let InstrumentSansSemiBold15 = Font.custom("InstrumentSans-SemiBold", size: 15)
    static let InstrumentSansSemiBold16 = Font.custom("InstrumentSans-SemiBold", size: 16)
    static let InstrumentSansSemiBold18 = Font.custom("InstrumentSans-SemiBold", size: 18)
    static let InstrumentSansSemiBold26 = Font.custom("InstrumentSans-SemiBold", size: 26)
}
