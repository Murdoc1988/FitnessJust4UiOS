//
//  HomeView.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 31.05.23.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject private var hvm = HomeViewModel()
    @State private var currentIndex: Int = 0
    
    
    var body: some View {
        VStack{
            if(!hvm.bodyLogs.isEmpty){
            GeometryReader { geometry in
                ScrollViewReader { scrollViewProxy in
                    ScrollView(.horizontal){
                        HStack(spacing: 10){
                            ForEach(0..<hvm.bodyLogs.count - 1, id: \.self) { index in
                                
                                let weightData = [
                                    CGPoint(x: 0, y: hvm.bodyLogs[index].bweight),
                                    CGPoint(x: 1, y: hvm.bodyLogs[index + 1].bweight)
                                ]
                                
                                let bodyFatData = [
                                    CGPoint(x: 0, y: hvm.bodyLogs[index].bbody_fat),
                                    CGPoint(x: 1, y: hvm.bodyLogs[index + 1].bbody_fat)
                                ]
                                
                                let frame = CGRect(x: 0, y: 0, width: 1, height: 100)
                                
                                if index % 2 == 0 {
                                    LineChart(data: weightData, frame: frame)
                                        .frame(width: geometry.size.width - 40, height: 200)
                                        .id(index)
                                        .padding(8)
                                } else {
                                    LineChart(data: bodyFatData, frame: frame)
                                        .frame(width: geometry.size.width - 40, height: 200)
                                        .id(index)
                                        .padding(8)
                                        .foregroundColor(.red)
                                }
                                
                            }
                        }                }
                    
                }
                
                
            }
        }
            Spacer()
            Text("\(hvm.user)")
            Text("\(hvm.apiToken)")
        }
    }
    struct LineChart: View {
        var data: [CGPoint]
        var frame: CGRect
        
        var body: some View {
            GeometryReader { geometry in
                Path { path in
                    guard data.count > 1 else { return }
                    
                    let scaleX = (geometry.size.width - 40) / CGFloat(frame.width)
                    let scaleY = 200 / CGFloat(frame.height)
                    
                    path.move(to: data.first!)
                    for point in data.dropFirst() {
                        let x = point.x * scaleX
                        let y = 200 - point.y * scaleY
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
                .stroke(Color.blue, lineWidth: 2)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
