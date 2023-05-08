//
//  ContentView.swift
//  Demo
//
//  Created by Ramamoorthy on 08/05/23.
//

import SwiftUI

struct Services: Identifiable {
    var id = UUID()
    var image: UIImage = UIImage()
    var title: String
    var isSelected: Bool = false
}

struct HomeView: View {
    
    @State private var fromStr: String = "Chennai"
    @State private var toStr: String = "Banglore"
    @ObservedObject var viewModel: HomeViewModel
    typealias Icons = Constants.Icons
    typealias Tiles = Constants.Titles
    
    var primaryServices = [Services(image: UIImage(systemName: Icons.bus) ?? UIImage(), title: Tiles.bus),
                           Services(image: UIImage(systemName: Icons.train) ?? UIImage(), title: Tiles.train),
                           Services(image: UIImage(systemName: Icons.metro) ?? UIImage(), title: Tiles.metro)]
    
    var secondaryServices = [Services(image: UIImage(systemName: Icons.cab) ?? UIImage(), title: Tiles.cab),
                             Services(image: UIImage(systemName: Icons.auto) ?? UIImage(), title: Tiles.auto),
                             Services(image: UIImage(systemName: Icons.moto) ?? UIImage(), title: Tiles.moto)]
    
    var body: some View {
        
        let columms = Array(repeating: GridItem(.flexible(), spacing: 10), count: primaryServices.count)
        
        ScrollView {
            VStack(spacing: 0) {
                
                HeaderView()
                
                HStack {
                    VStack {
                        
                        SourceDestinationView(fromStr: fromStr, toStr: toStr)
                        
                        HStack {
                            Text(Tiles.primary)
                                .padding(.leading,15)
                                .font(Font.system(size: 15,weight: .bold))
                            Spacer()
                        }
                        
                        LazyVGrid(columns: columms,spacing: 10) {
                            ForEach(primaryServices) { service in
                                ServiceView(serive: service)
                                
                            }
                        }.padding(15)
                        
                        HStack {
                            Text(Tiles.secondary)
                                .padding(.leading,15)
                                .font(Font.system(size: 15,weight: .bold))
                            Spacer()
                        }
                        
                        LazyVGrid(columns: columms,spacing: 10) {
                            ForEach(secondaryServices) { service in
                                ServiceView(serive: service)
                            }
                        }.padding(15)
                    }
                    
                    
                }
                .background(Color(.systemGray6).clipShape(RoundedRectangle(cornerRadius:20)))
                .padding()
                
                HStack {
                    
                    HStack(spacing: 8) {
                        Image(systemName: Icons.pin)
                            .foregroundColor(.purple)
                        Text(Tiles.parking)
                            .font(Font.system(size: 14,weight: .medium))
                    }.padding()
                    
                    Spacer()
                    Text(Tiles.bookParking)
                        .frame(width: 100,height: 20)
                        .font(Font.system(size: 12,weight: .medium))
                        .cornerRadius(8)
                        .background(Color.green.opacity(0.8)
                            .clipShape(RoundedRectangle(cornerRadius:8)))
                        .padding()
                }
                .frame(height: 50)
                .background(Color(.systemGray6).clipShape(RoundedRectangle(cornerRadius:20)))
                .padding()
                
                ScheduledView()
                
                PassengersView()
                
                Button {
                    viewModel.proceedBooking()
                } label: {
                    Text(Tiles.proceedBooking)
                        .foregroundColor(.white)
                        .font(Font.system(size: 18,weight: .bold))
                }.fullScreenCover(isPresented: $viewModel.isSuccess, content: {
                    DetailView(userList: viewModel.users)
                })
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(LinearGradient(gradient: Gradient(colors: [Color.purple,Color.blue, Color.green]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(16)
                .padding()
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text(viewModel.validationMessage ?? Constants.Errors.Labels.unknown))
            }
            
            
        }
    }
}
struct HomeViewDI {
    
    var homeView: HomeView {
        HomeView(viewModel: homeViewModel)
    }
    private var homeViewModel: HomeViewModel {
        HomeViewModel(networking: networking)
    }
    private var networking: NetworkServiceProtocol {
        NetworkService()
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewDI().homeView
    }
}

struct HeaderView: View {
    var body: some View {
        HStack {
            Image(uiImage: UIImage(named: Constants.Icons.person)!)
                .resizable()
                .aspectRatio(contentMode: .fill).clipped()
                .frame(width: 45, height: 45)
                .cornerRadius(8)
                .padding(.leading,15)
            
            VStack(alignment: .leading,spacing: 5) {
                Text("Hi Sanjay,")
                    .font(Font.system(size: 15,weight: .bold))
                    .foregroundColor(.purple)
                Text(Constants.Titles.welcome)
                    .font(Font.system(size: 13,weight: .medium))
                    .foregroundColor(.black)
            }.padding(.leading,5)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 10) {
                
                Image(systemName: Constants.Icons.bell)
                    .foregroundColor(.purple)
                    .onTapGesture {
                        print("Notifcation Tapped")
                    }
                Button(action: {}) {
                    HStack {
                        Text(Constants.Titles.mySelf)
                        Image(systemName: Constants.Icons.arrowDown)
                            .foregroundColor(.purple)
                        
                    }
                }
                .padding()
                .foregroundColor(.black)
                .frame(height: 30)
                .background(Color(.white))
                .cornerRadius(8)
                
            }
            .padding(.trailing,15)
            
        }
        .cornerRadius(10)
        
        .frame(height: 100)
        .background(Color(.systemGray6).clipShape(RoundedRectangle(cornerRadius:20)))
        .padding()
    }
}

struct SourceDestinationView: View {
    
