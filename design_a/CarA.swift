import Foundation

// create the car instance
let gasEngine = GasEngine()
let basicStereo = BasicStereo()
let driverSeat = CarSeatImpl()
let passengerSeat = CarSeatImpl()
let myCar = RememberCar(carStrereo: basicStereo, engine: gasEngine, driverSeat: driverSeat, passengerSeat: passengerSeat)

// do a basic run/test
//myCar.go()                    // car must be turned on first
//myCar.turnOn()
//myCar.go()
myCar.honkHorn()                // default to minor beep if no input given
myCar.openDoor(Door.Passenger)
myCar.closeDoor(Door.Driver)
driverSeat.setWeight(weight: 150)
passengerSeat.setWeight(weight: 130)
//myCar.honkHorn()
myCar.turnOff()
myCar.closeDoor(Door.Driver)
/* CASE 1: passenger remains
   EXPECT: alert
driver gets in
passgenger gets in
driver turns off car
driver exits (closes door)
(passenger remains)
after timer expires, alert that weight still on passgenger seat
*/

/* CASE 2: passenger exits with driver
   EXPECT: no alert
driver gets in
passgenger gets in
driver turns off car
passenger exits
driver exits (closes door)
timer expires, check weight on seats (both empty)
no alert
*/


// TODO: on shutdown
// record weight on all seats
// driver leaves seat, closes door
// start timer (10 seconds?)
// when timer ends, if weight remains on then alert
// add test cases

// TODO class/function implementations
// car: add seats
// seat class: weight on seat, isDriver

// TODO : on car shutdown get all weights
// TODO : on driver exit, compare current weights against saved weight
// TODO : if any differences, alert driver (honk)

class RememberCar: BasicCar, CarRemember {
    var driverInSeat = false

    //public override init(carStrereo: CarStereo, engine: Engine, driverSeat: CarSeat, passengerSeat: CarSeat){
    //  super.init(carStrereo: CarStereo, engine: Engine, driverSeat: CarSeat, passengerSeat: CarSeat)
    //}

    public override func turnOff(){
        super.turnOff();
        initRememberAlert()
    }

    public func initRememberAlert(){
        // get all weights on seats (passngers only)
        let passengerWeight = self.passengerSeat.getWeight()
        if(passengerWeight > 0){
            print("INFO: Passenger weight of \(passengerWeight) marked")
        }
    }

    public func checkRememberAlert(){
        // start timer
        print("TODO timer")
        // if weights on any other seats after timer, do alert
        print("TODO check weights on seats")
    }

    public override func closeDoor(_ door: Door){
        // we only care about driver leaving
        switch door{
        case .Driver:
            print("Driver closed door")
            let weight = self.driverSeat.getWeight()
            if(weight > 0){
                self.driverInSeat = true
            }
            else{
                self.driverInSeat = false
                checkRememberAlert()
            }
        default:
            print("Don't care about this door")
        }
    }


}

// Basic car is a two door coupe (only 2 seats)
class BasicCar: CarStandard {
    let carStereo: CarStereo
    let engine: Engine
    let driverSeat: CarSeat
    let passengerSeat: CarSeat

    public init(carStrereo: CarStereo, engine: Engine, driverSeat: CarSeat, passengerSeat: CarSeat){
        self.carStereo = carStrereo
        self.engine = engine
        self.driverSeat = driverSeat
        self.passengerSeat = passengerSeat
    }

    public func turnOn(){
        self.engine.start()
    }

    public func turnOff(){
        self.engine.stop()
        self.carStereo.shutDown()
    }

    public func go(){
        self.engine.accelerate()
    }

    public func honkHorn(_ level: HonkLevel? = nil) {
        switch level {
        case .Minor:                  // default behvior if no input given
            fallthrough
        case .Major:
            print("beeeeep")
        case .Critical:
            print("BEEP BEEP BEEP")
        default:
            print("beep")
        }
    }

    public func openDoor(_ door: Door){}
    public func closeDoor(_ door:Door){}
}

public enum HonkLevel {
    case Minor, Major, Critical
}

public enum Door {
    case Driver, Passenger, RearDriverSide, ReaderPassengerSide, Trunk
}
/*
Standard car requirements/features
*/
public protocol CarStandard {
    func turnOn()
    func turnOff()
    func honkHorn(_ level: HonkLevel?)
    func openDoor(_ door: Door)
    func closeDoor(_ door:Door)
}

/*
Optional safety feature: remember reminder
*/
public protocol CarRemember: CarStandard{
    func initRememberAlert()
    func checkRememberAlert()
}

public protocol Engine {
    func accelerate()
    func start()
    func stop()
}

public protocol CarStereo {
    func play()
    func pause()
    func volume(level: Double)
    func next()
    func shutDown()
}

public protocol CarSeat {
    func getIsBuckled() -> Bool
    func getWeight() -> Double
    func setWeight(weight: Double)
}

public class CarSeatImpl: CarSeat {
    private var isBuckled = false
    private var weight = 0.0

    public init(){}

    public func getIsBuckled() -> Bool{
        return self.isBuckled
    }

    public func getWeight() -> Double {
        return self.weight
    }

    public func setWeight(weight: Double){
        self.weight = weight
    }

}
public class GasEngine: Engine{
    var running = false

    public func accelerate() {
        if self.running{
            print("VROOM")
        }
        else{
            print("No vroom (engine must be started first)")
        }
    }

    public func start(){
        self.running = true
        print("Started")
    }

    public func stop(){
        self.running = false
        print("Engine stopped")
    }
}

public class GasEngineV8: GasEngine{
    // inherited from gas engine, this has more power, hence the extra vroom
    override public func accelerate() {
        if self.running{
            print("VROOM VROOM")
        }
        else{
            print("No vroom (engine must be started first)")
        }
    }

}

public class BasicStereo: CarStereo{
    var volumeLevel = 0.0

    public func play(){}
    public func pause(){}
    public func volume(level: Double){
        // TODO limit volume to allowed range
        self.volumeLevel = level
    }
    public func next(){}

    public func shutDown(){
        print("Radio shut down")
    }
}