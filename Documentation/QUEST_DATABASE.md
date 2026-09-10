# Quest Database

Generated from `Database/quests.json` by `build/package.py`. Target runtime: Fallout 4 PC 1.11.240 (2026-08-18 update).

## Confidence states

| State | Meaning | Tagged by default |
| --- | --- | --- |
| `verified` | Confirmed against local game records by `AuditQuests.pas`. | yes |
| `likely` | Strong public evidence, not yet confirmed against records. | yes |
| `unverified` | Listed for completeness only. | no |
| `excluded` | Reviewed and deliberately left untagged. | never |

### Current counts

| State | Entries |
| --- | --- |
| verified | 222 |
| likely | 12 |
| unverified | 2 |
| excluded | 2 |

> **Nothing in this file ships as `verified` out of the box.** Verification requires
> reading the QUST records in your own install. Run `AuditQuests.pas` first; it
> resolves the empty FormID and EditorID columns below and promotes entries whose
> records actually carry radiant signals.


# Vanilla

## Minutemen

| Quest | FormID | EditorID | Category | Repeatable | Tag | Confidence |
| --- | --- | --- | --- | --- | --- | --- |
| <Alias=TroubleName> for <Alias=ActualLocation> | 00161D1D | MinRadiantOwned06ChangeLocOnly | Radiant | yes | `[Radiant]` / `[R]` | verified |
| Clearing the Way | 0015F03F | MinRecruit05 | Radiant | yes | `[Radiant]` / `[R]` | verified |
| Defend <Alias=ActualLocation> | 000A1412 | MinRadiantOwned01 | Radiant | yes | `[Radiant]` / `[R]` | verified |
| Defend <Alias=ActualLocation> | 0005E51F | MinRadiantOwned09ChangeLocOnly | Radiant | yes | `[Radiant]` / `[R]` | verified |
| Defend <Alias=ActualLocation> | 00160409 | MinRadiantOwned05 | Radiant | yes | `[Radiant]` / `[R]` | verified |
| Defend <Alias=ActualLocation> | 00186A08 | MinRadiantOwned08 | Radiant | yes | `[Radiant]` / `[R]` | verified |
| Defend <Alias=ActualLocation> | 001533A9 | MinRadiantOwned11 | Radiant | yes | `[Radiant]` / `[R]` | verified |
| Defend the Castle | 000BDB04 | MinDefendCastle | Main | no | `[Minutemen]` / `[MM]` | verified |
| Defend the artillery at <Alias=ActualLocation> | 000E477F | MinRadiantOwned04_BOS | Radiant | yes | `[Radiant]` / `[R]` | verified |
| Form Ranks | 000DDFDB | Min301 | Main | no | `[Minutemen]` / `[MM]` | verified |
| Ghoul Problem | 00186642 | MinRecruit07 | Radiant | yes | `[Radiant]` / `[R]` | verified |
| Greenskins | 00157CA5 | MinRecruit04 | Radiant | yes | `[Radiant]` / `[R]` | verified |
| Gunners | 000C97A8 | WorkshopGunnerAttack01 | Settlement Defense | yes | `[Radiant]` / `[R]` | verified |
| Gunners | 000CFF72 | WorkshopGunnerAttack02 | Settlement Defense | yes | `[Radiant]` / `[R]` | verified |
| Inside Job | 00136329 | Min207 | Main | no | `[Minutemen]` / `[MM]` | verified |
| Kidnapped Trader at <Alias=ActualLocation> | 0003E0C1 | MinRadiantOwned03ChangeLocOnly | Radiant | yes | `[Radiant]` / `[R]` | verified |
| Kidnapping | 00099848 | MinRecruit02 | Radiant | yes | `[Radiant]` / `[R]` | verified |
| Old Guns | 000AA778 | Min03 | Main | no | `[Minutemen]` / `[MM]` | verified |
| Power for <Alias=ActualLocation> | 00162F44 | MinRadiantOwned07ChangeLocOnly | Radiant | yes | `[Radiant]` / `[R]` | verified |
| Raider Troubles | 00098136 | MinRecruit01 | Radiant | yes | `[Radiant]` / `[R]` | verified |
| Resettle Refugees at <Alias=HostileWorkshopLocation> | 00164167 | MinRecruit09 | Radiant | yes | `[Radiant]` / `[R]` | verified |
| Returning the Favor | 00106F05 | MinRecruit03 | Side | no | `[Minutemen Side Quest]` / `[MM-S]` | verified |
| Rogue Courser at <Alias=Dungeon> | 00157577 | MinRecruit08 | Radiant | yes | `[Radiant]` / `[R]` | verified |
| Sanctuary | 0005DEE4 | Min01 | Side | no | `[Minutemen Side Quest]` / `[MM-S]` | verified |
| Stop the Raiding at <Alias=ActualLocation> | 0003DF95 | MinRadiantOwned02 | Radiant | yes | `[Radiant]` / `[R]` | verified |
| Suspected Synth at <Alias=ActualLocation> | 00109D73 | MinRadiantOwned10ChangeLocOnly | Radiant | yes | `[Radiant]` / `[R]` | verified |
| Taking Independence | 0003A457 | Min02 | Main | no | `[Minutemen]` / `[MM]` | verified |
| Taking Point | 0015F040 | MinRecruit06 | Radiant | yes | `[Radiant]` / `[R]` | verified |
| The First Step | 0011B36E | MinRecruit00 | Side | no | `[Minutemen Side Quest]` / `[MM-S]` | verified |
| The Nuclear Option (Minutemen) | 0010C64A | MQ302Min | Main | no | `[Minutemen]` / `[MM]` | verified |
| The Sight | 000EBE71 | MQ00MamaMurphy | Side | no | `[Minutemen Side Quest]` / `[MM-S]` | verified |
| When Freedom Calls | 001A001C | Min00 | Main | no | `[Minutemen]` / `[MM]` | verified |
| With Our Powers Combined | 000DFB3C | MinDestBoS | Main | no | `[Minutemen]` / `[MM]` | verified |
| Defend the Castle | _pending audit_ | _pending audit_ | Side | no | - | excluded |
| Group Effort | _pending audit_ | _pending audit_ | Radiant | yes | `[Radiant]` / `[R]` | unverified |

