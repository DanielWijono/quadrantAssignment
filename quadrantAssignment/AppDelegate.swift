//
//  AppDelegate.swift
//  quadrantAssignment
//
//  Created by Daniel Wijono on 14/04/22.
//

import UIKit
import BackgroundTasks


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let backgroundTaskId = AppSetting.shared.infoForKey(AppConstant.backgroundTaskId.rawValue)
        BGTaskScheduler.shared.register(forTaskWithIdentifier: backgroundTaskId, using: nil) { bgTask in
            self.handleBackgroundAppRefresh(task: bgTask as! BGAppRefreshTask)
        }

        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) { }

    func handleBackgroundAppRefresh(task: BGAppRefreshTask) {
        scheduleBackgroundRefresh()
        NetworkService.instance.request(DashboardService.getCurrentPrice, c: CurrentPriceResponse.self) { result in
            switch result {
            case .success(let res):
                let dateTime = res.time.updatedISO
                let currentPrice = res.bpi.usd.rateFloat
                let longitude = String(LocationService.shared.getLongitude())
                let latitude = String(LocationService.shared.getLatitude())
                let priceIndex = PriceIndex(updatedDateTime: dateTime, longitude: longitude, latitude: latitude, value: currentPrice)

                if let priceIndexData = try? DataService.shared.load(key: PriceIndex.structName) {
                    do {
                        var priceIndexArray = try JSONDecoder().decode([PriceIndex].self, from: priceIndexData)
                        priceIndexArray.append(priceIndex)
                        let sortedList = priceIndexArray.sorted {
                            $0.updatedDateTime.toDate().compare($1.updatedDateTime.toDate()) == .orderedDescending }
                        try DataService.shared.save(data: sortedList, key: PriceIndex.structName)
                    } catch {
                        print("catch error")
                    }
                }
            case .failure(let error):
                print(error)
            }
            task.setTaskCompleted(success: true)
        }
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
    }

    func scheduleBackgroundRefresh() {
        let backgroundTaskId = AppSetting.shared.infoForKey(AppConstant.backgroundTaskId.rawValue)
        let backgroundTaskRequest = BGAppRefreshTaskRequest(identifier: backgroundTaskId)
        backgroundTaskRequest.earliestBeginDate = Date(timeIntervalSinceNow: 3600) //60 minutes from now
        do {
            try BGTaskScheduler.shared.submit(backgroundTaskRequest)
        } catch {
            print("fail to schedule background app refresh")
        }
    }
}

