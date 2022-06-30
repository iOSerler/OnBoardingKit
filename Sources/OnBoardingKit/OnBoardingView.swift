//
//  SwiftUIView.swift
//  
//
//  Created by Anna Dluzhinskaya on 30.06.2022.
//

import SwiftUI

public struct IntroductionPagesView: View {
    var settings: OnBoardingAssets
    var completeIntroduction: (() -> Void)
    var showNotificationPermission: (() -> Void)
    @State private var selectedIndex: Int = 0
    var pagesData: Pages
    
    public init (
        settings: OnBoardingAssets,
        completeAction: @escaping (() -> Void),
        navigateAction: @escaping (() -> Void),
        jsonName: String
    ) {
        self.settings = settings
        self.completeIntroduction = completeAction
        self.showNotificationPermission = navigateAction
        self.pagesData = Pages(name: jsonName)
    }
    
    public var body: some View {
        VStack {
            TabView(selection: $selectedIndex) {
                ForEach(pagesData.introductionPagesData) { page in
                    GeometryReader { geom in
                        VStack(alignment: .center) {
                            Image(page.image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: UIScreen.main.bounds.height / 3)

                            
                            Text(page.title)
                                .font(.custom(settings.titleFont, size: 18))
                                .foregroundColor(Color(settings.mainTextColor))
                                .multilineTextAlignment(.center)
                                .padding(.top, 30)
                            
                            Text(page.description)
                                .font(.custom(settings.descriptionFont, size: 14))
                                .foregroundColor(Color(settings.descriptionTextColor))
                                .multilineTextAlignment(.center)
                                .padding(.top, 12)
                                .padding(.horizontal, 20)
                        }
                        .opacity(Double(geom.frame(in: . global).minX)/200+1)
                    }
                }
            }
            .edgesIgnoringSafeArea(.top)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            HStack(spacing: 12) {
                
                ForEach(0..<pagesData.introductionPagesData.count, id: \.self) { index in
                    Capsule()
                        .foregroundColor(
                            selectedIndex == index ?
                            Color(settings.primaryColor) :
                                Color(settings.primaryLighterColor)
                        )
                        .frame(width: selectedIndex == index ? 16 : 8, height: 8)
                }
            }
            
            Button(action: {
                if selectedIndex < pagesData.introductionPagesData.count - 1 {
                    withAnimation {
                        selectedIndex += 1
                    }
                } else {
                    DispatchQueue.main.async {
                        withAnimation {
                            completeIntroduction()
                        }
                    }
                }
            }, label: {
                HStack {
                    Text(selectedIndex != pagesData.introductionPagesData.count - 1 ? "Next" : "Get Started")
                        .font(.custom(settings.titleFont, size: 16))
                        .foregroundColor(Color(settings.buttonTextColor))
                    
                    Image(settings.onBoardingButtonIcon)
                        .padding(.leading, 20)
                }
                
                .font(Font.custom(settings.titleFont, size: 16))
                .frame(width: UIScreen.main.bounds.width - 60, height: 50, alignment: .center)
                .background(Color(settings.primaryColor))
                .accentColor(Color(settings.buttonTextColor))
                .cornerRadius(UIScreen.main.bounds.width/35)
            })
            .padding(.top, 15)
            .padding(.bottom, UIScreen.main.bounds.height/30)
        }
        .navigationBarItems(trailing:
                                
                                Button(action: {
            showNotificationPermission()
            
        }, label: {
            Text("skip")
                .foregroundColor(
                    selectedIndex != pagesData.introductionPagesData.count - 1 ?
                    Color(settings.descriptionTextColor) : Color.clear
                )
                .font(.custom(settings.descriptionFont, size: 14))
        }).disabled(selectedIndex == pagesData.introductionPagesData.count - 1)
                            
                            
        )
        .navigationBarBackButtonHidden(true)
    }
}
