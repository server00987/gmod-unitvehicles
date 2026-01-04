UV = UV or {}
UV.FAQ = UV.FAQ or {}

function UVGetFAQText(key)
	local cvar = GetConVar("gmod_language")
	local lang = cvar and string.lower(cvar:GetString()) or "en"

	-- Try exact match (sv-se)
	if UV.FAQ[lang] and UV.FAQ[lang][key] then
		return UV.FAQ[lang][key]
	end

	-- Try base language fallback (sv)
	local base = string.match(lang, "^(%a+)")
	if base and UV.FAQ[base] and UV.FAQ[base][key] then
		return UV.FAQ[base][key]
	end
	
	-- English fallback
	if UV.FAQ.en and UV.FAQ.en[key] then
		return UV.FAQ.en[key]
	end

	return "Missing FAQ text: " .. key
end

-- English
UV.FAQ["en"] = {
-- Introduction
["Intro"] = [[
# -- What is this addon?

Unit Vehicles is a Sandbox-oriented addon that allows players, in both Multiplayer with others or Singleplayer with AI, to engage in high-speed pursuits as or against police (Units) and thrilling races on any map.

**Here are the currently supported vehicle bases:**
 |-- prop_vehicle_jeep (default vehicle base)
 |-- simfphys
 |-- Glide (required and highly recommended)
]],
["Requirements"] = [[
# -- Do I have to install other addon(s) for this?

Yes. *Decent Vehicle - Basic AI* and *Glide // Styled's Vehicle Base* is REQUIRED for Unit Vehicles to function properly.
 |-- Decent Vehicle provides waypoints for AIs to spawn and roam around in.
 |-- Glide provides the vehicles needed to use with the Default preset.
]],
["Github"] = [[
# -- Does this addon have a GitHub repository?

Yes. It is currently private at the moment until official release.
]],
["Roadmap"] = [[
# -- How can I keep up to date with the latest updates? Is there a road map?

You can follow us on our Trello page, or our Discord server, both of which you can find on our Workshop page.
]],
["ConVars"] = [[
# -- What console commands are there I can use?

 |-- uv_spawnvehicles - Spawns patrolling AI Units
 |-- uv_setheat [x] - Sets the Heat Level
 |-- uv_despawnvehicles - Despawns Patrolling AI Units
 |-- uv_resetallsettings - Resets all server settings to their default values
 |-- uv_startpursuit - Starts a countdown before beginning a pursuit
 |-- uv_stoppursuit - Stops a pursuit with AI Units assuming you've escaped
 |-- uv_wantedtable - Prints a list of wanted suspects to the console
 |-- uv_clearbounty - Sets the bounty value to 0
 |-- uv_setbounty [x] - Sets the bounty value
 |-- uv_spawn_as_unit - Allows you to join as the Unit
]],

-- Racing
["Racing.Joining"] = [[
# -- How do I join races?

If someone has prepared a race, and they send an invite, you'll receive an on-screen notification inviting you to it, assuming that you are in a vehicle and no pursuit is ongoing.
]],

["Racing.Resetting"] = [[
# -- I'm stuck! How do I reset?

 |-- Press [key:unitvehicle_keybind_resetposition] to reset your car
 |-- Wait 3 seconds
 |-- You're back at the last checkpoint you passed!
 
**Notes**
 |-- You cannot reset when being busted
 |-- You cannot reset while already moving
]],

["Racing.Starting"] = [[
# -- How do I start racing?

Begin a race by going to [string:uv.rm] in the UV Menu:
 |-- Click [string:uv.rm.loadrace]
 |-- Select any race from the list
 |-- Invite other racers, or hit [string:uv.rm.startrace]
 |-- You can immediately start the race, or automatically spawn AI to join your race


*Notes*
 |-- There must be at least 1 Grid Slot to start the race!
 |-- You can invite friends/AI Racers by clicking [string:uv.rm.sendinvite] before clicking [string:uv.rm.startrace] as long as a race is loaded
 |-- If there are no existing races, you'll have to make your own
 |-- Alternatively, find some on the Workshop!
]],

["Racing.Create"] = [[
# -- How do I create races?
Use the [string:tool.uvracemanager.name] tool:


*-- Step 1: Create Checkpoints*
 |-- Press [+attack] in one corner to start placing a checkpoint
 |-- Press [+attack] in another to finish placing it
 |-- Tip: Hold [+use] to increase checkpoint height automatically
 

*-- Step 2: Set the Checkpoints in order*
 |-- Press [+attack2] on the checkpoint.
 |-- Type in the Checkpoint ID
 |-- Make sure the ID is in sequentual order
 |-- Branching checkpoints use a matching ID
 |-- AI will always use the last placed checkpoint ID
 

*-- Step 3: Create Grid Slots*
 |-- Press [+reload] to place Grid Slots
 |-- The numbers on the slots represent starting order
 |-- Want more racers? Place more slots!
 

*-- Step 4: Export Race*
 |-- Done with the race? Open the Spawnmenu and hit [string:tool.uvracemanager.settings.saverace]
 |-- Give it a name
 |-- It will now appear as a race you can import and race on!
]],
["Racing.Create.Speedlimit"] = [[
# -- The AI Racers are going too fast around the track!

When placing checkpoints, you'll have to define the speed in which the AI will take it.
If the AI is going too fast, you'll have to alter the speedlimit value found in the [string:tool.uvracemanager.name] settings.
If you have a race already loaded, you can press [+attack2] on the Checkpoint to edit it and apply the updated speedlimit.
Alternatively, you can edit the last number in the race data file.
]],

-- Pursuits
["Pursuit.Starting"] = [[
# -- How do I start a pursuit?

 |-- Go to [string:uv.pm]
 |-- Click [string:uv.pm.pursuit.start]
 |-- Alternatively, drive into or drive recklessly near a Unit
 |-- Away you go!
]],

["Pursuit.JoinAsUnit"] = [[
# -- Can I join the Pursuit as a Unit?

Yes you can! And it's simple:
 |-- Go to [string:uv.pm] or [string:uv.menu.welcome]
 |-- Click [string:uv.pm.spawnas]
 |-- Pick the vehicle you want to drive
 |-- Away you go!
]],
["Pursuit.Respawn"] = [[
# -- I'm stuck or too far from the suspect(s)! How do I reset?

 |-- Press [key:unitvehicle_keybind_resetposition] to open the [string:tool.uvunitmanager.settings.voiceunit.select] menu
 |-- Pick the vehicle you want to reset as
 |-- Away you go!
 
**Notes**
 |-- If you reset once, you'll have to wait a moment before doing so again
]],
["Pursuit.CreateUnits"] = [[
# -- I want to create Units. What do I do?

Here's what you do:
 |-- 1. Pull out the [string:tool.uvunitmanager.name] tool
 |-- 2. Spawn any vehicle
 |-- 3. Press [+attack2] on the vehicle
 |-- 4. Give the Unit a unique name
 |-- 5. (Optional) Select the Heat Level the Unit appears in
 |-- 6. (Optional) Tweak other values as you see fit
 |-- 7. Click [string:uv.tool.create]
 
Now apply the Unit via the [string:tool.uvunitmanager.name] tool, and you'll either face the Unit you made, or be allowed to play as the Unit against the fleeing suspects.
]],
["Pursuit.Roadblocks"] = [[
# -- I want to create Roadblocks. What do I do?

You use the [string:tool.uvroadblock.name] tool:
 |-- 1. Using the tool, create the props and pieces necessary for the roadblock
 |-- 2. Using the [string:tool.weld.name] tool (or any alternative), weld all the pieces together
 |-- 3. Once welded, press [+attack2] on any piece of the roadblock
 |-- 4. Tweak the settings to your liking, then click [string:uv.tool.create]
 
The roadblock will now appear randomly when a Pursuit is active.
]],
["Pursuit.Pursuitbreaker"] = [[
# -- I want to create Pursuit Breakers. What do I do?

You use the [string:tool.uvpursuitbreaker.name] tool:
 |-- 1. Create the props and pieces necessary for the Pursuit Breaker
 |-- 2. Using the [string:tool.weld.name] tool (or any alternative), weld all the pieces together
 |-- 3. Once welded, press [+attack2] on any piece of the Pursuit Breaker
 |-- 4. Tweak the settings to your liking, then click [string:uv.tool.create]
]],

["Other.CreateTraffic"] = [[
# -- How do I spawn traffic?

Here's what you do:
 |-- 1. Pull out the [string:tool.uvtrafficmanager.name] tool
 |-- 2. Spawn any vehicle
 |-- 3. Press [+attack2] on the vehicle
 |-- 4. Give the vehicle a unique name
 |-- 5. (Optional) Tweak the values as you see fit
 |-- 6. Click [string:uv.tool.create]
 
You can then tweak general settings in the [string:uv.tm] tab in the UV Menu.
]],
["Other.PursuitTech"] = [[
# -- What are Pursuit Tech?

Pursuit Tech are a series of weapons and support devices utilized by both Racers and Units.
You can apply up to 2 Pursuit Techs to your vehicle to either fight the opponents or defend yourself.

Here's how to apply and use them:
 |-- 1. Pull out the [string:tool.uvpursuittech.name] tool
 |-- 2. Select the Pursuit Tech you want to use as a Racer or Unit
 |-- 3. Press [+attack] on your vehicle or Unit
 
You can now press [key:unitvehicle_pursuittech_keybindslot_1] and [key:unitvehicle_pursuittech_keybindslot_2] to activate your Pursuit Tech while driving!
]],
["Other.RenameAI"] = [[
# -- Can I rename AI Racers and Units?

Yes you can. And it's simple:
 |-- 1. Pull out the [string:tool.uvnamechanger.name] tool
 |-- 2. Type out the name you want the AI to have
 |-- 3. Press [+attack] on the AI Racer or Unit
]],
["Other.DataFolder"] = [[
# -- Where is my UV data stored?

You can find your UV-related data stored in your game's *data/unitvehicles* directory.
]],
}

