import UIKit
import AKProximity
import RealmSwift
import NBLOG
import NBSync
var saveFactor = 0.00
@objc class BeaconHandler: NSObject , NBProximityLocationManagerDelegate{
    static let sharedHandler:BeaconHandler = BeaconHandler()
    var  locationManager:NBProximityManager?
    var  beacon:CLBeaconRegion?
    var _closureToScanItems:(([CLBeacon])->())?
    var coordinate:CLLocationCoordinate2D?
    var PKSyncObj:String?
    var passcount = 10
    override init() {
        super.init()
        locationManager = NBProximityManager()
        initiateRegion(self)
    }
    func dummy(coord:CLLocationCoordinate2D){
        // if(self.passcount < 10)
        //  {
        //     return
        // }
        coordinate = coord
        PKSyncObj = "\(Int64(floor(NSDate().timeIntervalSince1970 * 1000.0)))".stringByReplacingOccurrencesOfString(".", withString: "")
        locationManager?.nbStopRangingBeaconsInRegion(beacon!)
        locationManager?.nbStartRangingBeaconsInRegion(beacon!)
    }
    
   
    func locationData()->(CLLocationCoordinate2D){
        if(self.coordinate != nil)
        {
        return self.coordinate!
        }
        return kCLLocationCoordinate2DInvalid
    }

    
    
    func startBeconOperation(coord:CLLocationCoordinate2D?){
        if(self.passcount < 10)
        {
            return
        }
        coordinate = coord
        PKSyncObj = "\(Int64(floor(NSDate().timeIntervalSince1970 * 1000.0)))".stringByReplacingOccurrencesOfString(".", withString: "")
        locationManager?.nbStopRangingBeaconsInRegion(beacon!)
        locationManager?.nbStartRangingBeaconsInRegion(beacon!)
    }
   
    func stopBeconOperation(){
        NBApplicationState.sharedHandler.setRecordTime("\(Int64(floor(NSDate().timeIntervalSince1970 * 1000.0)))")
        NBApplicationState.sharedHandler.logEvent()
        NBApplicationState.sharedHandler.setRecordTime("")

        locationManager?.nbStopRangingBeaconsInRegion(beacon!)
        //  LocationUpdateHandler.sharedHandler.syncXtime()
        self.passcount = 10
    }
    
    func startRanging(){
       locationManager?.nbStartRangingBeaconsInRegion(beacon!)
    }
    func stopRanging(){
        locationManager?.nbStopRangingBeaconsInRegion(beacon!)
    }
    
    func initiateRegion(ref:BeaconHandler){
        let uuid:NSUUID = NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!//"B9407F30-F5F8-466E-AFF9-25556B57FE6D"
        //beacon = CLBeaconRegion(proximityUUID: uuid, major:1,minor: 100, identifier: "")

         beacon = CLBeaconRegion(proximityUUID: uuid, identifier:"")
        locationManager?.nbRequestAlwaysAuthorization()  //requestAlwaysAuthorization()
        beacon?.notifyOnEntry=true
        beacon?.notifyOnExit=true
        beacon?.notifyEntryStateOnDisplay=true
        
        CLLocationManager.locationServicesEnabled()
        locationManager?.nbStartMonitoringForRegion(beacon!)
        locationManager?.delegate = ref;
        if #available(iOS 9.0, *) {
            locationManager!.allowsBackgroundLocationUpdates = true
        } else {
            // Fallback on earlier versions
        };