## Brotherhood of Steel

| Quest | FormID | EditorID | Category | Repeatable | Tag | Confidence |
| --- | --- | --- | --- | --- | --- | --- |
| A Loose End | 000ADCE5 | BoSM04 | Side | no | `[Brotherhood Side Quest]` / `[BOS-S]` | verified |
| A New Dawn | 00182EAE | BoS305 | Main | no | `[Brotherhood of Steel]` / `[BOS]` | verified |
| Ad Victoriam | 00173ED9 | BoS304 | Side | no | `[Brotherhood of Steel]` / `[BOS]` | verified |
| Blind Betrayal | 000B9F9D | BoS302 | Main | no | `[Brotherhood of Steel]` / `[BOS]` | verified |
| BoS Freeform Master Quest | 001B2B08 | BoSFFMaster | Side | no | `[Brotherhood Side Quest]` / `[BOS-S]` | verified |
| Call to Arms | 0006F5C1 | BoS101 | Main | no | `[Brotherhood of Steel]` / `[BOS]` | verified |
| Cleansing the Commonwealth | 00064EC7 | BoSR01 | Radiant | yes | `[Radiant]` / `[R]` | verified |
| Duty or Dishonor | 0004402C | BoSM02 | Side | no | `[Brotherhood Side Quest]` / `[BOS-S]` | verified |
| Feeding the Troops | 000D1EB2 | BoSR05 | Radiant | yes | `[Radiant]` / `[R]` | verified |
| Fire Support | 0005DDAB | BoS100 | Main | no | `[Brotherhood of Steel]` / `[BOS]` | verified |
| From Within | 0009FF4E | BoS203 | Main | no | `[Brotherhood of Steel]` / `[BOS]` | verified |
| Leading by Example | 000C8675 | BoSR03 | Radiant | yes | `[Radiant]` / `[R]` | verified |
| Learning Curve | 000CF3E2 | BoSR04 | Radiant | yes | `[Radiant]` / `[R]` | verified |
| Liberty Reprimed | 000AE51C | BoS301 | Main | no | `[Brotherhood of Steel]` / `[BOS]` | verified |
| Outside the Wire | 0013C640 | BoS204 | Main | no | `[Brotherhood of Steel]` / `[BOS]` | verified |
| Quartermastery | 000C30DC | BosR02 | Radiant | yes | `[Radiant]` / `[R]` | verified |
| Reveille | 001826BF | BoS000 | Main | no | `[Brotherhood of Steel]` / `[BOS]` | verified |
| Semper Invicta | 0002BF20 | BoS200 | Main | no | `[Brotherhood of Steel]` / `[BOS]` | verified |
| Shadow of Steel | 0002BF21 | BoS201 | Main | no | `[Brotherhood of Steel]` / `[BOS]` | verified |
| Show No Mercy | 000537FF | BoS202 | Main | no | `[Brotherhood of Steel]` / `[BOS]` | verified |
| Spoils of War | 000FDC8C | BoS303 | Main | no | `[Brotherhood of Steel]` / `[BOS]` | verified |
| Tactical Thinking | 00107A1C | BoS302B | Main | no | `[Brotherhood of Steel]` / `[BOS]` | verified |
| The Lost Patrol | 000B1D79 | BoSM01 | Side | no | `[Brotherhood Side Quest]` / `[BOS-S]` | verified |
| The Nuclear Option (Brotherhood of Steel) | 0010C64B | MQ302BoS | Main | no | `[Brotherhood of Steel]` / `[BOS]` | verified |
| Tour of Duty | 000537FC | BoS201B | Main | no | `[Brotherhood of Steel]` / `[BOS]` | verified |
| Blood Bank | _pending audit_ | _pending audit_ | Radiant | yes | `[Radiant]` / `[R]` | likely |

