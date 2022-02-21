#!/usr/bin/env swift
import Foundation

/*

 Please allow execute permission for this file before running it: ` chmod u+x main.swift `
The car is implemented with the following safety features:
 - The user can turn on/off the following safety features of the car:
        - Lane assist
        - Automatic breaking
 - The Car doesn't start until driver is properly seated and buckled up.
 - Turning on/off the safety features affects the speed limiter (Default:180)
     - Detection of snowy, rainy or foggy conditions may affect the speed limiter as well
     - Weather is simulated with a random bool
 - The user is stuck in the car until he turns off the engine.

 */


let engine = Honda()

let environment=Environment()
let car=Car( engine:engine, environment:environment )
//
//car.unlock()
//car.buckleUp()
//car.start()

var exit: Bool = true


while(exit)
{   let userInput = readLine()

    print("Use the menu to interact with the car")
    print("""
           0/unlock - Unlocks the car
           1/lock - lock the car
           2/start - start the engine
           3/stop - stop the engine
           4/buckleup - Buckle up and sit in the seat before you start the car
           5/unbuckle - Unbuckle and leave the car
           6/turnoff_automatic_breaking - Turn off automatic breaking
           7/turnoff_lane_assist - Turn off lane assist
           8/turnon_automatic_breaking - Turn on automatic breaking
           9/turnon_lane_assist - Turn on lane assist
          10/change_password - Change the current password to turn on the engine
           
           e/exit - exit the car

          """)

    switch userInput{
    case "unlock","0":
        car.unlock()
    case "lock","1":
        car.lock()
    case "start","2":
        car.start()
    case "stop","3":
        car.stop()
    case "buckleup","4":
        car.buckleUp()
    case "unbuckle","5":
        car.unbuckle()
    case "turnoff_automatic_breaking","6":
        car.turnOffAutomaticBreaking()
    case "turnoff_lane_assist","7":
        car.turnOfflaneAssist()
    case "turnon_automatic_breaking","8":
        car.turnOnAutomaticBreaking()
    case "turnon_lane_assist","9":
        car.turnOnlaneAssist()
    case "change_password","10":
        car.changePassword()
    case "exit","e":
        exit=false
        car.stop()
        car.unbuckle()
        car.lock()
    default:
        print("please choose one of the options mentioned")

    }


}
protocol Drivable{

    func unlock()
    func lock()
    func start()
    func stop()
    func buckleUp(weight: Int)
    func unbuckle()
    func turnOffAutomaticBreaking()
    func turnOfflaneAssist()


}

protocol VehicleChecks{
    func isSeated()->Bool
    func currentSpeedLimit()->Double
}
class Car: Drivable, VehicleChecks {

    let engine: Engine
    let environment: Environment
    private var doorsLocked: Bool = true
    private var automaticBreakingOn: Bool = false
    private var laneAssistOn: Bool = false
    private var seatWeight: Int = 0
    private var seatBeltsOn: Bool = false
    private var speedLimiter: Double = 0.0
    private var pass: String = ""
    private var pass_counter=0
    private var engineDisabled = false
    init( engine: Engine, environment: Environment ){

        self.engine = engine
        self.environment = environment
        let userInput=getpass("Enter your password")
        self.pass = String(cString:userInput!)
        print("Your password is \(self.pass)")




    }

    func unlock(){
        doorsLocked=false
        print("Doors are unlocked")
    }

    func lock(){
        doorsLocked = true
        print("Doors are locked")
    }

    func checkPassword()->Bool{

        let userInput=getpass("Enter Password to start the engine")


        if String(cString:userInput!) == self.pass{
            print("User Authenticated")
            return true
        }
        else{

            return false
        }




    }
    func start(){
        if engineDisabled{
            print("Engine is disabled due to too many wrong password attempts. Please contact customer support")
            return
        }
        if self.isSeated() {
            if self.checkPassword() {
                self.engine.start()
                automaticBreakingOn = true
                laneAssistOn = true
                doorsLocked = true
                self.setSpeedlimiter(speed: 180)
                self.resetSpeedLimiter() // reduced speed limit based on prevailing environmental conditions
            }
            else{
                print("Wrong Password, try again")
                self.pass_counter+=1
                if self.pass_counter>=3{
                    print("Vehicle Engine - Locked. Please contact CS561 to authenticate yourself and reset the password")
                    engineDisabled = true
                }
            }
        }
        else{
            print("Need to be properly seated and buckled up")
        }
    }

    func stop(){
        if engineDisabled{
            print("Engine is disabled due to too many wrong password attempts. Please contact customer support")
            return
        }
        self.engine.stop()
        automaticBreakingOn = false
        laneAssistOn = false
        doorsLocked = false
    }

