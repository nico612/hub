//
//  ThemeManager.swift
//  Swifthub
//
//  Created by apple on 2023/12/28.
//

import Foundation
import RxSwift
import RxCocoa
import RxTheme
import SwifterSwift
import KafkaRefresh

/// 全局默认statusbar样式
let globalStatusBarStyle = BehaviorRelay<UIStatusBarStyle>(value: .default)

/// 主题服务，允许在应用中切换不同的主题
let themeService = ThemeType.service(initial: ThemeType.currentTheme())


/// 定义主题类型
/// ThemeProvider: 它旨在实现主题（Theme）提供者的功能，关联的主题对象定义了一个关联类型
enum ThemeType: ThemeProvider {
    
    case light(color: ColorTheme)
    case dark(color: ColorTheme)
    
    // 关联主题
    var associatedObject: Theme {
        switch self {
        case .light(let color): return LightTheme(colorTheme: color)
        case .dark(let color): return DarkTheme(colorTheme: color)
        }
    }
    
    var isDark: Bool {
        switch self {
        case .dark: return true
        default: return false
        }
    }
    
    /// 切换主题
    func toggled() -> ThemeType {
        var theme: ThemeType
        switch self {
        case .light(let color): theme = ThemeType.dark(color: color)
        case .dark(let color): theme = ThemeType.light(color: color)
        }
        theme.save()
        return theme
    }
    
    /// 切换主题
    func WithColor(color: ColorTheme) -> ThemeType {
        var theme: ThemeType
        switch self {
        case .light: theme = ThemeType.light(color: color)
        case .dark: theme = ThemeType.dark(color: color)
        }
        theme.save()
        return theme
    }
}

extension ThemeType {
    
    // 当前使用主题，默认light
    static func currentTheme() -> ThemeType {
        let defaults = UserDefaults.standard
        let isDark = defaults.bool(forKey: "IsDarkKey")
        let colorTheme = ColorTheme(rawValue: defaults.integer(forKey: "ThemeKey")) ?? ColorTheme.red
        let theme = isDark ? ThemeType.dark(color: colorTheme) : ThemeType.light(color: colorTheme)
        theme.save()
        return theme
    }
    
    /// 保存主题
    func save() {
        let defaults = UserDefaults.standard
        defaults.set(self.isDark, forKey: "IsDarkKey")
        switch self {
        case .light(let color): defaults.set(color.rawValue, forKey: "ThemeKey")
        case .dark(let color): defaults.set(color.rawValue, forKey: "ThemeKey")
        }
    }
}

/// 定义各种rx扩展
extension Reactive where Base: UIView {
    var backgroundColor: Binder<UIColor?> {
        return Binder(self.base) { view, attr in
            view.backgroundColor = attr
        }
    }
}

extension Reactive where Base: UIButton {
    func backgroundImage(for state: UIControl.State) -> Binder<UIColor> {
        return Binder(self.base) { view, attr in
            let image = UIImage(color: attr, size: CGSize(width: 1, height: 1))
            view.setBackgroundImage(image, for: state)
        }
    }
}

extension Reactive where Base: UITextField {
    var borderColor: Binder<UIColor?> {
        return Binder(self.base) { view, attr in
            view.layerBorderColor = attr
        }
    }

    var placeholderColor: Binder<UIColor?> {
        return Binder(self.base) { view, attr in
            if let color = attr {
                view.setPlaceHolderTextColor(color)
            }
        }
    }
}

extension Reactive where Base: UITableView {
    var separatorColor: Binder<UIColor?> {
        return Binder(self.base) { view, attr in
            view.separatorColor = attr
        }
    }
}

//extension Reactive where Base: TableViewCell {
//    var selectionColor: Binder<UIColor?> {
//        return Binder(self.base) { view, attr in
//            view.selectionColor = attr
//        }
//    }
//}
//
//extension Reactive where Base: ViewController {
//    var emptyDataSetImageTintColorBinder: Binder<UIColor?> {
//        return Binder(self.base) { view, attr in
//            view.emptyDataSetImageTintColor.accept(attr)
//        }
//    }
//}
//
//extension Reactive where Base: RAMAnimatedTabBarItem {
//    var iconColor: Binder<UIColor> {
//        return Binder(self.base) { view, attr in
//            view.iconColor = attr
//            view.deselectAnimation()
//        }
//    }
//
//    var textColor: Binder<UIColor> {
//        return Binder(self.base) { view, attr in
//            view.textColor = attr
//            view.deselectAnimation()
//        }
//    }
//}
//
//extension Reactive where Base: RAMItemAnimation {
//    var iconSelectedColor: Binder<UIColor> {
//        return Binder(self.base) { view, attr in
//            view.iconSelectedColor = attr
//        }
//    }
//
//    var textSelectedColor: Binder<UIColor> {
//        return Binder(self.base) { view, attr in
//            view.textSelectedColor = attr
//        }
//    }
//}

extension Reactive where Base: UINavigationBar {
    var largeTitleTextAttributes: Binder<[NSAttributedString.Key: Any]?> {
        return Binder(self.base) { view, attr in
            view.largeTitleTextAttributes = attr
        }
    }
}

extension Reactive where Base: UIApplication {
    var statusBarStyle: Binder<UIStatusBarStyle> {
        return Binder(self.base) { view, attr in
            globalStatusBarStyle.accept(attr)
        }
    }
}