-- Swedish
UV.FAQ["sv-se"] = {
-- Introduction
["Intro"] = [[
# -- Vad är det här för tillägg?

Unit Vehicles är ett Sandbox-fokuserat tillägg som tillåter spelare, antingen flera spelare via nätet eller ensam med AI, att gå med i jakter i hög hastighet som eller emot polisen (Enheter) och spännande lopp på vilken karta som helst.

**Här är dem nuvarande stödjande fordonsbaserna:**
 |-- prop_vehicle_jeep (standard fordonsbas)
 |-- simfphys
 |-- Glide (krävs och starkt rekommenderad)
]],
["Requirements"] = [[
# -- Behöver jag installera andra tillägg för detta?
Ja. *Decent Vehicle - Basic AI* och *Glide // Styled's Vehicle Base* KRÄVS för att Unit Vehicles ska fungera korrekt.
 |-- Decent Vehicles ger waypoints till AI:n att spawna och köra runt på.
 |-- Glide erbjuder fordonen som krävs för standard förinställningen.
]],
["Github"] = [[
# -- Har tillägget en GitHub-sida?

Ja. Den är privat för tillfället tills officiella lanseringen.
]],
["Roadmap"] = [[
# -- Hur håller jag mig uppdaterad på senaste uppdateringarna? Finns det en vägkarta?

Du kan följa oss på vår Trello-sida, eller på vår Discord-server. Du hittar båda på Workshop-sidan.
]],
["ConVars"] = [[
# -- Vilka konsolkommandon kan jag använda?

 |-- uv_spawnvehicles - Spawnar patrullerande AI-enheter
 |-- uv_setheat [x] - Sätter spaningsnivån
 |-- uv_despawnvehicles - Tar bort patrullerande AI-enheter
 |-- uv_resetallsettings - Återställer alla serverinställningar
 |-- uv_startpursuit - Påbörjar en nedräkning innan en jakt startas
 |-- uv_stoppursuit - Stoppar jakten där AI-enheter tror att du kommit undan
 |-- uv_wantedtable - Skriver ut en lista på efterlysta misstänka i konsolen
 |-- uv_clearbounty - Sätter belöningsvärdet till 0
 |-- uv_setbounty [x] - Sätter belöningsvärdet
 |-- uv_spawn_as_unit - Tillåter dig att gå med som en enhet
]],

-- Racing
["Racing.Joining"] = [[
# -- Hur går jag med ett race?

Om något har förberett ett race och skickat en inbjudan så får du en notifikation på skärmen som bjuder in dig till den, förutsatt att du är i ett fordon och ingen jakt pågår.
]],

["Racing.Resetting"] = [[
# -- Jag har fastnat! Hur återställer jag?

 |-- Tryck på [key:unitvehicle_keybind_resetposition] för att återställa din bil
 |-- Vänta 3 sekunder
 |-- Du är tillbaks till kontrollpunkten du kört igenom!
 
**Notera**
 |-- Du kan inte återställa när du arresteras
 |-- Du kan inte återställa när du är i rörelse
]],

["Racing.Starting"] = [[
# -- Hur börjar jag ett race?

Påbörja ett race genom att gå till [string:uv.rm] i UV-menyn:
 |-- Tryck på [string:uv.rm.loadrace]
 |-- Välj ett race i listan
 |-- Bjud in andra tävlande, eller tryck på [string:uv.rm.startrace]
 |-- Du kan omedelbart påbörja racet, eller automatiskt spawna AI för att gå med racet


*Notera*
 |-- Det måste finnas minst 1 Startplats för att påbörja racet!
 |-- Du kan bjuda in vänner/AI-racers genom att trycka på [string:uv.rm.sendinvite] innan du trycker på [string:uv.rm.startrace], förutsatt att ett race är laddat.
 |-- Om det inte finns något race så behöver du skapa ditt eget
 |-- Alternativt så hittar du några på Workshop!
]],

["Racing.Create"] = [[
# -- Hur skapar jag ett race?
Använd verktyget [string:tool.uvracemanager.name]:


*-- Steg 1: Skapa kontrollpunkter*
 |-- Tryck på [+attack] i ett hörn för att börja placera en kontrollpunkt.
 |-- Tryck på [+attack] i ett annat hörn för att slutföra placeringen.
 |-- Tips: Håll inne [+use] för att öka höjden på kontrollpunkten automatiskt.
 

*-- Steg 2: Sätt kontrollpunkternas ordning*
 |-- Tryck på [+attack2] på kontrollpunkten
 |-- Skriv in Kontrollpunktens ID
 |-- Var säker på att ID:n är i sekventiell ordning
 |-- Förgrenade punkter använder matchande ID
 |-- AI:n kommer alltid använda den sist utplacerade kontrollpunkten
 

*-- Steg 3: Skapa spawnpunkter*
 |-- Tryck på [+reload] för att placera ut Spawnpunkter
 |-- Punkternas nummer representerar startordning
 |-- Vill du ha fler tävlande? Placera ut fler punkter!
 

*-- Steg 4: Exportera racet*
 |-- Färdig med racet? Öppna Spawnmenyn och tryck på [string:tool.uvracemanager.settings.saverace]
 |-- Ge den ett namn
 |-- Den kommer nu visas som ett race du kan importera och tävla på!
]],
["Racing.Create.Speedlimit"] = [[
# -- AI-racers kör för fort runt banan!

När du placerar ut kontrollpunkter så måste du specifiera hastigheten som AI:n kommer ta den i.
Om AI:n kör för fort så behöver du redigera hastighetsbegränsningsvärdet som du hittar i inställningarna på verktyget [string:tool.uvracemanager.name].
Om ett race redan är laddat så kan du trycka på [+attack2] på Kontrollpunkten för att redigera den och tillämpa den uppdaterade gränsen.
Alternativt så kan du redigera det sista värdet i racets datafil.
]],

-- Pursuits
["Pursuit.Starting"] = [[
# -- Hur påbörjar jag en jakt?

 |-- Gå till [string:uv.pm]
 |-- Tryck på [string:uv.pm.pursuit.start]
 |-- Alternativt så krockar du med, eller köra galet nära en Enhet
 |-- Iväg med dig!
]],

["Pursuit.JoinAsUnit"] = [[
# -- Kan jag gå med jakten som en Enhet?

Ja, det kan du! Och simpelt är det:
 |-- Gå till [string:uv.pm] eller [string:uv.menu.welcome]
 |-- Tryck på [string:uv.pm.spawnas]
 |-- Välj fordonet du vill köra
 |-- Iväg med dig!
]],
["Pursuit.Respawn"] = [[
# -- Jag har fastnat eller är för långt bort från dem misstänkta! Hur återställer jag?

 |-- Tryck på [key:unitvehicle_keybind_resetposition] för att öppna menyn [string:tool.uvunitmanager.settings.voiceunit.select]
 |-- Välj ett fordon du vill återställas som
 |-- Iväg med dig!
 
**Notera**
 |-- Om du återstället en gång så behöver du vänta ett ögonblick innan du kan göra det igen
]],
["Pursuit.CreateUnits"] = [[
# -- Jag vill skapa Enheter. Hur gör jag det?

Du gör såhär:
 |-- 1. Ta fram verktyget [string:tool.uvunitmanager.name]
 |-- 2. Spawna ett fordon
 |-- 3. Tryck på [+attack2] på fordonet
 |-- 4. Ge Enheten ett unikt namn
 |-- 5. (Valfritt) Välj Spaningsnivån som Enheten ska finnas i
 |-- 6. (Valfritt) Ändra andra värden som du vill
 |-- 7. Tryck på [string:uv.tool.create]
 
Du kan nu tillämpa Enheten via verktyget [string:tool.uvunitmanager.name] och antingen möta Enheten du precis skapat, eller tillåtas att spela som Enheten mot flyende misstänkta.
]],
["Pursuit.Roadblocks"] = [[
# -- Jag vill skapa vägspärrar. Hur gör jag det?

Du använder verktyget [string:tool.uvroadblock.name]:
 |-- 1. Skapa föremål och delar som krävs till vägspärren med verktyget
 |-- 2. Med verktyget [string:tool.weld.name] (eller alternativ), svetsa alla delar tillsammans
 |-- 3. När dem är svetsade, tryck på [+attack2] på vilken del som helst i vägspärren
 |-- 4. Ändra inställningarna som du vill, och tryck därefter på [string:uv.tool.create]
 
Vägspärren kommer nu placeras ut slumpmässigt när en jakt pågår.
]],
["Pursuit.Pursuitbreaker"] = [[
# -- Jag vill skapa Pursuit Breakers. Hur gör jag?

Du använder verktyget [string:tool.uvpursuitbreaker.name]:
 |-- 1. Skapa föremål och delar som krävs till Pursuit Breakern
 |-- 2. Med verktyget [string:tool.weld.name] (eller alternativ), svetsa alla delar tillsammans
 |-- 3. När dem är svetsade, tryck på [+attack2] på vilken del som helst i vägspärren
 |-- 4. Ändra inställningarna som du vill, och tryck därefter på [string:uv.tool.create]
]],

["Other.CreateTraffic"] = [[
# -- Hur spawnar jag trafik?

Du gör såhär:
 |-- 1. Ta fram verktyget [string:tool.uvtrafficmanager.name]
 |-- 2. Spawna ett fordon
 |-- 3. Tryck på [+attack2] på fordonet
 |-- 4. Ge fordonet ett unikt namn
 |-- 5. (Valfritt) Ändra värden som du själv vill
 |-- 6. Tryck på [string:uv.tool.create]
 
Du kan ändra generella inställningar i [string:uv.tm]-fliken i UV-menyn.
]],
["Other.PursuitTech"] = [[
# -- Vad är Jakt Teknologi?

Jakt Teknologi är en samling vapen och stödanordning som används av både Racers och Enheter.
Du kan tillämpa upp till 2 Jakt Teknologin på ditt fordon för att antingen strida mot moståndare, eller försvara dig själv.

Såhär tillämpar du och använder dem:
 |-- 1. Ta fram verktyget [string:tool.uvpursuittech.name]
 |-- 2. Välj Teknologin du vill använda som en Racer eller Enhet
 |-- 3. Tryck på [+attack] på ditt fordon eller din Enhet
 
Du kan nu trycka på [key:unitvehicle_pursuittech_keybindslot_1] och [key:unitvehicle_pursuittech_keybindslot_2] för att aktivera din Jakt Teknologi när du kör!
]],
["Other.RenameAI"] = [[
# -- Kan jag döpa om AI-racers och Enheter?

Ja, det kan du. Och simpelt är det:
 |-- 1. Ta fram verktyget [string:tool.uvnamechanger.name]
 |-- 2. Skriv namnet du vill att AI:n ska ha
 |-- 3. Tryck på [+attack] på AI-racern eller Enheten
]],
["Other.DataFolder"] = [[
# -- Vart finns min UV-data?

Du kan hitta all din UV-data i spelets *data/unitvehicles*-mapp.
]],
}