    func buckleUp(weight: Int = 60) {
        if doorsLocked == false {
            seatWeight = weight
            seatBeltsOn = true
            print("Driver is buckled up")
        }
        else{
            print("Doors are locked")
        }

    }

    func unbuckle(){
        if self.engine.getEngineStatus(){
            print("Please turn off the engine to unbuckle yourself")
        }
        else {
            seatWeight = 0
            seatBeltsOn = false
            print("Driver has unbuckled himself")
        }


    }
    func isSeated() -> Bool {
        if seatWeight > 20{
            if seatBeltsOn{
                return true
            }
            else{
                print("Seat belts are not used, Engine won't start")
                return false
            }

        }
        else{
            print("Driver is not seated, Engine won't start")
            return false
        }
    }

    func resetSpeedLimiter(){
        var finalSpeed:Double=0.0

        finalSpeed=self.currentSpeedLimit()
        if self.environment.checkSnowing(){
            finalSpeed=finalSpeed-15

            print("Snowy conditions, speed limit will be set to: \(finalSpeed)")

        }
        if self.environment.checkFoggy(){
            finalSpeed=finalSpeed-12

            print("Foggy conditions, speed limit will be set to: \(finalSpeed)")
        }
        if self.environment.checkRaining(){
            finalSpeed=finalSpeed-11

            print("Rainy conditions, speed limit will be set to: \(finalSpeed)")
        }
        print("Due to prevailing conditions, final speed set to: \(finalSpeed)")
        self.setSpeedlimiter(speed: finalSpeed)

    }
    func turnOfflaneAssist() {
        if engineDisabled{
            print("Engine is disabled due to too many wrong password attempts. Please contact customer support")
            return
        }

        laneAssistOn = false
        if self.currentSpeedLimit()>80{
            self.setSpeedlimiter(speed:80.0)
        }

        self.resetSpeedLimiter()


    }

    func turnOffAutomaticBreaking() {
        if engineDisabled{
            print("Engine is disabled due to too many wrong password attempts. Please contact customer support")
            return
        }
        automaticBreakingOn = false
        if self.currentSpeedLimit()>60{
            self.setSpeedlimiter(speed:60.0)
        }

        self.resetSpeedLimiter()
    }

    func turnOnlaneAssist() {
        if engineDisabled{
            print("Engine is disabled due to too many wrong password attempts. Please contact customer support")
            return
        }
        laneAssistOn = true
        if automaticBreakingOn == false{
            self.setSpeedlimiter(speed:60.0)
        }
        else{
            self.setSpeedlimiter(speed:80.0)
        }

        self.resetSpeedLimiter()


    }

    func turnOnAutomaticBreaking() {
        if engineDisabled{
            print("Engine is disabled due to too many wrong password attempts. Please contact customer support")
            return
        }
        automaticBreakingOn = true
        if laneAssistOn == false{
            self.setSpeedlimiter(speed:80.0)
        }
        else{
            self.setSpeedlimiter(speed:180.0)
        }

        self.resetSpeedLimiter()


    }


    func setSpeedlimiter(speed: Double)
    {
        speedLimiter = speed
        print("Speed is restricted to \(speedLimiter)")
    }

    func currentSpeedLimit() -> Double {
        return speedLimiter
    }

    func changePassword(){
        let curr_pass=getpass("Enter Current Password")
        if String(cString:curr_pass!) == self.pass{
            let userInput=getpass("Enter New password")
            self.pass=String(cString:userInput!)
            print("Your new password is \(self.pass)")
        }
        else{
            print("Wrong password entered")
        }
    }
}


protocol Engine{
    func start()
    func stop()
    func getEngineStatus()->Bool
}


class Honda: Engine{

    private var engineOn: Bool = false
    func start() {
        engineOn=true
        print("Engine has started")
    }
    func stop(){
        engineOn=false
        print("Engine has stopped")
    }

    func getEngineStatus()->Bool {
        return engineOn
    }
}

protocol Sensors{
    func checkRaining()->Bool
    func checkSnowing()->Bool
    func checkFoggy()->Bool

}
class Environment: Sensors{
    private var isRaining:Bool = false
    private var isSnowing:Bool = false
    private var isFoggy:Bool = false
    //private var check
    func checkRaining()->Bool {
        isRaining=Bool.random()
        return isRaining


    }

    func checkFoggy() -> Bool {
        isFoggy=Bool.random()
        return isFoggy
    }

    func checkSnowing() -> Bool {
        isSnowing=Bool.random()
        return isSnowing
    }
}
