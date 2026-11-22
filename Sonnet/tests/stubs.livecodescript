script "SonnetStubs"
-- Stand-ins for the engine contract calls the Sonnet Arcade uses (see LIB_ig3d/ENGINE_CONTRACT.md).
-- They keep objects, positions and HUD text so rules can be checked with no window.
-- Extra checks: a call on an object that is gone is counted (Stub.Bad), and HUD text with a
-- letter the vector font lacks is counted too (Stub.BadHud).
global gStubEnt, gStubHud, gStubBad, gStubBadHud, gStubSerial, gStubSparks
global gViewLeft, gViewTop, gViewRight, gViewBottom, CenterX, CenterY, gNoMouse, bPaused, bPlaying
global gStubExit

on Camera.Reset
   put 0 into gViewLeft
   put 0 into gViewTop
   put 800 into gViewRight
   put 600 into gViewBottom
   put 400 into CenterX
   put 300 into CenterY
end Camera.Reset

on Scene.ClearAll
   put empty into gStubEnt
end Scene.ClearAll

on Particles.Clear
end Particles.Clear

on Collision.ClearRules
end Collision.ClearRules

on HUD.Clear
   put empty into gStubHud
end HUD.Clear

on HUD.Set pId, pText, pX, pY, pSize
   local tBad
   put pText into gStubHud[pId]
   if pText is not empty then
      repeat for each char tC in pText
         if not (tC is among the chars of "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789:-+.!/^?,' ") then
            put tC after tBad
         end if
      end repeat
   end if
   if tBad is not empty then put pId & ":" & tBad & ";" after gStubBadHud
   if pX is not a number or pY is not a number or pSize is not a number then put "hudnum " & pId & ";" after gStubBad
end HUD.Set

on HUD.Remove pId
   delete variable gStubHud[pId]
end HUD.Remove

function Mesh.New
   return "mesh"
end Mesh.New

function Mesh.Box pW, pH, pD
   return "box"
end Mesh.Box

function Mesh.Pyramid pS, pR, pH
   return "pyramid"
end Mesh.Pyramid

function Mesh.Prism pS, pR, pH
   return "prism"
end Mesh.Prism

function Mesh.Sphere pR, pRi, pS
   return "sphere"
end Mesh.Sphere

function Mesh.Merge pA, pB
   return "mesh"
end Mesh.Merge

function Mesh.Transform pM, pRX, pRY, pRZ, pTX, pTY, pTZ, pScale
   return "mesh"
end Mesh.Transform

on Mesh.Define pName, pMesh
end Mesh.Define

function Entity.Spawn pMesh, pX, pY, pZ, pColor
   add 1 to gStubSerial
   if pX is not a number or pY is not a number or pZ is not a number then put "spawn " & pMesh & " " & pX & "," & pY & ";" after gStubBad
   put pMesh into gStubEnt[gStubSerial]["mesh"]
   put pX into gStubEnt[gStubSerial]["x"]
   put pY into gStubEnt[gStubSerial]["y"]
   put pColor into gStubEnt[gStubSerial]["color"]
   return gStubSerial
end Entity.Spawn

on Entity.Kill pId
   delete variable gStubEnt[pId]
end Entity.Kill

function Entity.Exists pId
   return (gStubEnt[pId]["mesh"] is not empty)
end Entity.Exists

on Entity.SetPosition pId, pX, pY, pZ
   if gStubEnt[pId]["mesh"] is empty then put "setpos dead " & pId & ";" after gStubBad
   if pX is not a number or pY is not a number then put "setpos nan " & pId & ";" after gStubBad
   put pX into gStubEnt[pId]["x"]
   put pY into gStubEnt[pId]["y"]
end Entity.SetPosition

function Entity.GetPosition pId, pAxis
   if pAxis is "x" then return gStubEnt[pId]["x"]
   if pAxis is "y" then return gStubEnt[pId]["y"]
   return gStubEnt[pId]["x"] & "," & gStubEnt[pId]["y"] & ",0"
end Entity.GetPosition

on Entity.SetRotation pId, pX, pY, pZ
   if gStubEnt[pId]["mesh"] is empty then put "setrot dead " & pId & ";" after gStubBad
