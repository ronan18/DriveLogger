//
//  OnBoarding.swift
//  DriveLoggerCore
//
//  Created by Ronan Furuta on 9/25/20.
//

import SwiftUI
enum OnboardingScreen {
    case home
    case goal
}
struct OboardingHome: View {
    var next: (()->())
    var body: some View {
        VStack {
            Spacer()
            Image("logo").resizable().frame(width: 200, height: 200, alignment: .center)
            Text("Welcome to Drive Logger").font(.title).fontWeight(.bold).multilineTextAlignment(.center)
            Spacer().frame(height: 10)
            Text("Log your practice drives with ease").font(.subheadline).multilineTextAlignment(.center)
            Spacer()
          
            BlackButton("Continue",action: next)
        }.padding()
    }
}
public struct OboardingGoal: View {
    public var next: ((Int)->())
    public var confirmText = false
    var defaultVal: Int
    public init(next: @escaping ((Int)->()), confirmText: Bool = false, defaultVal: Int = 50) {
        self.next = next
        self.confirmText = confirmText
        self.defaultVal = defaultVal
    }
    @State var goal = 50
    public var body: some View {
        VStack {
            Spacer()
            Text("In total I need to drive:").font(.title).fontWeight(.bold).multilineTextAlignment(.center)

            Picker("I want to drive", selection: $goal) {
                ForEach(1...100, id: \.self) {time in
                    Text(String(time) + " hours")
                }
            }
          
            Spacer()
          
            BlackButton(self.confirmText ? "Confirm" :"Start Now",action: {next(self.goal)})
        }.padding().onAppear {
            self.goal = defaultVal
        }
    }
}
public struct Onboarding: View {
    @State var screen = OnboardingScreen.home
    var complete: (Int) -> ()
    public init(complete: @escaping ((Int) -> ())) {
        self.complete = complete
    }
  public var body: some View {
        VStack {
            if (self.screen == .home) {
                OboardingHome(next: {self.screen = .goal})
            } else {
                OboardingGoal(next: {goal in
                    complete(goal)
                })
            }
       
        }
    }
}

struct OnBoarding_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding(complete: {goal in})
    }
}