    @State var fromStr: String
    @State var toStr: String
    
    var body: some View {
        ZStack {
            
            
            VStack(spacing: 15) {
                HStack(spacing: 8) {
                    Color(.green)
                        .frame(width: 4)
                    TextField("From", text: $fromStr)
                        .textFieldStyle(PlainTextFieldStyle())
                        .cornerRadius(16)
                }
                .frame(height: 40)
                .background(Color.white)
                .cornerRadius(8)
                
                HStack(spacing: 8) {
                    Color(.purple)
                        .frame(width: 4)
                    TextField("To", text: $toStr)
                        .textFieldStyle(PlainTextFieldStyle())
                        .cornerRadius(16)
                }
                .frame(height: 40)
                .background(Color.white)
                .cornerRadius(8)
                
            }
            .padding(15)
            .shadow(color: Color.black.opacity(0.2), radius: 10,y: 5)
            
            HStack {
                Spacer()
                Image(systemName: Constants.Icons.swapArrow)
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width: 40,height: 40)
                    .background(Color.green)
                    .cornerRadius(20)
                    .padding(.trailing,35)
                    .onTapGesture {
                        swap(a: &fromStr, b: &toStr)
                    }
            }
            
            
        }
    }
    
    func swap<T>(a: inout T, b: inout T) {
        (a, b) = (b, a)
    }
}

struct ScheduledView: View {
    @State private var showDatePicker = false
    @State private var selectedDate = Date()
    @State private var selectedTime = Date()
    @State private var showTimePicker = false