## Railroad

| Quest | FormID | EditorID | Category | Repeatable | Tag | Confidence |
| --- | --- | --- | --- | --- | --- | --- |
| A Clean Equation | 0014A34A | RRR10 | Radiant | yes | `[Radiant]` / `[R]` | verified |
| Boston After Dark | 0005FD90 | RRM01 | Side | no | `[Railroad Side Quest]` / `[RR-S]` | verified |
| Burning Cover | 0019E746 | RRAct3Lost | Main | no | `[Railroad]` / `[RR]` | verified |
| Butcher's Bill | 000B1F1D | RRR01a | Side | yes | `[Railroad Side Quest]` / `[RR-S]` | verified |
| Butcher's Bill 2 | 000B1F1C | RRR01b | Side | yes | `[Railroad Side Quest]` / `[RR-S]` | verified |
| Concierge | 000B3E82 | RRR02a | Radiant | yes | `[Radiant]` / `[R]` | verified |
| High Ground | 00145F1A | RRR09 | Radiant | yes | `[Railroad Side Quest]` / `[RR-S]` | verified |
| Jackpot: <Alias=QuestLocation> | 000B926B | RRR03 | Side | yes | `[Railroad Side Quest]` / `[RR-S]` | verified |
| Memory Interrupted | 000A8BAF | RRM02 | Side | no | `[Railroad Side Quest]` / `[RR-S]` | verified |
| Mercer Safehouse | 000B26C2 | RRR04 | Side | no | `[Railroad Side Quest]` / `[RR-S]` | verified |
| Operation Ticonderoga | 0007CC61 | RR301 | Main | no | `[Railroad Side Quest]` / `[RR-S]` | verified |
| Precipice of War | 0002C8CB | RR302 | Main | no | `[Railroad]` / `[RR]` | verified |
| Randolph Safehouse <Global=RRR06DisplayNumber> | 001845F7 | RRR06 | Side | yes | `[Railroad Side Quest]` / `[RR-S]` | verified |
| Road to Freedom | 000459D2 | RR101 | Main | no | `[Railroad]` / `[RR]` | verified |
| Rockets' Red Glare | 00043275 | RR303 | Main | no | `[Railroad]` / `[RR]` | verified |
| The Nuclear Option (Railroad) | 0010C64C | MQ302RR | Main | no | `[Railroad]` / `[RR]` | verified |
| To the Mattresses <Global=RRR08DisplayNumber> | 0013A33D | RRR08 | Side | yes | `[Railroad Side Quest]` / `[RR-S]` | verified |
| Tradecraft | 0006FA37 | RR102 | Main | no | `[Railroad]` / `[RR]` | verified |
| Underground Undercover | 000B2D48 | RR201 | Main | no | `[Railroad]` / `[RR]` | verified |
| Variable Removal | 00186C79 | RRR07 | Radiant | yes | `[Radiant]` / `[R]` | verified |
| Weathervane: <Alias=QuestLocation> | 000B926A | RRR05 | Side | yes | `[Railroad Side Quest]` / `[RR-S]` | verified |

## Institute

