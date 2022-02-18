import Foundation

let gasEngine = GasEngine()
let basicStereo = BasicStereo()
let myCar = Car(carStrereo: basicStereo, engine: gasEngine)
myCar.go()
myCar.turnKey()
myCar.go()

class Car {
    let carStereo: CarStereo
    let engine: Engine

    public init(carStrereo: CarStereo, engine: Engine){
        self.carStereo = carStrereo
        self.engine = engine
    }

    public func turnKey(){
        self.engine.start()
    }

    public func go(){
        self.engine.accelerate()
    }

    public func turnOff(){
        initNeverForgetFlow();
        self.carStereo.tu
    }
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
    public func shutDown()
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
        print("Stopped")
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