import Foundation

// create the car instance
let gasEngine = GasEngine()
let basicStereo = BasicStereo()
let driverSeat = CarSeatImpl()
let passengerSeat = CarSeatImpl()
let myCar = RememberCar(carStrereo: basicStereo, engine: gasEngine, driverSeat: driverSeat, passengerSeat: passengerSeat)

/* CASE 1: passenger remains
   EXPECT: alert
driver and passenger get in, go somewhere
driver turns off car
driver exits (gets off seat and closes door)
(passenger remains)
alert that weight still on passgenger seat
*/
print("CASE 1: Passenger remains (expect major honk)")
myCar.openDoor(Door.Passenger)
passengerSeat.setWeight(weight: 130)
myCar.closeDoor(Door.Passenger)
myCar.openDoor(Door.Driver)
driverSeat.setWeight(weight: 150)
myCar.closeDoor(Door.Driver)
myCar.turnOn()
myCar.go()
myCar.turnOff()
myCar.openDoor(Door.Driver)
driverSeat.setWeight(weight: 0)
myCar.closeDoor(Door.Driver)

/* CASE 2: passenger exits with driver
   EXPECT: no alert
driver and passenger get in, go somewhere
driver turns off car
passenger exits
driver exits (gets off seat and closes door)
check weight on seats (both empty): no alert
*/
print("\nCASE 2: Passenger leaves with driver (no honk)")
myCar.openDoor(Door.Passenger)
passengerSeat.setWeight(weight: 130)
myCar.closeDoor(Door.Passenger)
myCar.openDoor(Door.Driver)
driverSeat.setWeight(weight: 150)
myCar.closeDoor(Door.Driver)
myCar.turnOn()
myCar.go()
myCar.turnOff()
myCar.openDoor(Door.Passenger)
passengerSeat.setWeight(weight: 0.0)
myCar.closeDoor(Door.Passenger)
myCar.openDoor(Door.Driver)
driverSeat.setWeight(weight: 0.0)
myCar.closeDoor(Door.Driver)

// RememberCar is also a coupe (2 seats), has extra safety feature: check for people/things left on shutdown:
// Wait until driver leaves seat, closes door
// if weight remains on any other seats then alert
class RememberCar: BasicCar, CarRemember {
    var driverInSeat = false

    public override func turnOff(){
        super.turnOff();
        initRememberAlert()              // extra feature, check for left people/things
    }

    public func initRememberAlert(){
        // get all weights on seats (passngers only)
        let passengerWeight = self.passengerSeat.getWeight()
        if(passengerWeight > 0.0){
            print("INFO: Passenger weight of \(passengerWeight) marked")
        }
        else{
            print("INFO: Passenger seat empty")
        }
    }

    public func checkRememberAlert(){
        // Driver has left for car, alert if any weight remains on passenger seat
        // Future TODO : add delay timer
        if(self.passengerSeat.getWeight() > 0.0){
            print("INFO: Someone/something left on passenger seat, honking")
            self.honkHorn(HonkLevel.Major)
        }
    }

    public override func closeDoor(_ door: Door){
        // we only care about driver leaving
        switch door{
        case .Driver:
            let weight = self.driverSeat.getWeight()
            if(0.0 == weight){
                checkRememberAlert()
            }
        default:
            break     // don't care about other seats right now
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
        print("Engine started")
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