| Quest | FormID | EditorID | Category | Repeatable | Tag | Confidence |
| --- | --- | --- | --- | --- | --- | --- |
| A House Divided | 000B2D47 | InstM03 | Side | no | `[Institute Side Quest]` / `[INST-S]` | verified |
| Airship Down | 000BAD00 | Inst308 | Main | no | `[Institute]` / `[INST]` | verified |
| Appropriation | 000EDCEF | InstR03NEW | Radiant | yes | `[Radiant]` / `[R]` | verified |
| Building a Better Crop | 000986C7 | InstM01 | Side | no | `[Institute Side Quest]` / `[INST-S]` | verified |
| End of the Line | 000BACFF | Inst307 | Main | no | `[Institute]` / `[INST]` | verified |
| Hypothesis | 000EB268 | InstR02 | Radiant | yes | `[Radiant]` / `[R]` | verified |
| Mankind - Redefined | 0002B4E9 | Inst303 | Main | no | `[Institute]` / `[INST]` | verified |
| Mass Fusion | 0015BD39 | InstMassFusion | Main | no | `[Institute]` / `[INST]` | verified |
| Nuclear Family | 000ABDCD | InstMQPostQuest | Main | no | `[Institute]` / `[INST]` | verified |
| Pest Control: <Alias=Dungeon> | 000F7933 | InstR01 | Radiant | yes | `[Radiant]` / `[R]` | verified |
| Pinned | 000A274B | Inst305 | Main | no | `[Institute]` / `[INST]` | verified |
| Pinned | 00055BE4 | MinVsInst | Main | no | `[Institute]` / `[INST]` | verified |
| Plugging a Leak | 000A8257 | InstM02 | Side | no | `[Institute Side Quest]` / `[INST-S]` | verified |
| Political Leanings | 000F0D8C | InstR05 | Side | yes | `[Institute Side Quest]` / `[INST-S]` | verified |
| Powering Up | 000AC7B3 | Inst306 | Main | no | `[Railroad]` / `[RR]` | verified |
| Reclamation: <Alias=Dungeon> | 000EDE28 | InstR04 | Radiant | yes | `[Radiant]` / `[R]` | verified |
| Synth Retention | 000E2058 | Inst301 | Main | no | `[Institute]` / `[INST]` | verified |
| The Battle of Bunker Hill | 000A8258 | Inst302 | Main | no | `[Institute]` / `[INST]` | verified |

## Other

