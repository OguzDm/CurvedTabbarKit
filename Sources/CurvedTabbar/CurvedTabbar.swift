import SwiftUI

public enum ItemCount: Int {
    case two = 2
    case four = 4
    
    var padding: CGFloat {
        switch self {
        case .two:
            return 60
        case .four:
            return 20
        }
    }
}

public protocol CurvedTabBarItem {
    static var views: [AnyView] {get}
    static var icons: [String] {get}
    static var count: ItemCount {get}
}

public struct CurvedTabBarView: View {
    
    @Binding var selectedTab: String
    private var tabBarItem: CurvedTabBarItem.Type
    var actionImage: String
    var accentColor: Color
    var action: () -> ()
    public init(selectedTab: Binding<String>, tabBarItem: CurvedTabBarItem.Type, actionImage: String, accentColor: Color, action:@escaping () -> ()) {
        UITabBar.appearance().isHidden = true
        self._selectedTab = selectedTab
        self.tabBarItem = tabBarItem
        self.action = action
        self.actionImage = actionImage
        self.accentColor = accentColor
    }
    public var body: some View {
        
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            
            TabView(selection: $selectedTab) {
                ForEach(tabBarItem.views.indices.prefix(tabBarItem.count.rawValue),id:\.self) { index in
                    tabBarItem.views[index]
                        .tag(tabBarItem.icons[index])
                }
            }
            
            ZStack {
                ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                    HStack(spacing: 25) {
                        ForEach(tabBarItem.icons.indices.prefix(tabBarItem.count.rawValue),id:\.self) { index in
                            
                            if tabBarItem.count.rawValue / 2 == index {
                                Spacer()
                                    .frame(width: 80)
                            }
                            
                            Button {
                                withAnimation {
                                    selectedTab = tabBarItem.icons[index]
                                }
                            } label: {
                                VStack {
                                        Image(systemName: tabBarItem.icons[index])
                                            .font(.system(size: 27))
                                            .foregroundColor(.primary)
                                    Circle()
                                        .fill(tabBarItem.icons[index] == selectedTab ? accentColor : .clear)
                                        .frame(width: 5, height: 5)
                                }
                            }
                        }
                    }
                }
                .clipShape(CustomShape())
                .frame(height: 65)
                .padding(.horizontal,tabBarItem.count.padding)
                .padding(.bottom)
                
                Button {
                    action()
                } label: {
                        Circle()
                            .fill(accentColor.opacity(0.7))
                            .frame(width: 55, height: 55, alignment: .center)
                            .overlay(
                                Image(systemName: actionImage)
                                    .font(.system(size: 35))
                                    .foregroundColor(.primary)
                            )
                            .offset(y:-30)
                }
            }
        }
    }
}

private struct CustomShape: Shape {
    
    func path(in rect: CGRect) -> Path {
        
        return Path { path in
            
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            
            let center = rect.width / 2
            
            path.move(to: CGPoint(x: center - 50, y: 0))
            
            let to1 = CGPoint(x: center, y: 45)
            let control1 = CGPoint(x: center - 33, y: 0)
            let control2 = CGPoint(x: center - 33, y: 45)
            
            let to2 = CGPoint(x: center + 50, y: 0)
            let control3 = CGPoint(x: center + 33, y: 45)
            let control4 = CGPoint(x: center + 33, y: 0)
            
            path.addCurve(to: to1, control1: control1, control2: control2)
            path.addCurve(to: to2, control1: control3, control2: control4)
        }
    }
}

//struct CurvedTabBarView_Previews: PreviewProvider {
//    static var previews: some View {
//        CurvedTabBarView(selectedTab: .constant("star"), count: .four, tabs: ["star","star","star","star","star","star"])
//    }
//}