    var body: some View {
        VStack {
            HStack {
                Text(Constants.Titles.scheduledDateTime)
                    .font(Font.system(size: 14,weight: .medium))
                Spacer()
            }.padding(.leading,15)
                .padding(.top,15)
            HStack {
                HStack(spacing: 10) {
                    Color(.purple)
                        .frame(width: 2)
                    Text("\(selectedDate.formatted(date: .numeric, time: .omitted))")
                        .cornerRadius(16)
                    Spacer()
                    Image(systemName: Constants.Icons.calendar).padding(.trailing,10)
                        .foregroundColor(.purple)
                }.onTapGesture {
                    showDatePicker.toggle()
                }
                .frame(height: 35)
                .background(Color.white)
                .cornerRadius(8)
                .padding()
                HStack(spacing: 10) {
                    Color(.purple)
                        .frame(width: 2)
                    Text("\(selectedTime.formatted(date: .omitted, time: .shortened))")
                        .cornerRadius(16)
                    Spacer()
                    Image(systemName: Constants.Icons.clock).padding(.trailing,10)
                        .foregroundColor(.purple)
                }.onTapGesture {
                    showTimePicker.toggle()
                }
                .frame(height: 35)
                .background(Color.white)
                .cornerRadius(8)
                .padding()
            }
            if showDatePicker {
                DatePicker(
                    "",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                .labelsHidden()
                .datePickerStyle(.graphical)
                .frame(maxHeight: 400)
                .onChange(of: selectedDate) { newValue in
                    showDatePicker.toggle()
                }
            }
            if showTimePicker {
                DatePicker(
                    "",
                    selection: $selectedTime,
                    displayedComponents: .hourAndMinute
                )
                .onChange(of: selectedTime) { newValue in
                    showTimePicker.toggle()
                }
                .labelsHidden()
                .datePickerStyle(.graphical)
            }
        }
        .background(Color(.systemGray6).clipShape(RoundedRectangle(cornerRadius:20)))
        .padding()
    }
}


struct PassengersView: View {
    var body: some View {
        VStack {
            HStack {
                Text(Constants.Titles.passengers)
                    .font(Font.system(size: 14,weight: .medium))
                Spacer()
            }.padding(.leading,15)
                .padding(.top,15)
            HStack {
                VStack(spacing: 10) {
                    HStack(spacing: 10) {
                        Image(systemName: Constants.Icons.personFill).padding(.leading,10)
                            .foregroundColor(.purple)
                        
                        Text(Constants.Titles.noOfAdults)
                            .font(Font.system(size: 12,weight: .medium))
                            .foregroundColor(Color.gray)
                        Spacer()
                    }
                    .padding(.top,10)
                    CounterView()
                }
                .background(Color.white)
                .padding()
                .cornerRadius(5)
                .shadow(color: Color.black.opacity(0.2), radius: 10,y: 5)
                
                VStack(spacing: 10) {
                    HStack(spacing: 10) {
                        Image(systemName: Constants.Icons.tshirt).padding(.leading,10)
                            .foregroundColor(.purple)
                        Text(Constants.Titles.noOfChilds)
                            .font(Font.system(size: 12,weight: .medium))
                            .foregroundColor(Color.gray)
                        Spacer()
                    }
                    .padding(.top,10)
                    CounterView()
                }
                .background(Color.white)
                .padding()
                .cornerRadius(5)
                .shadow(color: Color.black.opacity(0.2), radius: 10,y: 5)
                
            }
            
        }
        .background(Color(.systemGray6).clipShape(RoundedRectangle(cornerRadius:20)))
        .padding()
    }
}

struct ServiceView: View {
    
    var serive: Services!
    @State private var isSelected = false
    
    var body: some View {
        GeometryReader { reader in
            VStack(spacing: 8) {
                Image(uiImage: serive.image).renderingMode(.template)
                    .foregroundColor(Color(isSelected ? .white : .purple))
                Text(serive.title)
                    .foregroundColor(Color(isSelected ? .white : .black))
                
                    .font(Font.system(size: 12,weight: .semibold))
            }
            .padding()
            .frame(width: reader.size.width,height: reader.size.height)
            .background(Color(isSelected ? .purple : .white))
            .cornerRadius(8)
        }
        .frame(height: 80)
        .shadow(color: Color.black.opacity(0.2), radius: 10,y: 5)
        .onTapGesture {
            self.isSelected.toggle()
        }
    }
    
}

struct CounterView: View {
    
    @State private var counts = 0
    
    var body: some View {
        HStack {
            Text("-")
                .font(Font.system(size: 10))
                .frame(width: 30, height: 20)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.purple, lineWidth: 1)
                ).onTapGesture {
                    if counts > 0 {
                        counts -= 1
                    }
                }
            
            Text("\(counts)")
                .font(Font.system(size: 12))
                .frame(width: 30, height: 30)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.purple, lineWidth: 1)
                )
            
            Text("+")
                .font(Font.system(size: 10))
                .frame(width: 30, height: 20)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.purple, lineWidth: 1)
                ).onTapGesture {
                    counts += 1
                }
        }.padding(.top,5)
            .padding(.bottom,5)
    }
}
