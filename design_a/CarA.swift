import Foundation

// create the car instance
let gasEngine = GasEngine()
let basicStereo = BasicStereo()
let myCar = RememberCar(carStrereo: basicStereo, engine: gasEngine)

// do a basic run/test
//myCar.go()
//myCar.turnOn()
//myCar.go()

myCar.honkHorn(HonkLevel.minor)
myCar.honkHorn(HonkLevel.major)
myCar.honkHorn(HonkLevel.critical)
myCar.honkHorn()
//myCar.honkHorn()

//myCar.turnOff()

// TODO:
// record weight on all seats
// driver opens door, leaves seat, closes door
// start timer
// when timer ends, if weight remains on then alert
// add test cases

// TODO class/function implementations
// car: honk horn (allow for different alerts)
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
        case .minor:
            print("beep")
        case .major:
            print("beeeeep")
        case .critical:
            print("BEEP BEEP BEEP")
        default:
            print("beep")
        }
    }

}

public enum HonkLevel {
    case minor
    case major
    case critical
}
/*
Standard car requirements/features
*/
public protocol CarStandard {
    func turnOn()
    func turnOff()
    func honkHorn(_ level: HonkLevel?)
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