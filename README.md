# TestSwiftLockSpeeds

This project tests the performance of dispatch_sync and objc_sync for making ivars in swift thread safe. It's a pretty crude test, but successfully demonstrates that objc_sync is faster in most cases.

Here are some sample results taken from an iPhone 5s (times in seconds, see the code for the test we're running):

| | No Resource Competition | Resource Competition |
| ------------ | ----------- | ---------- |
| dispatch_sync | 0.3596130967 | 4.711853796 |
| objc_sync | 0.1057428122 | 0.2762099981 |
| speed increase | 340.08% | 1705.90% |

