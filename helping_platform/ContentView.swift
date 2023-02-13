//
//  ContentView.swift
//  helping_platform
//
//  Created by 王哲 on 2023/2/8.
//


//127.0.0.1:3000/login
//127.0.0.1:3000/register
//127.0.0.1:3000/upload
//127.0.0.1:3000/show_all
//127.0.0.1:3000/show_mine
//127.0.0.1:3000/detail
//127.0.0.1:3000/
//127.0.0.1:3000/

//192.168.1.10

import SwiftUI
import Alamofire

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Text("Welcome to my app!")
                    .font(.largeTitle)
                Spacer()
                NavigationLink(destination: LoginView()) {
                    Text("Login")
                }
                Spacer()
                NavigationLink(destination: RegisterView()) {
                    Text("Register")
                }
                Spacer()
                NavigationLink(destination: HomeView()){
                    Text("Homeview")
                }
            }
        }
    }
}

struct Login : Encodable{
    var name:String
    var password:String
}

struct Register : Encodable{
    var name:String
    var password:String
}

struct LoginView: View {
    @State private var name = ""
    @State private var password = ""
    @State private var message = " "
    @State private var isActive = false
    @State var person_token = " "
    
    
    var body: some View {
        NavigationStack{
            VStack{
                NavigationLink(destination:
                                HomeView(person_token:person_token),
                               isActive: $isActive){EmptyView()}
                TextField("Name",text:$name)
                    .padding()
                    .background(Color.brown)
                    .cornerRadius(50)
                    .shadow(radius: 5.0)
                SecureField("Password",text:$password)
                    .padding()
                    .background(Color.brown)
                    .cornerRadius(50)
                    .shadow(radius: 5.0)
                let login = Login(name:name,password:password)
                Button(action:{
                    AF.request("http://192.168.1.4:3000/login",
                               method: .post,
                               parameters: login,
                               encoder: JSONParameterEncoder.default).response { response in
                        switch response.result {
                            case .success(let value):
                                let json = value as? [String: Any]
                                let token = json?["token"] as? String
                                isActive = true
                            person_token = token ?? <#default value#>
                            case .failure(let error):
                                print(error)
                            }
                        
                    }
                    
                }
                       
                ){Text("login")}
            }
        }
    }
}



struct RegisterView: View {
    @State private var name=""
    @State private var password=""
    @State private var message = " "
    @State private var isActive = false
    
    
    var body: some View {
            
            TextField("Name",text:$name)
                .padding()
                .background(Color.brown)
                .cornerRadius(50)
                .shadow(radius: 5.0)
            SecureField("Password",text:$password)
                .padding()
                .background(Color.brown)
                .cornerRadius(50)
                .shadow(radius: 5.0)
            let register = Register(name:name,password:password)
            Button(action:{
                AF.request("http://192.168.1.4:3000/register",
                           method: .post,
                           parameters: register,
                           encoder: JSONParameterEncoder.default).response { response in
                    if response.response?.statusCode == 200{
                        isActive = true
                    }else{
                        message="Account already exist!"
                    }
                }
            }){Text("Register")}
        }
    }

                               
struct HomeView:View{
    @State var person_token : String = " "
    
    
    var body:some View{
        NavigationStack{
            VStack{
                Spacer()
                Text("Welcome Home!")
                    .font(.largeTitle)
                Spacer()
                NavigationLink(destination: ApplyView(person_token: person_token)) {
                    Text("Apply")
                }
                Spacer()
                NavigationLink(destination: MyProjectView(person_token: person_token)) {
                    Text("Mine")
                }
                Spacer()
                NavigationLink(destination: AllProjectView(person_token: person_token)){
                    Text("Projects")
                }
                           .onAppear {
                               let headers: HTTPHeaders = [
                                   "Authorization": "Bearer \(person_token)"
                               ]

                               AF.request("http://192.168.1.4:3000/show_all", headers: headers).responseJSON { response in
                                   switch response.result {
                                   case .success(let value):
                                       print(value)
                                   case .failure(let error):
                                       print(error)
                                   }
                               }
                           }
                       }
                    
                }
            }
        }



struct ApplyView:View{
    @State var person_token : String = " "
    var body:some View{
        Text("Apply")
    }
}

struct MyProjectView:View{
    @State var person_token : String = " "
    var body:some View{
        Text("Mine")
    }
}

struct AllProjectView:View{
    @State var person_token : String = " "
    var body:some View{
        Text("All")
    }

        
        
    
}





       
