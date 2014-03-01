module HWifiTests where

import Network.HWifi (command, cleanString, sliceSSIDSignal, sliceSSIDSignals, filterKnownWifi, commandScanWifi, commandListWifiAutoConnect, commandConnectToWifi, electWifi)
import Test.HUnit

testCommandScanWifi :: Test.HUnit.Test
testCommandScanWifi = Just "nmcli --terse --fields ssid,signal dev wifi"
                      ~=?
                      commandScanWifi

testCommandListWifiAutoConnect :: Test.HUnit.Test
testCommandListWifiAutoConnect = Just "nmcli --terse --fields name con list"
                                 ~=?
                                 commandListWifiAutoConnect

testCommand1 :: Test.HUnit.Test
testCommand1 = ["nmcli","con","list"] ~=? command "nmcli con list"

testCommand2 :: Test.HUnit.Test
testCommand2 = ["nmcli", "-t", "-f", "name", "con","list"] ~=? command "nmcli -t -f name con list"

testCommands :: Test.HUnit.Test
testCommands = TestList ["testCommand1" ~: testCommand1, "testCommand2" ~: testCommand2]

testCleanString1 :: Test.HUnit.Test
testCleanString1 = "hello" ~=? cleanString "'hello'"

testCleanString2 :: Test.HUnit.Test
testCleanString2 = "hell" ~=? cleanString "'hello"

testCleanString3 :: Test.HUnit.Test
testCleanString3 = "hello" ~=? cleanString "hello"

testCleanString4 :: Test.HUnit.Test
testCleanString4 = "ello" ~=? cleanString "hello'"

testCleanStrings :: Test.HUnit.Test
testCleanStrings = TestList ["testCleanString1" ~: testCleanString1
                             ,"testCleanString2" ~: testCleanString2
                             ,"testCleanString3" ~: testCleanString3
                             ,"testCleanString4" ~: testCleanString4]

testSliceSSIDSignal1 :: Test.HUnit.Test
testSliceSSIDSignal1 = ("ssid","signal") ~=? sliceSSIDSignal "ssid:signal"

testSliceSSIDSignal2 :: Test.HUnit.Test
testSliceSSIDSignal2 = ("ssid", "signal") ~=? sliceSSIDSignal "'ssid':signal"

testSliceSSIDSignals :: Test.HUnit.Test
testSliceSSIDSignals = TestList ["testSliceSSIDSignal1" ~: testSliceSSIDSignal1
                                ,"testSliceSSIDSignal2" ~: testSliceSSIDSignal2]

testSliceSSIDSignals1 :: Test.HUnit.Test
testSliceSSIDSignals1 = [("Livebox-0ff6","42"),("tatooine","71")]
                       ~=?
                       sliceSSIDSignals ["'Livebox-0ff6':42","'tatooine':71"]

testSliceSSIDSignalss :: Test.HUnit.Test
testSliceSSIDSignalss = TestList ["testSliceSSIDSignals1" ~: testSliceSSIDSignals1]

testWifiToConnect1 :: Test.HUnit.Test
testWifiToConnect1 = [("tatooine", "67")]
                     ~=?
                     filterKnownWifi ["AndroidAP-tony","myrkr","tatooine"] [("Livebox-0ff6","42"),("tatooine","67")]

testWifiToConnect2 :: Test.HUnit.Test
testWifiToConnect2 = [("tatooine", "67"), ("dantooine", "72")]
                     ~=?
                     filterKnownWifi ["myrkr","dantooine","tatooine"] [("Livebox-0ff6","42"),("tatooine","67"),("dantooine", "72")]

testWifiToConnects :: Test.HUnit.Test
testWifiToConnects = TestList ["testWifiToConnect1" ~: testWifiToConnect1
                               ,"testWifiToConnect2" ~: testWifiToConnect2]

testConnectToWifiCommand1 :: Test.HUnit.Test
testConnectToWifiCommand1 = (Just "nmcli con up id tatooine")
                            ~=?
                            commandConnectToWifi (Just "tatooine")

testConnectToWifiCommand2 :: Test.HUnit.Test
testConnectToWifiCommand2 = Nothing
                            ~=?
                            commandConnectToWifi Nothing

testConnectToWifiCommands :: Test.HUnit.Test
testConnectToWifiCommands = TestList ["testConnectToWifiCommand1" ~: testConnectToWifiCommand1
                                     ,"testConnectToWifiCommand2" ~: testConnectToWifiCommand2]


testElectWifi1 :: Test.HUnit.Test
testElectWifi1 = Just "some-wifi-alone"
                 ~=?
                 electWifi [("some-wifi-alone", "100")]

testElectWifi2 :: Test.HUnit.Test
testElectWifi2 = Just "high-signal"
                 ~=?
                 electWifi [("high-signal", "100"), ("low-signal", "40")]

testElectWifi3 :: Test.HUnit.Test
testElectWifi3 = Just "high-signal"
                 ~=?
                 electWifi [("medium-signal", "60"), ("high-signal", "100"), ("low-signal", "20"), ("useless-signal", "40")]

testElectWifi4 :: Test.HUnit.Test
testElectWifi4 = Nothing
                 ~=?
                 electWifi []

testElectWifis :: Test.HUnit.Test
testElectWifis = TestList ["testElectWifi1" ~: testElectWifi1
                          ,"testElectWifi2" ~: testElectWifi2
                          ,"testElectWifi3" ~: testElectWifi3
                          ,"testElectWifi4" ~: testElectWifi4]

-- Full tests
tests :: Test.HUnit.Test
tests = TestList [testCommandScanWifi
                  ,testCommandListWifiAutoConnect
                  ,testCommands
                  ,testCleanStrings
                  ,testSliceSSIDSignals
                  ,testSliceSSIDSignalss
                  ,testWifiToConnects
                  ,testConnectToWifiCommands
                  ,testElectWifis]

main :: IO ()
main = runTestTT tests >>= print