    // Check if beacon monitoring is available for this device
    if (!CLLocationManager.isMonitoringAvailableForClass(CLBeaconRegion)) {
        print("error")
        }
    }
    
    func canDeviceSupportAppBackgroundRefresh()->Bool
    {
        if UIApplication.sharedApplication().backgroundRefreshStatus == UIBackgroundRefreshStatus.Available
        {
            // createAlert("Background Refresh Status", alertMessage: "Background Updates are enable for the App", alertCancelTitle: "OK")
            return true;
        }
        else if UIApplication.sharedApplication().backgroundRefreshStatus == UIBackgroundRefreshStatus.Denied
        {
            createAlert("Background Refresh Status", alertMessage: "Background Updates are disabled by the user for the App", alertCancelTitle: "OK")
            return false;
        }
        else if UIApplication.sharedApplication().backgroundRefreshStatus == UIBackgroundRefreshStatus.Restricted
        {
            createAlert("Background Refresh Status", alertMessage: "Background Updates are restricted and the user can't enable it", alertCancelTitle: "OK")
            return false
        }
        
        return false
    }
    
    func createAlert(alertTitle: String, alertMessage: String, alertCancelTitle: String)
    {
        
        
        let alert = UIAlertView(title: alertTitle, message: alertMessage, delegate: self, cancelButtonTitle: alertCancelTitle)
        alert.show()
    }
    func nbProximityManager(manager: NBProximityManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        NBLocationUpdateHandler.sharedHandler.nbScannerstate()
        if(!NBProximityManager.nbLocationServicesEnabled())
        {
        
        }
        if(NBProximityManager.nbAuthorizationStatus() != CLAuthorizationStatus.AuthorizedAlways )
        {
        
        }
    }
    func nbProximityManager(manager: NBProximityManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        
        if (state ==  CLRegionState.Inside)
        {

        }
        else if(state ==  CLRegionState.Outside)
        {
        }
        else
        {
            //locationManager!.stopRangingBeaconsInRegion(self.beacon!)

        }
     }
    
    func nbProximityManager(manager: NBProximityManager, didEnterRegion region: CLRegion) {
        //  utility.shoaNotification("ENTER", message: "ENTER")

        manager.nbStartRangingBeaconsInRegion(self.beacon!)
        
        // if(region .isKindOfClass(CLCircularRegion))
        // {

        // }
        // else if(region.isKindOfClass(CLBeaconRegion))
        // {
            
        //  locationManager!.startRangingBeaconsInRegion(self.beacon!)
            //   LocationTracker().startLocationTracking()
            
           
        //   LocationUpdateHandler.sharedHandler.stopSync()
        //      LocationUpdateHandler.sharedHandler.initiateTimer()
                //    if(UIApplication.sharedApplication().applicationState == UIApplicationState.Background )
        //{
        //       LocationTracker().applicationEnterBackground()
        //   }
        // }
    }
    
    func nbProximityManager(manager: NBProximityManager, didExitRegion region: CLRegion) {
        //   utility.shoaNotification("EXIT", message: "EXIT")
        if(region .isKindOfClass(CLCircularRegion))
        {

        }
        else if(region.isKindOfClass(CLBeaconRegion))
        {
            //  self.locationManager!.stopRangingBeaconsInRegion(self.beacon!)
            //   LocationTracker().stopLocationTracking()
            // LocationUpdateHandler.sharedHandler.stopSync()
        }
    }
    
    
    func nbProximityManager(manager: NBProximityManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        
        
        if(self._closureToScanItems != nil)
        {
            self._closureToScanItems!(beacons)
        }
        if(beacons.count == 0){
            // locationManager!.stopRangingBeaconsInRegion(self.beacon!)
            return
        }
        if( self.passcount > 0 )
        {
            self.passcount = passcount - 1
            dispatch_async(dispatch_queue_create("background_update", nil), {
                    self.updateSyncBeaconData(beacons)
                })
        }
        else 
        {
            
            self.stopBeconOperation()
        }
        
    }
    //MARK: DB methods
    func updateBeconInformation(beacons: [CLBeacon]){
        let realm = try! Realm()
        for becn in beacons {
            let beaconInfo = OSSBeaconInfo()
            beaconInfo.cid = " "
            beaconInfo.data = " "
            beaconInfo.lat = String(format:"%.4f",coordinate!.latitude )  //"\(coordinate!.latitude)"
            beaconInfo.long = String(format:"%.4f",coordinate!.longitude )//"\(coordinate!.longitude)"
            beaconInfo.timestamp = "\(NSDate().timeIntervalSince1970)"
            beaconInfo.uuid = "test_UUID"
            beaconInfo.major = "\(becn.major)"
            beaconInfo.minor = "\(becn.minor)"
            beaconInfo.synced = false
            try! realm.write({
            realm.add(beaconInfo)
           })
        
        }
        
    }
    
    func updateBeconLocation(beacons: [CLBeacon]){
          let realm = try! Realm()
          let event = OSSEvent()
        event.eventType = "beacon transit"
        event.eventDescription = "La: \(coordinate!.latitude)+ Lg:\(coordinate!.longitude)"
        event.eventDate=NSDate()
        for becn in beacons {
            var  becon: OSSBeacon?
            becon = realm.objectForPrimaryKey(OSSBeacon.self, key: "\(becn.major)\(becn.minor)")
            if(becon == nil)
            {
            becon = OSSBeacon()
                try! realm.write {
                    becon!.name="Major:\(becn.major) Minor:\(becn.minor)"
                    becon!.id="\(becn.major)\(becn.minor)"
                    becon!.event.append(event)
                    realm.add(becon!, update: true)
                }

            }
            else{
                try! realm.write {
                    becon!.name="Major:\(becn.major) Minor:\(becn.minor)"
                    becon!.event.append(event)
                    realm.add(becon!, update: true)
                }

            }
        }
        
    }
    func updateBeconLocationEnter(region: CLRegion){
        //let realm = try! Realm()
        let event = OSSEvent()
        event.eventType = "Region Enter"
        event.eventDescription = "La: \(BeaconHandler.sharedHandler.coordinate!.latitude)+ Lg:\(BeaconHandler.sharedHandler.coordinate!.longitude)"
        event.eventDate=NSDate()
        
        var  loc: OSSGeoLocation?
        loc = realm.objectForPrimaryKey(OSSGeoLocation.self, key: "\(region.identifier)")
        if(loc == nil)
        {
            loc = OSSGeoLocation()
            try! realm.write {
                loc!.locationName="\(region.identifier)"
                loc!.identifier="\(region.identifier)"
                loc!.event.append(event)
                realm.add(loc!, update: true)
            }
            
        }
        else{
            try! realm.write {
                loc!.locationName="\(region.identifier)"
                loc!.event.append(event)
                realm.add(loc!, update: true)
            }
            
        }
       

        
    }
    func updateBeconLocationExit(region: CLRegion){
        // let realm = try! Realm()
        let event = OSSEvent()
        event.eventType = "Region Exit"
        event.eventDescription = "La: \(BeaconHandler.sharedHandler.coordinate!.latitude)+ Lg:\(BeaconHandler.sharedHandler.coordinate!.longitude)"
        event.eventDate=NSDate()
        var  loc: OSSGeoLocation?
        loc = realm.objectForPrimaryKey(OSSGeoLocation.self, key: "\(region.identifier)")
        if(loc == nil)
        {
            loc = OSSGeoLocation()
            try! realm.write {
                loc!.locationName="\(region.identifier)"
                loc!.identifier="\(region.identifier)"
                loc!.event.append(event)
                realm.add(loc!, update: true)
            }
            
        }
        else{
            try! realm.write {
                loc!.locationName="\(region.identifier)"
                loc!.event.append(event)
                realm.add(loc!, update: true)
            }
            
        }
    }
    func updateSyncBeaconData(beacons: [CLBeacon]){

        let realm = try! Realm()
        var syncObj: OSSSyncObject?
        syncObj = realm.objectForPrimaryKey(OSSSyncObject.self, key: self.PKSyncObj!)
        if(syncObj == nil)
        {
            NBApplicationState.sharedHandler.setRole = role
            syncObj = OSSSyncObject()
            try! realm.write {
                syncObj!.id = self.PKSyncObj!
                syncObj!.synced=false
                syncObj!.lat = String(format:"%.6f",coordinate!.latitude )// "\(coordinate!.latitude)"
                syncObj!.lng = String(format:"%.6f",coordinate!.longitude )// "\(coordinate!.longitude)"
                syncObj!.alt = NBApplicationState.sharedHandler.getAltitude()
                syncObj!.speed = NBApplicationState.sharedHandler.getSpeed()
                syncObj!.accuracy = NBApplicationState.sharedHandler.getAccuracy()
                syncObj!.direction =  NBApplicationState.sharedHandler.getDirection()
                for becn in beacons {
                    let state = NBSensorStateModel()
                    state.major = "\(becn.major)"
                    state.minor = "\(becn.minor)"
                    state.proximity = "\(becn.proximity.rawValue)"
                    state.longitude = String(format:"%.6f",coordinate!.longitude )
                    state.lattitude = String(format:"%.6f",coordinate!.latitude )
                    state.UDIDBeacon = becn.proximityUUID.UUIDString
                    NBApplicationState.sharedHandler.setRole = role
                    NBApplicationState.sharedHandler.setSensorData(state)
                    
                    
                    let beaconInfo = OSSBeaconInfo()
                    beaconInfo.cid = ""
                    beaconInfo.data = ""
                    beaconInfo.lat = String(format:"%.6f",coordinate!.latitude )
                    beaconInfo.long = String(format:"%.6f",coordinate!.longitude )
                    beaconInfo.timestamp = "\(Int64(floor(NSDate().timeIntervalSince1970 * 1000.0)))"
                    beaconInfo.uuid =  becn.proximityUUID.UUIDString
                    beaconInfo.major = "\(becn.major)"
                    beaconInfo.minor = "\(becn.minor)"
                    beaconInfo.distance = "\(becn.accuracy)"
                    beaconInfo.rssi = "\(becn.rssi)"
                    beaconInfo.synced = false
                    beaconInfo.proximity = "\(becn.proximity.rawValue)"
                    beaconInfo.id = "\(becn.major)\(becn.minor)\(syncObj!.id)"
                    let sampleBeacon = realm.create(OSSBeaconInfo.self, value: beaconInfo, update: true)
                    syncObj!.event.append(sampleBeacon)
                    realm.add(syncObj!, update: true)
                }
            }
        }
        else{
            NBApplicationState.sharedHandler.setRole = role
            try! realm.write {
                syncObj!.lat = String(format:"%.6f",coordinate!.latitude )//"\(coordinate!.latitude)"
                syncObj!.lng = String(format:"%.6f",coordinate!.longitude )// "\(coordinate!.longitude)"
                syncObj!.alt = NBApplicationState.sharedHandler.getAltitude()
                syncObj!.speed = NBApplicationState.sharedHandler.getSpeed()
                syncObj!.accuracy = NBApplicationState.sharedHandler.getAccuracy()
                syncObj!.direction =  NBApplicationState.sharedHandler.getDirection()

                for becn in beacons {
                    let state = NBSensorStateModel()
                    state.major = "\(becn.major)"
                    state.minor = "\(becn.minor)"
                    state.proximity = "\(becn.proximity.rawValue)"
                    state.longitude = String(format:"%.6f",coordinate!.longitude )
                    state.lattitude = String(format:"%.6f",coordinate!.latitude )
                    state.UDIDBeacon = becn.proximityUUID.UUIDString
                    NBApplicationState.sharedHandler.setSensorData(state)
                    let beaconInfo = OSSBeaconInfo()
                    beaconInfo.cid = ""
                    beaconInfo.data = ""
                    beaconInfo.lat = String(format:"%.6f",coordinate!.latitude )// "\(coordinate!.latitude)"
                    beaconInfo.long = String(format:"%.6f",coordinate!.longitude )// "\(coordinate!.longitude)"
                    beaconInfo.timestamp = "\(Int64(floor(NSDate().timeIntervalSince1970 * 1000.0)))"
                    beaconInfo.uuid =  becn.proximityUUID.UUIDString
                    beaconInfo.major = "\(becn.major)"
                    beaconInfo.minor = "\(becn.minor)"
                    beaconInfo.synced = false
                    beaconInfo.distance = "\(becn.accuracy)"
                    beaconInfo.rssi = "\(becn.rssi)"
                    beaconInfo.proximity = "\(becn.proximity.rawValue)"
                    beaconInfo.id = "\(becn.major)\(becn.minor)\(syncObj!.id)"
                    if let sampleBeacon = syncObj!.event.filter("id = '\(becn.major)\(becn.minor)\(syncObj!.id)'").first{//realm.create(OSSBeaconInfo.self, value: beaconInfo, update: true)
                        sampleBeacon.lat = String(format:"%.6f",coordinate!.latitude )//"\(coordinate!.latitude)"
                        sampleBeacon.long = String(format:"%.6f",coordinate!.longitude )//"\(coordinate!.longitude)"
                        sampleBeacon.timestamp = "\(Int64(floor(NSDate().timeIntervalSince1970 * 1000.0)))"
                        //syncObj!.event.append(sampleBeacon)
                    }
                    else{
                        let sampleBeacon=realm.create(OSSBeaconInfo.self, value: beaconInfo, update: true)
                        syncObj!.event.append(sampleBeacon)
                    }
                    realm.add(syncObj!, update: true)
                }
            }
            
        }
        
        
    }
    
}
