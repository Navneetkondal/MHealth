////
//	MenuHealthActivityView.swift
//	MHealth
//
//	Created By Navneet on 15/12/24
//


import SwiftUI

struct MenuHealthActivityView: View {
    
    @EnvironmentObject var router: Router<MHealthNavigationRoute>
    @EnvironmentObject var viewModel: HealthViewModel
    
    @ObservedObject var activity: DashboardCardData
    @State var activeSheet: ActiveSheet?
    @State var detentHeight: CGFloat = 0
    
    var body: some View {
        MReusableCardView(.lightViewBackground, curve: 15){
            Button(action:{
                print("didSelectForRowAt")
            }){
                HStack(alignment: .center, spacing: 5){
                    VStack(alignment: .leading, spacing: 5){
                        TitleView
                        
                        if activity.isShowValue || activity.buttonType != .noButton {
                            HStack(alignment: .center){
                                if activity.isShowValue && activity.valueAlingment == .leading {
                                    Text("\(viewModel.healthActivitys[activity.type]?.todaysActivity.valueDesc ?? "")")
                                        .foregroundColor(Color.darkGray4)
                                        .font(MFontConstant.regular13.font)
                                }
                                if  activity.buttonType != .noButton  {
                                    Button(action: {
                                        onClickAddEnterButton()
                                    }, label: {
                                        ButtonView
                                    })
                                    .frame(width: 120, height: 35, alignment: .center)
                                    .background(Color.btnBackground)
                                    .clipShape(.capsule)
                                    
                                    //MARK: - Bottom Sheet
                                    .sheet(item: $activeSheet) { item in
                                        switch item {
                                            case .Sleep:
                                                let data = viewModel.healthActivitys[activity.type]
                                                let startAngle = data?.todaysActivity.getSleepStartAngle() ?? 0
                                                let endAngle = data?.todaysActivity.getSleepEndAngle() ?? 0.6
                                                SleepRecordView(card: activity, startProgress: startAngle, toProgress: endAngle)
                                                    .presentationDetents([.height(480)])
                                                    .presentationCornerRadius(15)
                                                    .presentationDragIndicator(.hidden)
                                            case .Food:
                                                MealSelectionBSView(referenceTag: activity.type.rawValue , title: "Meal type", items: viewModel.uiViewModel.mealTypes , isSingleSelection: true,  actionPerfomed: actionPerformed)
                                                    .presentationDetents([.height(430)])
                                                    .presentationCornerRadius(15)
                                                    .presentationDragIndicator(.hidden)
                                        }
                                    }
                                }
                            }
                            .padding(.top, 5)
                        }
                    }
                    Spacer()
                    
                    ProgressView
                }
            }
            .padding(12)
        }
    }
}

extension MenuHealthActivityView{
    
    // Leading Image and Title View
    var TitleView: some View{
        HStack(alignment: .center){
            Image(isSytemImg: true, img: activity.image)
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(Color.viewbackground)
                .scaleEffect(0.55)
                .background(Color.imgBackground)
                .frame(width: 25, height: 25, alignment: .center)
                .clipShape(.circle)
            
            if activity.otherType != .none{
                Text(activity.name)
                    .foregroundColor(Color.mlabel)
                    .font(MFontConstant.bold16.font)
                    .padding(.trailing, 4)
            }else{
                Text(viewModel.healthActivitys[activity.type]?.attributedTitle ?? "")
                    .foregroundColor(Color.mlabel)
                    .font(MFontConstant.bold16.font)
                    .padding(.trailing, 4)
            }
        }
    }
    
    // Button View
    var ButtonView: some View{
        HStack(alignment: .center, spacing: 8){
            if activity.isSetLeadingButtonImg() {
                Image(systemImg: .sysImg_plus)
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 10, height: 10)
            }
            Text(activity.getbuttonName(viewModel))
                .foregroundColor(Color.mlabel)
                .font(MFontConstant.bold14.font)
        }
    }
    
    // Progress View
    var ProgressView: some View{
        HStack(alignment: .center, spacing: 5){
            if activity.istralingImg{
                Image(isSytemImg: false, img: activity.trailImg )
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
            }else{
                //MARK: -  Progressbar
                if activity.progressBar == .circular{
                    let percentage = (viewModel.healthActivitys[activity.type]?.todaysActivity.percentage ?? 0).rounded()
                    CircularProgressView(progressConfig: .init(lineWidth: 6, bgColor: Color.green.opacity(0.2), foregroundColor: Color.green, value: percentage))
                        .frame(width: 70, height: 70)
                }else if activity.progressBar == .linear{
                    let percentage = viewModel.healthActivitys[activity.type]?.todaysActivity.percentage ?? 0
                    
                    let time = viewModel.healthActivitys[activity.type]?.todaysActivity.getSleepTimeString() ?? "\(percentage)"
                    let msg =  percentage == 0 ? " ? " : "\(time)"
                    LinearProgressView(progress: percentage, msg: msg,
                                       bgColor: Color.green.opacity(0.2),
                                       filledColor: Color.green, width: 70)
                    .frame(width: 70,height: 10)
                }
            }
        }
    }
}

extension MenuHealthActivityView{
    
    private func actionPerformed(action: MealSelectionUIData, referenceTag: String) {
        if referenceTag == ActivityTypeEnum.Food.rawValue{
            router.navigate(to: .Food(action.title, viewModel.getFoodDishes(for: .init(rawValue: action.title)) ))
        } else if  referenceTag ==  MHealthStringConstant.AddCalories.rawValue{
            router.navigate(to: .AddCalories(viewModel.uiViewModel.getCurrentMeal(), .addCalories, []))
        }
    }
    
    //Button Action
    private func onClickAddEnterButton(){
        if activity.type == .Sleep {
            activeSheet  = .Sleep
        }else if activity.type == .Food {
            viewModel.uiViewModel.calculateMealTypes()
            activeSheet = .Food
        }else if activity.type == .Water{
            viewModel.updateWaterValue(for: activity)
        } else{
            print("To be implemented")
        }
    }
    
    enum ActiveSheet: Identifiable {
        case Sleep, Food
        
        var id: Int {
            hashValue
        }
    }
}
