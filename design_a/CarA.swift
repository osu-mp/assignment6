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
myCar.openDoor(Door.Driver)
//myCar.honkHorn()

//myCar.turnOff()

// TODO: on shutdown
// record weight on all seats
// driver opens door, leaves seat, closes door
// start timer
// when timer ends, if weight remains on then alert
// add test cases

// TODO class/function implementations
// DONE car: honk horn (allow for different alerts)
// car: door open/close
// car: add seats
// car: trunk?
// seat class: weight on seat, isDriver


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
            print("Driver opened door")
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