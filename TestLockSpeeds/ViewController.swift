//
//  ViewController.swift
//  TestLockSpeeds
//
//  Created by Peter Livesey on 10/7/15.
//  Copyright © 2015 LinkedIn. All rights reserved.
//

import UIKit

/**
To use this file, edit the global variables at the top.
*/

/**
If false, we will run tests on one thread and increment and get a locked variable from another thread (the main thread).
If true, we will run tests on two different threads and run the same test. We'll print out two results (one for each thread).
*/
let TEST_RESOURCE_COMPETITION = false

/**
If true, we'll test the performance of dispatch_sync for locking variables. If false, we'll test objc_sync_enter and objc_sync_exit.
*/
let TEST_DISPATCH_SYNC = true

class ViewController: UIViewController {

    @IBAction func go() {

        let locked = Locked()

        doTenThousandReadsAndWrites(locked)

        if TEST_RESOURCE_COMPETITION {
            doTenThousandReadsAndWrites(locked)
        }
    }

    func doTenThousandReadsAndWrites(locked: Locked) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {

            let now = NSDate()

            var y = 0
            for _ in 0..<100000 {
                locked.inc()
                y = locked.getX()
            }

            let time = -now.timeIntervalSinceNow
            print("TIME: \(time) - \(y)")
        }
    }
}

class Locked: NSObject {
    private var x = 0
    private var queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL)

    func inc() {
        if TEST_DISPATCH_SYNC {
            dispatch_sync(queue) {
                x++
            }
        } else {
            objc_sync_enter(self)
            x++
            objc_sync_exit(self)
        }
    }

    func getX() -> Int {
        if TEST_DISPATCH_SYNC {
            var temp: Int = 0
            dispatch_sync(queue) {
                temp = self.x
            }
            return temp
        } else {
            objc_sync_enter(self)
            let temp = x
            objc_sync_exit(self)
            return temp
        }
    }
}
