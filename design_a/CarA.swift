import Foundation

let gasEngine = GasEngine()
let basicStereo = BasicStereo()
let myCar = RememberCar(carStrereo: basicStereo, engine: gasEngine)
myCar.go()
myCar.turnOn()
myCar.go()
myCar.turnOff()

class RememberCar: BasicCar {
    public override func turnOff(){
        super.turnOff();
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
}

/*
Standard car requirements/features
*/
public protocol CarStandard {
    func turnOn()
    func turnOff()
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