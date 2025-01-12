////
//	EditProfileView.swift
//	MHealth
//
//	Created By Navneet on 16/12/24
//


import SwiftUI
import PhotosUI

struct EditProfileView: View {
    // State variables for user inputs
    
    @StateObject var profileVM: EditProfileViewModel  = .init()
    @State var user: MHealthUser
    @State var showCamera = false
    @State var activeSheet: ActiveBSType?
    @EnvironmentObject var router: Router<MHealthNavigationRoute>
    
    var body: some View {
        VStack(spacing: 10) {
            ScrollView{
                VStack(spacing: 10) {
                    // Profile Picture Section
                    ProfilePictureView
                    
                    // Nickname textfields Section
                    InputFieldsView
                }
                .padding(10)
            }
            // Footer Buttons Section
            FooterView
        }
        .padding(10)
        .onAppear(){
            profileVM.setHeightAndWeight(user)
        }
        .background(Color.viewbackground)
        .sheet(item: $activeSheet) { item in
            switch item {
                case .DOB:
                    //Date Picker BS
                    DatePickerView(title: "Select Birthday", actionPerfomed: datePickerActionPerformed)
                        .presentationDetents([.height(300)])
                        .presentationCornerRadius(15)
                        .presentationDragIndicator(.hidden)
                case .Weight:
                    //Weight BS
                    WeightPickerView(actionPerfomed: actionPerformed)
                        .presentationDetents([.height(300)])
                        .presentationCornerRadius(15)
                        .presentationDragIndicator(.hidden)
                case .Height:
                    //Height BS
                    HeightPickerView(actionPerfomed: actionPerformed)
                        .presentationDetents([.height(300)])
                        .presentationCornerRadius(15)
                        .presentationDragIndicator(.hidden)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

// Profile Picture Section
extension EditProfileView{
    var ProfilePictureView: some View {
        MReusableCardView(.lightViewBackground, curve: 15){
            VStack {
                ZStack {
                    if let image = self.profileVM.image{
                        image
                            .resizable()
                            .foregroundStyle(Color.viewbackground)
                            .background(Color.imgBackground)
                            .frame(width: 200, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }else{
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.green.opacity(0.2))
                            .frame(width: 200, height: 200)
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                            .frame(width: 180, height: 180)
                        Text("Add a profile picture")
                            .foregroundColor(Color.mlabel)
                            .font(.headline)
                    }
                }
                
                HStack(spacing: 20) {
                    PhotosPicker(selection: $profileVM.selectedItem, matching: .images, preferredItemEncoding: .automatic, photoLibrary: .shared(), label: {
                        Text("Photos")
                            .foregroundColor(Color.mlabel)
                            .font(MFontConstant.bold14.font)
                            .frame(width: 120, height: 35, alignment: .center)
                            .background(.btnBackground)
                            .clipShape(.capsule)
                    })
                    .onChange(of: profileVM.selectedItem) {
                        Task {
                            if let image = try? await profileVM.selectedItem?.loadTransferable(type: Image.self) {
                                profileVM.image = image
                            }
                        }
                    }
                    
                    CurvedButtonView(title: "Camera"){
                        self.showCamera.toggle()
                    }
                    .fullScreenCover(isPresented: self.$showCamera) {
                        accessCameraView(selectedImage: self.$profileVM.image)
                            .background(.black)
                    }
                }
                .padding(.top)
            }
            .frame(maxWidth:.infinity)
            .padding(.vertical, 15)
        }
    }
}

// Nickname textfields Section
extension EditProfileView{
    var InputFieldsView: some View {
        VStack {
            MReusableCardView(.lightViewBackground, curve: 15){
                TextInputField(title: "Nickname", text: $user.nickname)
                    .padding(20)
            }
            
            MReusableCardView(.lightViewBackground, curve: 20){
                VStack(spacing: 12) {
                        GenderSelectionPopOverView(actionPerfomed: genderSelectionActionPerformed){
                            SelectableRow(icon: "person.fill", placeholder: "Gender", isDefault: $profileVM.isGenderEmpty, title: $user.gender)
                        }
        
                    
                    SelectableRow(icon: "ruler.fill", placeholder: "Height", isDefault: $profileVM.isHeightEmpty, title: $profileVM.height){
                        activeSheet = .Height
                    }
                    
                    SelectableRow(icon: "scalemass.fill", placeholder: "Weight", isDefault: $profileVM.isWeightEmpty, title: $profileVM.weight){
                        activeSheet = .Weight
                    }
                    
                    SelectableRow(icon: "birthday.cake", placeholder: "1-1-1987", isDefault: $profileVM.isDobEmpty, title: $profileVM.dobStr){
                        activeSheet = .DOB
                    }
                    
                }
                .padding(10)
            }
        }
    }
}


// Footer Buttons
extension EditProfileView{
    var FooterView: some View{
        FooterButtonsView{
            profileVM.saveProfile(user)
            router.navigateBack()
        } cancelAction: {
            router.navigateBack()
        }
    }
}

extension EditProfileView{
    
    struct TextInputField: View {
        let title: String
        @Binding var text: String
        
        var body: some View {
            VStack(alignment: .leading, spacing: .zero) {
                Text(title)
                    .foregroundColor(.mlabel)
                    .background(Color.clear)
                    .font(MFontConstant.semiBold13.font)
                TextField("", text: $text)
                    .foregroundColor(.mlabel)
                    .background(Color.clear)
                    .font(MFontConstant.semiBold14.font)
                    .padding(.top, 10)
                
                Divider()
                    .foregroundStyle(Color.darkGray2)
                    .padding(.top, 5)
            }
        }
    }
    
    struct SelectableRow: View {
        let icon: String
        let placeholder: String
        @Binding var isDefault: Bool
        @Binding var title: String
        var clicked: (() -> Void)? = nil /// use closure for callback
        
        var body: some View {
            Button(action: {
                if let clicked = clicked{
                    clicked()
                }
            }, label: {
                VStack{
                    HStack {
                        Image(systemName: icon)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(isDefault ? .mlabel : .green4)
                            .frame(width: 15, height: 15)
                        
                        TextField(placeholder,text: $title)
                            .multilineTextAlignment(.leading)
                            .disabled(true)
                            .autocapitalization(.none)
                            .foregroundColor(.mlabel)
                            .background(Color.clear)
                            .font(MFontConstant.semiBold14.font)
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    .background(Color.clear)
                    .cornerRadius(10)
                    
                    Divider()
                        .foregroundStyle(Color.darkGray2)
                        .padding(.top, 2)
                }
            })
        }
    }
}

// Weight and Height BottomSheet Callback section
extension EditProfileView{
    
    func actionPerformed(first: Int,midle: String, second: Int, unit: String, type: PickerCompomentTypeEnum) {
        print(Double("\(first).\(second)")!)
        if type == .Weight{
            user.weightUnit = .init(rawValue: unit) ?? .kg
            profileVM.weight = "\(first)\(midle)\(second) \(unit) "
            user.weight = Double("\(first).\(second)")
        }else if type == .Height{
            user.heightUnit = .init(rawValue: unit) ?? .cm
            user.height = Double("\(first).\(second)")
            profileVM.height = "\(first)\(midle)\(second) \(unit) "
        }
        profileVM.updateFlags(user)
    }
    
    func datePickerActionPerformed(date: Date, type: DatePickerView.DatePickerConstant){
        profileVM.dobStr = date.getDateStringFromUTC(.EEEddMMMyyyy)
        user.dob = date.getTimeStampFromDateUTC()
        profileVM.updateFlags(user)
    }
    
    // Gender Selection Callback Section
    func genderSelectionActionPerformed(value: Any){
        if let gender = value as? UserGender{
            user.gender = gender.rawValue
        }
    }
}

// Camera
extension EditProfileView{
    struct accessCameraView: UIViewControllerRepresentable {
        
        @Binding var selectedImage: Image?
        @Environment(\.presentationMode) var isPresented
        
        func makeUIViewController(context: Context) -> UIImagePickerController {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            imagePicker.delegate = context.coordinator
            return imagePicker
        }
        
        func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
            
        }
        
        func makeCoordinator() -> Coordinator {
            return Coordinator(picker: self)
        }
    }
    
    // Coordinator will help to preview the selected image in the View.
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var picker: accessCameraView
        
        init(picker: accessCameraView) {
            self.picker = picker
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let selectedImage = info[.originalImage] as? UIImage else { return }
            self.picker.selectedImage = Image(uiImage:selectedImage)
            self.picker.isPresented.wrappedValue.dismiss()
        }
    }
    
}

extension EditProfileView{

    enum ActiveBSType: Identifiable {
        case Weight
        case Height
        case DOB
        
        var id: Int {
            hashValue
        }
    }
}
