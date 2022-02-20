import Foundation

// create the car instance
let gasEngine = GasEngine()
let basicStereo = BasicStereo()
let myCar = RememberCar(carStrereo: basicStereo, engine: gasEngine)

// do a basic run/test
//myCar.go()
//myCar.turnOn()
//myCar.go()
myCar.honkHorn()
myCar.openDoor(Door.Passenger)
myCar.closeDoor(Door.Driver)
//myCar.honkHorn()

//myCar.turnOff()

// TODO (nice to have) record weights when car starts
// if changes while moving-> alarm

// TODO: on shutdown
// record weight on all seats
// driver leaves seat, closes door
// start timer (10 seconds?)
// when timer ends, if weight remains on then alert
// add test cases

// TODO class/function implementations
// DONE car: honk horn (allow for different alerts)
// DONE door open/close
// car: add seats
// seat class: weight on seat, isDriver

// Teja TODO: create seat instances in BasicCar class
// TODO : on car shutdown get all weights
// TODO : on driver exit, compare current weights against saved weight
// TODO : if any differences, alert driver (honk)

class RememberCar: BasicCar, CarRemember {
    public override func turnOff(){
        super.turnOff();
        doRememberAlert()
    }

    public func doRememberAlert(){
        print("Did you remember xyz?")
    }

    public override func closeDoor(_ door: Door){
        // we only care about driver leaving
        switch door{
        case .Driver:
            print("Driver closed door")
        default:
            print("Don't care about this door")
        }
    }
}

class BasicCar: CarStandard {
    let carStereo: CarStereo
    let engine: Engine

    public init(carStrereo: CarStereo, engine: Engine){
        self.carStereo = carStrereo
        self.engine = engine
    }

    public func turnOn(){
        self.engine.start()
    }

    public func turnOff(){
        self.engine.stop()
        self.carStereo.shutDown()
        // initNeverForgetFlow();

    }

    public func go(){
        self.engine.accelerate()
    }

    public func honkHorn(_ level: HonkLevel? = nil) {
        switch level {
        case .minor:                  // default behvior if no input given
            fallthrough
        case .major:
            print("beeeeep")
        case .critical:
            print("BEEP BEEP BEEP")
        default:
            print("beep")
        }
    }

    public func openDoor(_ door: Door){
        // blank for now
    }
    public func closeDoor(_ door:Door){

    }

}

public enum HonkLevel {
    case minor    // TODO fix case
    case major
    case critical
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
    func doRememberAlert()
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