end Entity.SetRotation

on Entity.SetColor pId, pColor
   if gStubEnt[pId]["mesh"] is empty then put "setcolor dead " & pId & ";" after gStubBad
   put pColor into gStubEnt[pId]["color"]
end Entity.SetColor

on Entity.SetMesh pId, pMesh
   if gStubEnt[pId]["mesh"] is empty then put "setmesh dead " & pId & ";" after gStubBad
   put pMesh into gStubEnt[pId]["mesh"]
end Entity.SetMesh

on FX.Sparks pX, pY, pZ, pCount, pColor
   add 1 to gStubSparks
end FX.Sparks

function Camera.WorldToScreen pX, pY, pZ
   return round(400 + pX * 400 / pZ) & "," & round(360 + pY * 400 / pZ)
end Camera.WorldToScreen

on Game.Exit
   put true into gStubExit
end Game.Exit

function Engine.Info pKey
   if pKey is "stepMS" then return 33
   return empty
end Engine.Info

-- test hooks
function Stub.Bad
   return gStubBad
end Stub.Bad

function Stub.BadHud
   return gStubBadHud
end Stub.BadHud

function Stub.Count
   return the number of lines of the keys of gStubEnt
end Stub.Count

function Stub.Hud pId
   return gStubHud[pId]
end Stub.Hud

function Stub.Sparks
   return gStubSparks + 0
end Stub.Sparks

function Stub.Color pId
   return gStubEnt[pId]["color"]
end Stub.Color

function Stub.AllHud
   local tK, tOut
   repeat for each key tK in gStubHud
      put tK & ": " & gStubHud[tK] & cr after tOut
   end repeat
   return tOut
end Stub.AllHud

-- one step with these keys held: T.Step "65361,32"
on T.Step pKeys
   dispatch "Arc.TestKeys" to card 1 of me with pKeys
   dispatch "Game.OnUpdate" to card 1 of me
end T.Step

-- call a card function or message by name: T.Call "Rain.State"
function T.Call pName, pA, pB
   if pB is not empty then
      dispatch function pName to card 1 of me with pA, pB
   else if pA is not empty then
      dispatch function pName to card 1 of me with pA
   else
      dispatch function pName to card 1 of me
   end if
   return the result
end T.Call

on T.Do pName, pA
   if pA is not empty then
      dispatch pName to card 1 of me with pA
   else
      dispatch pName to card 1 of me
   end if
end T.Do

-- press and release a key
on T.Tap pKey
   T.Step pKey
   T.Step "0"
end T.Tap

-- squad formation rules, written again here to plan with (L R U D as in the card)
function T.Apply pForm, pOp
   switch pOp
      case "L"
         return (char 2 to 3 of pForm) & char 1 of pForm
      case "R"
         return (char 3 of pForm) & char 1 to 2 of pForm
      case "U"
         return (char 2 of pForm) & (char 1 of pForm) & char 3 of pForm
      case "D"
         return (char 1 of pForm) & (char 3 of pForm) & char 2 of pForm
   end switch
   return pForm
end T.Apply

-- the shortest op string (up to 3 ops) that turns pForm into pNeed
function T.Plan pForm, pNeed
   local a, b, c, f1, f2, f3
   if pForm is pNeed then return empty
   repeat for each char a in "LRUD"
      put T.Apply(pForm, a) into f1
      if f1 is pNeed then return a
   end repeat
   repeat for each char a in "LRUD"
      put T.Apply(pForm, a) into f1
      repeat for each char b in "LRUD"
         put T.Apply(f1, b) into f2
         if f2 is pNeed then return a & b
      end repeat
   end repeat
   repeat for each char a in "LRUD"
      put T.Apply(pForm, a) into f1
      repeat for each char b in "LRUD"
         put T.Apply(f1, b) into f2
         repeat for each char c in "LRUD"
            put T.Apply(f2, c) into f3
            if f3 is pNeed then return a & b & c
         end repeat
      end repeat
   end repeat
   return "?"
end T.Plan

function T.Key pOp
   switch pOp
      case "L"
         return "65361"
      case "R"
         return "65363"
      case "U"
         return "65362"
      case "D"
         return "65364"
   end switch
   return "0"
end T.Key