extension Reactive where Base: KafkaRefreshDefaults {
    var themeColor: Binder<UIColor?> {
        return Binder(self.base) { view, attr in
            view.themeColor = attr
        }
    }
}

public extension Reactive where Base: UISwitch {
    var onTintColor: Binder<UIColor?> {
        return Binder(self.base) { view, attr in
            view.onTintColor = attr
        }
    }

    var thumbTintColor: Binder<UIColor?> {
        return Binder(self.base) { view, attr in
            view.thumbTintColor = attr
        }
    }
}


// MARK: - ThemProxy extension

/// ThemeProxy 用于实现主题和UI控件属性之间的绑定
/// 动态更新 UI 控件属性： 当你在应用中切换主题时，只需改变相应的 ThemeAttribute 的值，UI 控件的属性就会根据主题自动更新。
extension ThemeProxy where Base: UIApplication {
    var statusBarStyle: ThemeAttribute<UIStatusBarStyle> {
        get { fatalError("set only") }
        set {
            let disposable = newValue.stream
                .take(until: base.rx.deallocating) // 订阅newValue.stream 直到 base 对象被释放之前获取流中的元素
                .observe(on: MainScheduler.instance)
                .bind(to: base.rx.statusBarStyle) // 绑定到rx的扩展属性上
            hold(disposable, for: "statusBarStyle")
        }
    }
}

extension ThemeProxy where Base: UIButton {
    func backgroundImage(from newValue: ThemeAttribute<UIColor>, for state: UIControl.State) {
        let disposable = newValue.stream
            .take(until: base.rx.deallocating)
            .observe(on: MainScheduler.instance)
            .bind(to: base.rx.backgroundImage(for: state))
        hold(disposable, for: "backgroundImage.forState.\(state.rawValue)")
    }
}

extension ThemeProxy where Base: UITextField {
    var borderColor: ThemeAttribute<UIColor?> {
        get { fatalError("set only") }
        set {
            let disposable = newValue.stream
                .take(until: base.rx.deallocating)
                .observe(on: MainScheduler.instance)
                .bind(to: base.rx.borderColor)
            hold(disposable, for: "borderColor")
        }
    }

    var placeholderColor: ThemeAttribute<UIColor?> {
        get { fatalError("set only") }
        set {
            let disposable = newValue.stream
                .take(until: base.rx.deallocating)
                .observe(on: MainScheduler.instance)
                .bind(to: base.rx.placeholderColor)
            hold(disposable, for: "placeholderColor")
        }
    }
}
//
//extension ThemeProxy where Base: TableViewCell {
//    var selectionColor: ThemeAttribute<UIColor?> {
//        get { fatalError("set only") }
//        set {
//            let disposable = newValue.stream
//                .take(until: base.rx.deallocating)
//                .observe(on: MainScheduler.instance)
//                .bind(to: base.rx.selectionColor)
//            hold(disposable, for: "selectionColor")
//        }
//    }
//}
//
//extension ThemeProxy where Base: ViewController {
//    var emptyDataSetImageTintColorBinder: ThemeAttribute<UIColor?> {
//        get { fatalError("set only") }
//        set {
//            let disposable = newValue.stream
//                .take(until: base.rx.deallocating)
//                .observe(on: MainScheduler.instance)
//                .bind(to: base.rx.emptyDataSetImageTintColorBinder)
//            hold(disposable, for: "emptyDataSetImageTintColorBinder")
//        }
//    }
//}
//
//extension ThemeProxy where Base: RAMAnimatedTabBarItem {
//    var iconColor: ThemeAttribute<UIColor> {
//        get { fatalError("set only") }
//        set {
//            let disposable = newValue.stream
//                .take(until: base.rx.deallocating)
//                .observe(on: MainScheduler.instance)
//                .bind(to: base.rx.iconColor)
//            hold(disposable, for: "iconColor")
//        }
//    }
//
//    var textColor: ThemeAttribute<UIColor> {
//        get { fatalError("set only") }
//        set {
//            let disposable = newValue.stream
//                .take(until: base.rx.deallocating)
//                .observe(on: MainScheduler.instance)
//                .bind(to: base.rx.textColor)
//            hold(disposable, for: "textColor")
//        }
//    }
//}
//
//extension ThemeProxy where Base: RAMItemAnimation {
//    var iconSelectedColor: ThemeAttribute<UIColor> {
//        get { fatalError("set only") }
//        set {
//            let disposable = newValue.stream
//                .take(until: base.rx.deallocating)
//                .observe(on: MainScheduler.instance)
//                .bind(to: base.rx.iconSelectedColor)
//            hold(disposable, for: "iconSelectedColor")
//        }
//    }
//
//    var textSelectedColor: ThemeAttribute<UIColor> {
//        get { fatalError("set only") }
//        set {
//            let disposable = newValue.stream
//                .take(until: base.rx.deallocating)
//                .observe(on: MainScheduler.instance)
//                .bind(to: base.rx.textSelectedColor)
//            hold(disposable, for: "textSelectedColor")
//        }
//    }
//}
//

extension ThemeProxy where Base: KafkaRefreshDefaults {
    var themeColor: ThemeAttribute<UIColor?> {
        get { fatalError("set only") }
        set {
            let disposable = newValue.stream
                .take(until: base.rx.deallocating)
                .observe(on: MainScheduler.instance)
                .bind(to: base.rx.themeColor)
            hold(disposable, for: "themeColor")
        }
    }
}