| Quest | FormID | EditorID | Category | Repeatable | Tag | Confidence |
| --- | --- | --- | --- | --- | --- | --- |
| A Pillar of the Community | 000C5093 | DN019JoinCult | Side | no | `[Side Quest]` / `[S]` | verified |
| Benign Intervention | 001666C5 | COMCaitQuest | Side | no | `[Side Quest]` / `[S]` | verified |
| Botany Class | 0002125F | FFDiamondCity03 | Side | no | `[Side Quest]` / `[S]` | verified |
| Cambridge Polymer Labs | 000284BC | DN015 | Side | no | `[Side Quest]` / `[S]` | verified |
| Confidence Man | 00022A05 | MS14 | Side | no | `[Side Quest]` / `[S]` | verified |
| Curtain Call | 00146C84 | MS10b | Side | no | `[Side Quest]` / `[S]` | verified |
| Dangerous Minds | 000229E9 | MQ202 | Main | no | `[Main]` / `[M]` | verified |
| Dependency | 00022A09 | MS18 | Side | no | `[Side Quest]` / `[S]` | verified |
| Dependency | 00033527 | V81_03 | Side | no | `[Side Quest]` / `[S]` | verified |
| Detective Case Files | 000229FC | MS07 | Side | no | `[Side Quest]` / `[S]` | verified |
| Diamond City Blues | 00022A04 | MS13 | Side | no | `[Side Quest]` / `[S]` | verified |
| Emergent Behavior | 0016454E | COMCurieQuest | Side | no | `[Side Quest]` / `[S]` | verified |
| Emogene Takes a Lover | 000503B9 | MS09Mission02 | Side | no | `[Side Quest]` / `[S]` | verified |
| Fallen Hero | 00122220 | FFBunkerHill01 | Side | no | `[Side Quest]` / `[S]` | verified |
| Getting a Clue | 000229E6 | MQ105 | Main | no | `[Main]` / `[M]` | verified |
| Here Kitty, Kitty | 00033520 | V81_01 | Side | no | `[Side Quest]` / `[S]` | verified |
| Here There Be Monsters | 000229F7 | MS02 | Side | no | `[Side Quest]` / `[S]` | verified |
| High Ground | 00150577 | RRR11 | Radiant | yes | `[Radiant]` / `[R]` | verified |
| Hole in the Wall | 00022A0A | MS19 | Side | no | `[Side Quest]` / `[S]` | verified |
| Human Error | 00022A08 | MS17 | Side | no | `[Side Quest]` / `[S]` | verified |
| Hunter/Hunted | 000229EB | MQ205 | Main | no | `[Main]` / `[M]` | verified |
| In Sheep's Clothing | 001764DF | FFDiamondCity10 | Side | no | `[Side Quest]` / `[S]` | verified |
| Institutionalized | 000229EC | MQ207 | Main | no | `[Institute]` / `[INST]` | verified |
| Jewel of the Commonwealth | 000229E5 | MQ103 | Main | no | `[Main]` / `[M]` | verified |
| Kid in a Fridge | 000229F6 | MS01 | Side | no | `[Side Quest]` / `[S]` | verified |
| Last Voyage of the U.S.S. Constitution | 00022A02 | MS11 | Side | no | `[Side Quest]` / `[S]` | verified |
| Long Road Ahead | 00027411 | COMMacCreadyQuest | Side | no | `[Side Quest]` / `[S]` | verified |
| Long Time Coming | 000229FE | MS07c | Side | no | `[Side Quest]` / `[S]` | verified |
| Med-Tek Research | 00084CE1 | DN066 | Side | no | `[Side Quest]` / `[S]` | verified |
| Mystery Meat | 0002633E | DN079 | Side | no | `[Side Quest]` / `[S]` | verified |
| Order Up | 001069A9 | DialogueDrumlinDiner | Side | no | `[Side Quest]` / `[S]` | verified |
| Out in Left Field | 00035D03 | FFDiamondCity06 | Side | no | `[Side Quest]` / `[S]` | verified |
| Out of Time | 0001CC2A | MQ102 | Main | no | `[Main]` / `[M]` | verified |
| Out of the Fire | 00026340 | DN121 | Side | no | `[Minutemen Side Quest]` / `[MM-S]` | verified |
| Painting the Town | 0001D727 | FFDiamondCity01 | Side | no | `[Side Quest]` / `[S]` | verified |
| Painting the Town Pointer | 0004F623 | FFDiamondCity01Misc | Side | no | `[Side Quest]` / `[S]` | verified |
| Pickman's Gift | 0007E1BB | DN028 | Side | no | `[Side Quest]` / `[S]` | verified |
| Prep School | 0012221F | FFBunkerHill03 | Side | no | `[Side Quest]` / `[S]` | verified |
| Public Knowledge | 00108EC0 | FFGoodneighbor01 | Side | no | `[Side Quest]` / `[S]` | verified |
| Pull the Plug | 001073CE | DN138 | Side | no | `[Side Quest]` / `[S]` | verified |
| Reunions | 000229E7 | MQ106 | Main | no | `[Main]` / `[M]` | verified |
| Short Stories | 001338B9 | V81_04 | Side | no | `[Side Quest]` / `[S]` | verified |
| Special Delivery | 000503B8 | MS09Mission01 | Side | no | `[Side Quest]` / `[S]` | verified |
| Story of the Century | 000456E8 | FFDiamondCity07 | Side | no | `[Side Quest]` / `[S]` | verified |
| Talk to Jack Cabot about the artifact | 000F491A | MS09MiscJackReward | Side | no | `[Side Quest]` / `[S]` | verified |
| The Big Dig | 00022A07 | MS16 | Side | no | `[Side Quest]` / `[S]` | verified |
| The Combat Zone | 0004ACE8 | CZMisc | Side | no | `[Side Quest]` / `[S]` | verified |
| The Devil's Due | 0014B717 | MS05B | Side | no | `[Side Quest]` / `[S]` | verified |
| The Disappearing Act | 0001CB51 | MS07a | Side | no | `[Side Quest]` / `[S]` | verified |
| The Gilded Grasshopper | 000229FD | MS07b | Side | no | `[Side Quest]` / `[S]` | verified |
| The Glowing Sea | 0006B500 | MQ204 | Main | no | `[Main]` / `[M]` | verified |
| The Marowski Heist | 00084E40 | MS13MarowskiRevenge | Side | no | `[Side Quest]` / `[S]` | verified |
| The Memory Den | 0010B654 | FFGoodneighbor02 | Side | no | `[Side Quest]` / `[S]` | verified |
| The Molecular Level | 000B1752 | MQ206 | Main | no | `[Main]` / `[M]` | verified |
| The Secret of Cabot House | 00022A00 | MS09 | Side | no | `[Side Quest]` / `[S]` | verified |
| The Silver Shroud | 00027556 | MS04 | Side | no | `[Side Quest]` / `[S]` | verified |
| Traffic Jam | 00122221 | FFBunkerHill02 | Side | no | `[Side Quest]` / `[S]` | verified |
| Trouble Brewin' | 00022A03 | MS12 | Side | no | `[Side Quest]` / `[S]` | verified |
| Trouble Brewin' | 0017D18C | DialogueGoodneighborRufus | Side | no | `[Side Quest]` / `[S]` | verified |
| Unlikely Valentine | 0001F25E | MQ104 | Main | no | `[Main]` / `[M]` | verified |
| Vault 75 | 000FCB15 | DN143 | Side | no | `[Side Quest]` / `[S]` | verified |
| Vault 81 | 000B8464 | V81_00_Intro | Side | no | `[Side Quest]` / `[S]` | verified |
| War Never Changes | 0001ED86 | MQ101 | Main | no | `[Main]` / `[M]` | verified |


