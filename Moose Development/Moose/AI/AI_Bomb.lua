--- **AI** -- **Provide Close Air Support to friendly ground troops.**
--
-- ![Banner Image](..\Presentations\AI_BOMB\Dia1.JPG)
-- 
-- ===
-- 
-- AI_BOMB classes makes AI Controllables execute bombing tasks.
-- 
-- There are the following types of BOMB classes defined:
-- 
--   * @{#AI_BOMB_ZONE}: Perform a BOMB in a zone.
--   
-- ====
-- 
-- # Demo Missions
-- 
-- ### [AI_BOMB Demo Missions source code](https://github.com/FlightControl-Master/MOOSE_MISSIONS/tree/master-release/BOMB%20-%20Close%20Air%20Support)
-- 
-- ### [AI_BOMB Demo Missions, only for beta testers](https://github.com/FlightControl-Master/MOOSE_MISSIONS/tree/master/BOMB%20-%20Close%20Air%20Support)
--
-- ### [ALL Demo Missions pack of the last release](https://github.com/FlightControl-Master/MOOSE_MISSIONS/releases)
-- 
-- ====
-- 
-- # YouTube Channel
-- 
-- ### [AI_BOMB YouTube Channel](https://www.youtube.com/playlist?list=PL7ZUrU4zZUl3JBO1WDqqpyYRRmIkR2ir2)
-- 
-- ===
--
-- # **API CHANGE HISTORY**
--
-- The underlying change log documents the API changes. Please read this carefully. The following notation is used:
--
--   * **Added** parts are expressed in bold type face.
--   * _Removed_ parts are expressed in italic type face.
--
-- Hereby the change log:
--
-- 2017-01-15: Initial class and API.
--
-- ===
--
-- # **AUTHORS and CONTRIBUTIONS**
--
-- ### Contributions:
--
--   * **[Gunterlund](http://forums.eagle.ru:8080/member.php?u=75036)**: Test case revision.
--
-- ### Authors:
--
--   * **FlightControl**: Concept, Design & Programming.
--
-- @module AI_Cas


--- AI_BOMB_ZONE class
-- @type AI_BOMB_ZONE
-- @field Wrapper.Controllable#CONTROLLABLE AIControllable The @{Controllable} patrolling.
-- @field Core.Zone#ZONE_BASE TargetZone The @{Zone} where the patrol needs to be executed.
-- @extends AI.AI_Patrol#AI_PATROL_ZONE

--- # AI_BOMB_ZONE class, extends @{AI_Patrol#AI_PATROL_ZONE}
-- 
-- AI_BOMB_ZONE derives from the @{AI_Patrol#AI_PATROL_ZONE}, inheriting its methods and behaviour.
--  
-- The AI_BOMB_ZONE class implements the core functions to provide Close Air Support in an Engage @{Zone} by an AIR @{Controllable} or @{Group}.
-- The AI_BOMB_ZONE runs a process. It holds an AI in a Patrol Zone and when the AI is commanded to engage, it will fly to an Engage Zone.
-- 
-- ![HoldAndEngage](..\Presentations\AI_BOMB\Dia3.JPG)
-- 
-- The AI_BOMB_ZONE is assigned a @{Group} and this must be done before the AI_BOMB_ZONE process can be started through the **Start** event.
--  
-- ![Start Event](..\Presentations\AI_BOMB\Dia4.JPG)
-- 
-- Upon started, The AI will **Route** itself towards the random 3D point within a patrol zone, 
-- using a random speed within the given altitude and speed limits.
-- Upon arrival at the 3D point, a new random 3D point will be selected within the patrol zone using the given limits.
-- This cycle will continue until a fuel or damage treshold has been reached by the AI, or when the AI is commanded to RTB.
-- 
-- ![Route Event](..\Presentations\AI_BOMB\Dia5.JPG)
-- 
-- When the AI is commanded to provide Close Air Support (through the event **Engage**), the AI will fly towards the Engage Zone.
-- Any target that is detected in the Engage Zone will be reported and will be destroyed by the AI.
-- 
-- ![Engage Event](..\Presentations\AI_BOMB\Dia6.JPG)
-- 
-- The AI will detect the targets and will only destroy the targets within the Engage Zone.
-- 
-- ![Engage Event](..\Presentations\AI_BOMB\Dia7.JPG)
-- 
-- Every target that is destroyed, is reported< by the AI.
-- 
-- ![Engage Event](..\Presentations\AI_BOMB\Dia8.JPG)
-- 
-- Note that the AI does not know when the Engage Zone is cleared, and therefore will keep circling in the zone. 
--
-- ![Engage Event](..\Presentations\AI_BOMB\Dia9.JPG)
-- 
-- Until it is notified through the event **Accomplish**, which is to be triggered by an observing party:
-- 
--   * a FAC
--   * a timed event
--   * a menu option selected by a human
--   * a condition
--   * others ...
-- 
-- ![Engage Event](..\Presentations\AI_BOMB\Dia10.JPG)
-- 
-- When the AI has accomplished the BOMB, it will fly back to the Patrol Zone.
-- 
-- ![Engage Event](..\Presentations\AI_BOMB\Dia11.JPG)
-- 
-- It will keep patrolling there, until it is notified to RTB or move to another BOMB Zone.
-- It can be notified to go RTB through the **RTB** event.
-- 
-- When the fuel treshold has been reached, the airplane will fly towards the nearest friendly airbase and will land.
-- 
-- ![Engage Event](..\Presentations\AI_BOMB\Dia12.JPG)
--
-- # 1. AI_BOMB_ZONE constructor
--
--   * @{#AI_BOMB_ZONE.New}(): Creates a new AI_BOMB_ZONE object.
--
-- ## 2. AI_BOMB_ZONE is a FSM
-- 
-- ![Process](..\Presentations\AI_BOMB\Dia2.JPG)
-- 
-- ### 2.1. AI_BOMB_ZONE States
-- 
--   * **None** ( Group ): The process is not started yet.
--   * **Patrolling** ( Group ): The AI is patrolling the Patrol Zone.
--   * **Engaging** ( Group ): The AI is engaging the targets in the Engage Zone, executing BOMB.
--   * **Returning** ( Group ): The AI is returning to Base..
-- 
-- ### 2.2. AI_BOMB_ZONE Events
-- 
--   * **@{AI_Patrol#AI_PATROL_ZONE.Start}**: Start the process.
--   * **@{AI_Patrol#AI_PATROL_ZONE.Route}**: Route the AI to a new random 3D point within the Patrol Zone.
--   * **@{#AI_BOMB_ZONE.Engage}**: Engage the AI to provide BOMB in the Engage Zone, destroying any target it finds.
--   * **@{#AI_BOMB_ZONE.Abort}**: Aborts the engagement and return patrolling in the patrol zone.
--   * **@{AI_Patrol#AI_PATROL_ZONE.RTB}**: Route the AI to the home base.
--   * **@{AI_Patrol#AI_PATROL_ZONE.Detect}**: The AI is detecting targets.
--   * **@{AI_Patrol#AI_PATROL_ZONE.Detected}**: The AI has detected new targets.
--   * **@{#AI_BOMB_ZONE.Destroy}**: The AI has destroyed a target @{Unit}.
--   * **@{#AI_BOMB_ZONE.Destroyed}**: The AI has destroyed all target @{Unit}s assigned in the BOMB task.
--   * **Status**: The AI is checking status (fuel and damage). When the tresholds have been reached, the AI will RTB.
-- 
-- ===
-- 
-- @field #AI_BOMB_ZONE
AI_BOMB_ZONE = {
  ClassName = "AI_BOMB_ZONE",
}



--- Creates a new AI_BOMB_ZONE object
-- @param #AI_BOMB_ZONE self
-- @param Core.Zone#ZONE_BASE PatrolZone The @{Zone} where the patrol needs to be executed.
-- @param Dcs.DCSTypes#Altitude PatrolFloorAltitude The lowest altitude in meters where to execute the patrol.
-- @param Dcs.DCSTypes#Altitude PatrolCeilingAltitude The highest altitude in meters where to execute the patrol.
-- @param Dcs.DCSTypes#Speed  PatrolMinSpeed The minimum speed of the @{Controllable} in km/h.
-- @param Dcs.DCSTypes#Speed  PatrolMaxSpeed The maximum speed of the @{Controllable} in km/h.
-- @param Core.Zone#ZONE_BASE EngageZone The zone where the engage will happen.
-- @param Dcs.DCSTypes#AltitudeType PatrolAltType The altitude type ("RADIO"=="AGL", "BARO"=="ASL"). Defaults to RADIO
-- @return #AI_BOMB_ZONE self
function AI_BOMB_ZONE:New( PatrolZone, PatrolFloorAltitude, PatrolCeilingAltitude, PatrolMinSpeed, PatrolMaxSpeed, EngageZone, PatrolAltType )

  -- Inherits from BASE
  local self = BASE:Inherit( self, AI_PATROL_ZONE:New( PatrolZone, PatrolFloorAltitude, PatrolCeilingAltitude, PatrolMinSpeed, PatrolMaxSpeed, PatrolAltType ) ) -- #AI_BOMB_ZONE

  self.EngageZone = EngageZone
  self.Accomplished = false
  
  self:SetDetectionZone( self.EngageZone )

  self:AddTransition( { "Patrolling", "Engaging" }, "Engage", "Engaging" ) -- FSM_CONTROLLABLE Transition for type #AI_BOMB_ZONE.

  --- OnBefore Transition Handler for Event Engage.
  -- @function [parent=#AI_BOMB_ZONE] OnBeforeEngage
  -- @param #AI_BOMB_ZONE self
  -- @param Wrapper.Controllable#CONTROLLABLE Controllable The Controllable Object managed by the FSM.
  -- @param #string From The From State string.
  -- @param #string Event The Event string.
  -- @param #string To The To State string.
  
  -- @return #boolean Return false to cancel Transition.
  
  --- OnAfter Transition Handler for Event Engage.
  -- @function [parent=#AI_BOMB_ZONE] OnAfterEngage
  -- @param #AI_BOMB_ZONE self
  -- @param Wrapper.Controllable#CONTROLLABLE Controllable The Controllable Object managed by the FSM.
  -- @param #string From The From State string.
  -- @param #string Event The Event string.
  -- @param #string To The To State string.
  	
  --- Synchronous Event Trigger for Event Engage.
  -- @function [parent=#AI_BOMB_ZONE] Engage
  -- @param #AI_BOMB_ZONE self
  -- @param #number EngageSpeed (optional) The speed the Group will hold when engaging to the target zone.
  -- @param Dcs.DCSTypes#Distance EngageAltitude (optional) Desired altitude to perform the unit engagement.
  -- @param Dcs.DCSTypes#AI.Task.WeaponExpend EngageWeaponExpend (optional) Determines how much weapon will be released at each attack. 
  -- If parameter is not defined the unit / controllable will choose expend on its own discretion.
  -- Use the structure @{DCSTypes#AI.Task.WeaponExpend} to define the amount of weapons to be release at each attack.
  -- @param #number EngageAttackQty (optional) This parameter limits maximal quantity of attack. The aicraft/controllable will not make more attack than allowed even if the target controllable not destroyed and the aicraft/controllable still have ammo. If not defined the aircraft/controllable will attack target until it will be destroyed or until the aircraft/controllable will run out of ammo.
  -- @param Dcs.DCSTypes#Azimuth EngageDirection (optional) Desired ingress direction from the target to the attacking aircraft. Controllable/aircraft will make its attacks from the direction. Of course if there is no way to attack from the direction due the terrain controllable/aircraft will choose another direction.
  
  --- Asynchronous Event Trigger for Event Engage.
  -- @function [parent=#AI_BOMB_ZONE] __Engage
  -- @param #AI_BOMB_ZONE self
  -- @param #number Delay The delay in seconds.
  -- @param #number EngageSpeed (optional) The speed the Group will hold when engaging to the target zone.
  -- @param Dcs.DCSTypes#Distance EngageAltitude (optional) Desired altitude to perform the unit engagement.
  -- @param Dcs.DCSTypes#AI.Task.WeaponExpend EngageWeaponExpend (optional) Determines how much weapon will be released at each attack. 
  -- If parameter is not defined the unit / controllable will choose expend on its own discretion.
  -- Use the structure @{DCSTypes#AI.Task.WeaponExpend} to define the amount of weapons to be release at each attack.
  -- @param #number EngageAttackQty (optional) This parameter limits maximal quantity of attack. The aicraft/controllable will not make more attack than allowed even if the target controllable not destroyed and the aicraft/controllable still have ammo. If not defined the aircraft/controllable will attack target until it will be destroyed or until the aircraft/controllable will run out of ammo.
  -- @param Dcs.DCSTypes#Azimuth EngageDirection (optional) Desired ingress direction from the target to the attacking aircraft. Controllable/aircraft will make its attacks from the direction. Of course if there is no way to attack from the direction due the terrain controllable/aircraft will choose another direction.

--- OnLeave Transition Handler for State Engaging.
-- @function [parent=#AI_BOMB_ZONE] OnLeaveEngaging
-- @param #AI_BOMB_ZONE self
-- @param Wrapper.Controllable#CONTROLLABLE Controllable The Controllable Object managed by the FSM.
-- @param #string From The From State string.
-- @param #string Event The Event string.
-- @param #string To The To State string.
-- @return #boolean Return false to cancel Transition.

--- OnEnter Transition Handler for State Engaging.
-- @function [parent=#AI_BOMB_ZONE] OnEnterEngaging
-- @param #AI_BOMB_ZONE self
-- @param Wrapper.Controllable#CONTROLLABLE Controllable The Controllable Object managed by the FSM.
-- @param #string From The From State string.
-- @param #string Event The Event string.
-- @param #string To The To State string.

  self:AddTransition( "Engaging", "Target", "Engaging" ) -- FSM_CONTROLLABLE Transition for type #AI_BOMB_ZONE.

  self:AddTransition( "Engaging", "Fired", "Engaging" ) -- FSM_CONTROLLABLE Transition for type #AI_BOMB_ZONE.
  
  --- OnBefore Transition Handler for Event Fired.
  -- @function [parent=#AI_BOMB_ZONE] OnBeforeFired
  -- @param #AI_BOMB_ZONE self
  -- @param Wrapper.Controllable#CONTROLLABLE Controllable The Controllable Object managed by the FSM.
  -- @param #string From The From State string.
  -- @param #string Event The Event string.
  -- @param #string To The To State string.
  -- @return #boolean Return false to cancel Transition.
  
  --- OnAfter Transition Handler for Event Fired.
  -- @function [parent=#AI_BOMB_ZONE] OnAfterFired
  -- @param #AI_BOMB_ZONE self
  -- @param Wrapper.Controllable#CONTROLLABLE Controllable The Controllable Object managed by the FSM.
  -- @param #string From The From State string.
  -- @param #string Event The Event string.
  -- @param #string To The To State string.
  	
  --- Synchronous Event Trigger for Event Fired.
  -- @function [parent=#AI_BOMB_ZONE] Fired
  -- @param #AI_BOMB_ZONE self
  
  --- Asynchronous Event Trigger for Event Fired.
  -- @function [parent=#AI_BOMB_ZONE] __Fired
  -- @param #AI_BOMB_ZONE self
  -- @param #number Delay The delay in seconds.

  self:AddTransition( "*", "Destroy", "*" ) -- FSM_CONTROLLABLE Transition for type #AI_BOMB_ZONE.

  --- OnBefore Transition Handler for Event Destroy.
  -- @function [parent=#AI_BOMB_ZONE] OnBeforeDestroy
  -- @param #AI_BOMB_ZONE self
  -- @param Wrapper.Controllable#CONTROLLABLE Controllable The Controllable Object managed by the FSM.
  -- @param #string From The From State string.
  -- @param #string Event The Event string.
  -- @param #string To The To State string.
  -- @return #boolean Return false to cancel Transition.
  
  --- OnAfter Transition Handler for Event Destroy.
  -- @function [parent=#AI_BOMB_ZONE] OnAfterDestroy
  -- @param #AI_BOMB_ZONE self
  -- @param Wrapper.Controllable#CONTROLLABLE Controllable The Controllable Object managed by the FSM.
  -- @param #string From The From State string.
  -- @param #string Event The Event string.
  -- @param #string To The To State string.
  	
  --- Synchronous Event Trigger for Event Destroy.
  -- @function [parent=#AI_BOMB_ZONE] Destroy
  -- @param #AI_BOMB_ZONE self
  
  --- Asynchronous Event Trigger for Event Destroy.
  -- @function [parent=#AI_BOMB_ZONE] __Destroy
  -- @param #AI_BOMB_ZONE self
  -- @param #number Delay The delay in seconds.


  self:AddTransition( "Engaging", "Abort", "Patrolling" ) -- FSM_CONTROLLABLE Transition for type #AI_BOMB_ZONE.

  --- OnBefore Transition Handler for Event Abort.
  -- @function [parent=#AI_BOMB_ZONE] OnBeforeAbort
  -- @param #AI_BOMB_ZONE self
  -- @param Wrapper.Controllable#CONTROLLABLE Controllable The Controllable Object managed by the FSM.
  -- @param #string From The From State string.
  -- @param #string Event The Event string.
  -- @param #string To The To State string.
  -- @return #boolean Return false to cancel Transition.
  
  --- OnAfter Transition Handler for Event Abort.
  -- @function [parent=#AI_BOMB_ZONE] OnAfterAbort
  -- @param #AI_BOMB_ZONE self
  -- @param Wrapper.Controllable#CONTROLLABLE Controllable The Controllable Object managed by the FSM.
  -- @param #string From The From State string.
  -- @param #string Event The Event string.
  -- @param #string To The To State string.
  	
  --- Synchronous Event Trigger for Event Abort.
  -- @function [parent=#AI_BOMB_ZONE] Abort
  -- @param #AI_BOMB_ZONE self
  
  --- Asynchronous Event Trigger for Event Abort.
  -- @function [parent=#AI_BOMB_ZONE] __Abort
  -- @param #AI_BOMB_ZONE self
  -- @param #number Delay The delay in seconds.

  self:AddTransition( "Engaging", "Accomplish", "Patrolling" ) -- FSM_CONTROLLABLE Transition for type #AI_BOMB_ZONE.

  --- OnBefore Transition Handler for Event Accomplish.
  -- @function [parent=#AI_BOMB_ZONE] OnBeforeAccomplish
  -- @param #AI_BOMB_ZONE self
  -- @param Wrapper.Controllable#CONTROLLABLE Controllable The Controllable Object managed by the FSM.
  -- @param #string From The From State string.
  -- @param #string Event The Event string.
  -- @param #string To The To State string.
  -- @return #boolean Return false to cancel Transition.
  
  --- OnAfter Transition Handler for Event Accomplish.
  -- @function [parent=#AI_BOMB_ZONE] OnAfterAccomplish
  -- @param #AI_BOMB_ZONE self
  -- @param Wrapper.Controllable#CONTROLLABLE Controllable The Controllable Object managed by the FSM.
  -- @param #string From The From State string.
  -- @param #string Event The Event string.
  -- @param #string To The To State string.
  	
  --- Synchronous Event Trigger for Event Accomplish.
  -- @function [parent=#AI_BOMB_ZONE] Accomplish
  -- @param #AI_BOMB_ZONE self
  
  --- Asynchronous Event Trigger for Event Accomplish.
  -- @function [parent=#AI_BOMB_ZONE] __Accomplish
  -- @param #AI_BOMB_ZONE self
  -- @param #number Delay The delay in seconds.  

  return self
end


--- Set the Engage Zone where the AI is performing BOMB. Note that if the EngageZone is changed, the AI needs to re-detect targets.
-- @param #AI_BOMB_ZONE self
-- @param Core.Zone#ZONE EngageZone The zone where the AI is performing BOMB.
-- @return #AI_BOMB_ZONE self
function AI_BOMB_ZONE:SetEngageZone( EngageZone )
  self:F2()

  if EngageZone then  
    self.EngageZone = EngageZone
  else
    self.EngageZone = nil
  end
end



--- onafter State Transition for Event Start.
-- @param #AI_BOMB_ZONE self
-- @param Wrapper.Controllable#CONTROLLABLE Controllable The Controllable Object managed by the FSM.
-- @param #string From The From State string.
-- @param #string Event The Event string.
-- @param #string To The To State string.
function AI_BOMB_ZONE:onafterStart( Controllable, From, Event, To )

  -- Call the parent Start event handler
  self:GetParent(self).onafterStart( self, Controllable, From, Event, To )
  self:HandleEvent( EVENTS.Dead )
  
  self:SetDetectionDeactivated() -- When not engaging, set the detection off.
end

--- @param Wrapper.Controllable#CONTROLLABLE AIControllable
function _NewEngageRoute( AIControllable )

  AIControllable:T( "NewEngageRoute" )
  local EngageZone = AIControllable:GetState( AIControllable, "EngageZone" ) -- AI.AI_Cas#AI_BOMB_ZONE
  EngageZone:__Engage( 1, EngageZone.EngageSpeed, EngageZone.EngageAltitude, EngageZone.EngageWeaponExpend, EngageZone.EngageAttackQty, EngageZone.EngageDirection )
end


--- @param #AI_BOMB_ZONE self
-- @param Wrapper.Controllable#CONTROLLABLE Controllable The Controllable Object managed by the FSM.
-- @param #string From The From State string.
-- @param #string Event The Event string.
-- @param #string To The To State string.
function AI_BOMB_ZONE:onbeforeEngage( Controllable, From, Event, To )
  
  if self.Accomplished == true then
    return false
  end
end

--- @param #AI_BOMB_ZONE self
-- @param Wrapper.Controllable#CONTROLLABLE Controllable The Controllable Object managed by the FSM.
-- @param #string From The From State string.
-- @param #string Event The Event string.
-- @param #string To The To State string.
function AI_BOMB_ZONE:onafterTarget( Controllable, From, Event, To )
  self:E("onafterTarget")

  if Controllable:IsAlive() then

    local AttackTasks = {}

    for DetectedUnit, Detected in pairs( self.DetectedUnits ) do
      local DetectedUnit = DetectedUnit -- Wrapper.Unit#UNIT
      if DetectedUnit:IsAlive() then
        if DetectedUnit:IsInZone( self.EngageZone ) then
          if Detected == true then
            self:E( {"Target: ", DetectedUnit } )
            self.DetectedUnits[DetectedUnit] = false
            local AttackTask = Controllable:TaskAttackUnit( DetectedUnit, false, self.EngageWeaponExpend, self.EngageAttackQty, self.EngageDirection, self.EngageAltitude, nil )
            self.Controllable:PushTask( AttackTask, 1 )
          end
        end
      else
        self.DetectedUnits[DetectedUnit] = nil
      end
    end

    self:__Target( -10 )

  end
end


--- @param #AI_BOMB_ZONE self
-- @param Wrapper.Controllable#CONTROLLABLE Controllable The Controllable Object managed by the FSM.
-- @param #string From The From State string.
-- @param #string Event The Event string.
-- @param #string To The To State string.
function AI_BOMB_ZONE:onafterAbort( Controllable, From, Event, To )
  Controllable:ClearTasks()
  self:__Route( 1 )
end

--- @param #AI_BOMB_ZONE self
-- @param Wrapper.Controllable#CONTROLLABLE Controllable The Controllable Object managed by the FSM.
-- @param #string From The From State string.
-- @param #string Event The Event string.
-- @param #string To The To State string.
-- @param #number EngageSpeed (optional) The speed the Group will hold when engaging to the target zone.
-- @param Dcs.DCSTypes#Distance EngageAltitude (optional) Desired altitude to perform the unit engagement.
-- @param Dcs.DCSTypes#AI.Task.WeaponExpend EngageWeaponExpend (optional) Determines how much weapon will be released at each attack. If parameter is not defined the unit / controllable will choose expend on its own discretion.
-- @param #number EngageAttackQty (optional) This parameter limits maximal quantity of attack. The aicraft/controllable will not make more attack than allowed even if the target controllable not destroyed and the aicraft/controllable still have ammo. If not defined the aircraft/controllable will attack target until it will be destroyed or until the aircraft/controllable will run out of ammo.
-- @param Dcs.DCSTypes#Azimuth EngageDirection (optional) Desired ingress direction from the target to the attacking aircraft. Controllable/aircraft will make its attacks from the direction. Of course if there is no way to attack from the direction due the terrain controllable/aircraft will choose another direction.
function AI_BOMB_ZONE:onafterEngage( Controllable, From, Event, To, 
                                    EngageSpeed, 
                                    EngageAltitude, 
                                    EngageWeaponExpend, 
                                    EngageAttackQty, 
                                    EngageDirection )
  self:F("onafterEngage")

  self.EngageSpeed = EngageSpeed or 400
  self.EngageAltitude = EngageAltitude or 2000
  self.EngageWeaponExpend = EngageWeaponExpend
  self.EngageAttackQty = EngageAttackQty
  self.EngageDirection = EngageDirection

  if Controllable:IsAlive() then

    local EngageRoute = {}

    --- Calculate the current route point.
    local CurrentVec2 = self.Controllable:GetVec2()
    
    --TODO: Create GetAltitude function for GROUP, and delete GetUnit(1).
    local CurrentAltitude = self.Controllable:GetUnit(1):GetAltitude()
    local CurrentPointVec3 = POINT_VEC3:New( CurrentVec2.x, CurrentAltitude, CurrentVec2.y )
    local ToEngageZoneSpeed = self.PatrolMaxSpeed
    local CurrentRoutePoint = CurrentPointVec3:RoutePointAir( 
        self.PatrolAltType, 
        POINT_VEC3.RoutePointType.TurningPoint, 
        POINT_VEC3.RoutePointAction.TurningPoint, 
        self.EngageSpeed, 
        true 
      )
    
    EngageRoute[#EngageRoute+1] = CurrentRoutePoint

    local AttackTasks = {}

    for DetectedUnitID, DetectedUnit in pairs( self.DetectedUnits ) do
      local DetectedUnit = DetectedUnit -- Wrapper.Unit#UNIT
      self:T( DetectedUnit )
      if DetectedUnit:IsAlive() then
        if DetectedUnit:IsInZone( self.EngageZone ) then
          self:E( {"Engaging ", DetectedUnit } )
          AttackTasks[#AttackTasks+1] = Controllable:TaskAttackUnit( DetectedUnit, 
                                                                     true, 
                                                                     EngageWeaponExpend, 
                                                                     EngageAttackQty, 
                                                                     EngageDirection 
                                                                   )
        end
      else
        self.DetectedUnits[DetectedUnit] = nil
      end
    end

    EngageRoute[1].task = Controllable:TaskCombo( AttackTasks )

    --- Define a random point in the @{Zone}. The AI will fly to that point within the zone.
    
      --- Find a random 2D point in EngageZone.
    local ToTargetVec2 = self.EngageZone:GetRandomVec2()
    self:T2( ToTargetVec2 )

    --- Obtain a 3D @{Point} from the 2D point + altitude.
    local ToTargetPointVec3 = POINT_VEC3:New( ToTargetVec2.x, self.EngageAltitude, ToTargetVec2.y )
    
    --- Create a route point of type air.
    local ToTargetRoutePoint = ToTargetPointVec3:RoutePointAir( 
      self.PatrolAltType, 
      POINT_VEC3.RoutePointType.TurningPoint, 
      POINT_VEC3.RoutePointAction.TurningPoint, 
      self.EngageSpeed, 
      true 
    )
    
    EngageRoute[#EngageRoute+1] = ToTargetRoutePoint

    --- Now we're going to do something special, we're going to call a function from a waypoint action at the AIControllable...
    Controllable:WayPointInitialize( EngageRoute )
    
    --- Do a trick, link the NewEngageRoute function of the object to the AIControllable in a temporary variable ...
    Controllable:SetState( Controllable, "EngageZone", self )

    Controllable:WayPointFunction( #EngageRoute, 1, "_NewEngageRoute" )

    --- NOW ROUTE THE GROUP!
    Controllable:WayPointExecute( 1 )

    Controllable:OptionROEOpenFire()
    Controllable:OptionROTVertical()
    
    self:SetDetectionInterval( 2 )
    self:SetDetectionActivated()
    self:__Target( -2 ) -- Start Targetting
  end
end


--- @param #AI_BOMB_ZONE self
-- @param Wrapper.Controllable#CONTROLLABLE Controllable The Controllable Object managed by the FSM.
-- @param #string From The From State string.
-- @param #string Event The Event string.
-- @param #string To The To State string.
function AI_BOMB_ZONE:onafterAccomplish( Controllable, From, Event, To )
  self.Accomplished = true
  self:SetDetectionDeactivated()
end


--- @param #AI_BOMB_ZONE self
-- @param Wrapper.Controllable#CONTROLLABLE Controllable The Controllable Object managed by the FSM.
-- @param #string From The From State string.
-- @param #string Event The Event string.
-- @param #string To The To State string.
-- @param Core.Event#EVENTDATA EventData
function AI_BOMB_ZONE:onafterDestroy( Controllable, From, Event, To, EventData )

  if EventData.IniUnit then
    self.DetectedUnits[EventData.IniUnit] = nil
  end
end


--- @param #AI_BOMB_ZONE self
-- @param Core.Event#EVENTDATA EventData
function AI_BOMB_ZONE:OnEventDead( EventData )
  self:F( { "EventDead", EventData } )

  if EventData.IniDCSUnit then
    if self.DetectedUnits and self.DetectedUnits[EventData.IniUnit] then
      self:__Destroy( 1, EventData )
    end
  end
end