# Automatron

| Quest | FormID | EditorID | Category | Repeatable | Tag | Confidence |
| --- | --- | --- | --- | --- | --- | --- |
| A New Threat | 01000801 | DLC01MQ02 | Main | no | `[Automatron]` / `[DLC]` | verified |
| Headhunting | 01002833 | DLC01MQ04 | Main | no | `[Automatron]` / `[DLC]` | verified |
| Mechanical Menace | 01000806 | DLC01MQ01 | Main | no | `[Automatron]` / `[DLC]` | verified |
| Rogue Robot | 0100D5FC | DLC01MQPostQuestRadiantScene02 | Radiant | yes | `[Radiant]` / `[R]` | verified |
| Restoring Order | 010010F5 | DLC01MQ05 | Main | no | `[Automatron]` / `[DLC]` | likely |


# Far Harbor

| Quest | FormID | EditorID | Category | Repeatable | Tag | Confidence |
| --- | --- | --- | --- | --- | --- | --- |
| <Alias=ActualLocation>: Deadliest Catch | 01040A86 | DLC03WorkshopRadiantOwned04 | Radiant | yes | `[Radiant]` / `[R]` | verified |
| <Alias=ActualLocation>: Super Mutants in the Fog | 0100EB51 | DLC03WorkshopRadiantOwned02 | Radiant | yes | `[Radiant]` / `[R]` | verified |
| Ablutions | 0102B500 | DLC03CoA_FFNucleus03 | Side | no | `[Side Quest]` / `[S]` | verified |
| Best Left Forgotten | 01001B42 | DLC03MQ04 | Main | no | `[Far Harbor]` / `[DLC]` | verified |
| Brain Dead | 01036763 | DLC03_V118_Quest | Side | no | `[Side Quest]` / `[S]` | verified |
| Close to Home | 01004F2C | DLC03MQPostQuest | Main | no | `[Far Harbor]` / `[DLC]` | verified |
| Condensers Down at <Alias=ActualLocation> | 0100EB4C | DLC03WorkshopRadiantOwned01 | Radiant | yes | `[Radiant]` / `[R]` | verified |
| Data Recovery | 0104B1F6 | DLC03AcadiaM03 | Side | no | `[Side Quest]` / `[S]` | verified |
| Far From Home | 01001B3F | DLC03MQ01 | Main | no | `[Far Harbor]` / `[DLC]` | verified |
| Hunting the Hunter | 0104049B | DLC03AcadiaM02 | Side | no | `[Side Quest]` / `[S]` | verified |
| Living on the Edge | 0104E77A | DLC03FarHarborM02 | Side | no | `[Side Quest]` / `[S]` | verified |
| Rite of Passage | 0100A992 | DLC03FarHarborM01 | Side | no | `[Side Quest]` / `[S]` | verified |
| Shipbreaker | 01040A87 | DLC03WorkshopRadiantOwned05 | Radiant | yes | `[Radiant]` / `[R]` | verified |
| The Arrival | 0101536F | DLC03AcadiaM01 | Side | no | `[Side Quest]` / `[S]` | verified |
| The Changing Tide | 0104E779 | DLC03FarHarborM03 | Side | no | `[Side Quest]` / `[S]` | verified |
| The Great Hunt | 0102399F | DLC03FarHarborS03 | Side | no | `[Side Quest]` / `[S]` | verified |
| The Price of Memory | 0104B95A | DLC03AcadiaM04 | Side | no | `[Side Quest]` / `[S]` | verified |
| The Trial of Brother Devin | 0101055C | DLC03CoA_FFNucleus01 | Side | no | `[Side Quest]` / `[S]` | verified |
| The Way Life Should Be | 01001B43 | DLC03MQ05 | Main | no | `[Far Harbor]` / `[DLC]` | verified |
| Trapper Attack on <Alias=ActualLocation> | 01039953 | DLC03WorkshopRadiantOwned03 | Radiant | yes | `[Radiant]` / `[R]` | verified |
| Walk in the Park | 01001B40 | DLC03MQ02 | Main | no | `[Far Harbor]` / `[DLC]` | verified |
| Where You Belong | 01001B41 | DLC03MQ03 | Main | no | `[Far Harbor]` / `[DLC]` | verified |
| Witch Hunt | 0102C8B3 | DLC03CoA_FFNucleus02 | Side | no | `[Side Quest]` / `[S]` | verified |
| Living on the Edge | _pending audit_ | _pending audit_ | Side | no | - | excluded |
| Blood Tide | _pending audit_ | _pending audit_ | Radiant | yes | `[Radiant]` / `[R]` | likely |
| Cleansing the Land | 01001B44 | DLC03MQ06 | Main | no | `[Far Harbor]` / `[DLC]` | likely |
| Hull Breach | _pending audit_ | _pending audit_ | Radiant | yes | `[Radiant]` / `[R]` | likely |
| Safe Passage | _pending audit_ | _pending audit_ | Radiant | yes | `[Radiant]` / `[R]` | likely |


# Nuka-World

| Quest | FormID | EditorID | Category | Repeatable | Tag | Confidence |
| --- | --- | --- | --- | --- | --- | --- |
| A Goods Defense | 0102191C | DLC04_RQ_DefendCache | Radiant | yes | `[Radiant]` / `[R]` | verified |
| A Magical Kingdom | 0103684F | DLC04_KiddieKingdomMain | Side | no | `[Side Quest]` / `[S]` | verified |
| A Permanent Solution | 01017F46 | DLC04_RQ_KillRivalBoss | Radiant | yes | `[Radiant]` / `[R]` | verified |
| A World of Refreshment | 0103684E | DLC04_BottlingPlantMAIN | Side | no | `[Side Quest]` / `[S]` | verified |
| All Aboard | 01000800 | DLC04MQ00 | Main | no | `[Nuka-World]` / `[DLC]` | verified |
| An Ambitious Plan | 01000802 | DLC04MQ02 | Main | no | `[Nuka-World]` / `[DLC]` | verified |
| Cache-ing In | 0101B170 | DLC04_RQ_StealCache | Radiant | yes | `[Radiant]` / `[R]` | verified |
| Cappy in a Haystack | 01000806 | DLC04MS01 | Side | no | `[Side Quest]` / `[S]` | verified |
| Capture <Alias=MyLocation> | 0100DB37 | DLC04RaidWipeOut | Radiant | yes | `[Radiant]` / `[R]` | verified |
| Clear Out <Alias=MyLocation> | 01014352 | DLC04RaidChaseOff | Radiant | yes | `[Radiant]` / `[R]` | verified |
| Collaring Outside the Lines | 01032A66 | DLC04_RQ_CollarTroubleMaker | Radiant | yes | `[Radiant]` / `[R]` | verified |
| High Noon at the Gulch | 010431AB | DLC04DryRockGulch | Side | no | `[Side Quest]` / `[S]` | verified |
| Open Season | 01027704 | DLC04RaiderKickout | Side | no | `[Side Quest]` / `[S]` | verified |
| Power Play | 01000805 | DLC04MQ05 | Main | no | `[Nuka-World]` / `[DLC]` | verified |
| Safari Adventure | 010260E2 | DLC04SafariAdventureQuest | Side | no | `[Side Quest]` / `[S]` | verified |
| Shake Down <Alias=MyLocation> | 01019088 | DLC04RaidCoerce | Radiant | yes | `[Radiant]` / `[R]` | verified |
| Star Control | 0101E34A | DLC04GZMainQuest | Side | no | `[Side Quest]` / `[S]` | verified |
| Subdue <Alias=MyLocation> | 01016E18 | DLC04RaidSubdue | Radiant | yes | `[Radiant]` / `[R]` | verified |
| Taken For A Ride | 01000801 | DLC04MQ01 | Main | no | `[Nuka-World]` / `[DLC]` | verified |
| Taking out the Trash | 010322DA | DLC04_RQ_KillTroubleMaker | Radiant | yes | `[Radiant]` / `[R]` | verified |
| Trip to the Stars | 01000807 | DLC04MS02 | Side | no | `[Side Quest]` / `[S]` | verified |
| Under the Collar | 0104BD3C | DLC04_RQ_CollarRivalBoss | Radiant | yes | `[Radiant]` / `[R]` | verified |
| Amoral Combat | _pending audit_ | _pending audit_ | Radiant | yes | `[Radiant]` / `[R]` | likely |
| Home Sweet Home | 01000804 | DLC04MQ04 | Main | no | `[Nuka-World]` / `[DLC]` | likely |
| The Grand Tour | 01000803 | DLC04MQ03 | Main | no | `[Nuka-World]` / `[DLC]` | likely |
| Hostile Takeover | _pending audit_ | _pending audit_ | Radiant | yes | `[Radiant]` / `[R]` | unverified |


# Vault-Tec Workshop

| Quest | FormID | EditorID | Category | Repeatable | Tag | Confidence |
| --- | --- | --- | --- | --- | --- | --- |
| Explore Vault 88 | 01004F65 | DLC06MQ04 | Side | no | `[Side Quest]` / `[S]` | verified |
| Lady Luck | 01005117 | DLC06E04 | Side | no | `[Side Quest]` / `[S]` | verified |
| Overseer's Most Wanted | 01003DE1 | DLC06CompanionTracker | Main | no | `[Vault-Tec]` / `[DLC]` | verified |
| Power to the People | 01004A7E | DLC06E01 | Side | no | `[Side Quest]` / `[S]` | verified |
| The Watering Hole | 01004AD5 | DLC06E02 | Side | no | `[Side Quest]` / `[S]` | verified |
| Vision of the Future | 01004F72 | DLC06E03 | Side | no | `[Side Quest]` / `[S]` | verified |
| A Model Citizen | 01004840 | DLC06MQ03 | Main | no | `[Vault-Tec]` / `[DLC]` | likely |
| Better Living Underground | 0100480B | DLC06MQ02 | Main | no | `[Vault-Tec]` / `[DLC]` | likely |
| Vault-Tec Calling | 010043E5 | DLC06MQ01 | Main | no | `[Vault-Tec]` / `[DLC]` | likely |


# Next-Gen / Creation Club

| Quest | FormID | EditorID | Category | Repeatable | Tag | Confidence |
| --- | --- | --- | --- | --- | --- | --- |
| All Hallows' Eve | 01000271 | ccFSVFO4007_Quest | Side | no | `[Creation Club]` / `[CC]` | verified |
| Best of Three | 01000846 | ccBGSFO4046_BestOfThree | Side | no | `[Creation Club]` / `[CC]` | verified |
| Crucible | 01000FC4 | ccBGSFO4116_Quest | Side | no | `[Creation Club]` / `[CC]` | verified |
| Echoes of the Past | 010000E7 | ccOTMFO4001_Quest | Side | no | `[Creation Club]` / `[CC]` | verified |
| Pyromaniac | 0100086C | ccBGSFO4044_HellfireBossKillQuest | Side | no | `[Creation Club]` / `[CC]` | verified |
| Speak of the Devil | 01000845 | ccBGSFO4115_DM_Quest | Side | no | `[Creation Club]` / `[CC]` | verified |
| When Pigs Fly | 0100012A | ccSBJFO4003_Quest | Side | no | `[Creation Club]` / `[CC]` | verified |

# Deliberately excluded

Listed so the exclusions are auditable rather than invisible.

| Quest | Source | Why excluded |
| --- | --- | --- |
| Defend the Castle | Fallout4.esm | Duplicate entry handled below by MinDefendCastle. |
| Living on the Edge | DLCCoast.esm | One-time condenser repair quest. |

# Rule-discovered quests

The Minutemen settlement families are not enumerated by name here. Their display
names contain text-replacement tokens such as `<Alias=Workshop>`, so the name a
player sees is generated per settlement and is not a stable match key. They are
discovered by EditorID family instead - see `Database/radiant_rules.json`,
`radiantEditorIDPatterns`. `AuditQuests.pas` writes them into
`output/quests.candidate.tsv` with real FormIDs from your install.

# Known-empty categories

| DLC | Radiant quests | Note |
| --- | --- | --- |
| Vault-Tec Workshop | 0 expected | The vault experiments are workshop mechanics, not repeatable QUST records. |
| Contraptions Workshop | 0 expected | No quest content. |
| Wasteland Workshop | 0 expected | No quest content. |
