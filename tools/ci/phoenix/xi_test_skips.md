# xi_test skips

Upstream xi_test cases that Phoenix's CI leaves out.
`run_xi_test.py` reads every list item that is just a code span, like the ones below, and passes it to xi_test as `--no-filter`.
Each pattern is a regex matched anywhere in the full test name, so escape characters such as `( ) + .`.

Every entry says why the tests fail on Phoenix and names the test under `scripts/tests/phoenix` that replaces them, if there is one.

## Phoenix data and modules

### Era player stats

`era/data/stats.yaml` restores player growth from before the April 2014 update.
Replaced by `systems/base_stats.lua`.

- `^systems::Base stats::Job stats`
- `^systems::Base stats::Subjob stats`

### Claim shield

`custom/lua/claim_shield.lua` keeps Sewer Syrup, Xolotl, Citipati, Golden Bat and Valkurm Emperor unkillable and unclaimable for 5 seconds after they spawn.
Replaced by `jobs/thf/traits/gilfinder.lua`, `systems/event_target.lua` and `systems/spawn_handler.lua`.

- `^jobs::thf::traits::Gilfinder::`
- `^systems::Event target::is not inherited from a mob engaging the player`
- `^systems::Event target::is not inherited from a kill that started no event`
- `^systems::Spawn Handler::timed night spawns::does not respawn killed Xolotl on next night`
- `^systems::Spawn Handler::night lottery slot::keeps a killed NM out of the roll until its cooldown ends`
- `^systems::Spawn Handler::lottery slot::brings the same NM back after it deaggros`
- `^systems::Spawn Handler::lottery slot::keeps the NM out of the roll until its cooldown ends`

### Quicksand Caves respawn

`phoenix/data/zones` gives Quicksand Caves mobs a 960 second era respawn.
Replaced by `systems/spawn_handler.lua`.

- `^systems::Spawn Handler::weather lottery slot::`

### Chocobo digging

`phoenix/lua/globals/hobbies/chocobo_digging` replaces digging with era rules that have no raised chocobo abilities, and keeps fatigue in account vars.
Replaced by `systems/chocobo_raising/digging.lua`.

- `^systems::chocobo_raising::Chocobo digging::`

### Ores and Damascene Cloth

Phoenix ores and Damascene Cloth don't stack (`phoenix/sql/pxi_item_basic.sql`).
Replaced by `systems/guild_shops/selling.lua`, `systems/crafting/hq.lua` and `systems/interaction_framework.lua`.

- `^systems::guild_shops::Guild shop selling::clamps a sale to the shop max stock`
- `^systems::guild_shops::Guild shop selling::sells across multiple inventory stacks`
- `^systems::crafting::HQ::T2 HQ rate`
- `^systems::Interaction Framework::completes Shady Business quest with zinc ore trade`

### Tsutsuroon's Iron Sand price

`phoenix/lua/data/era_guild_shops.lua` sets Tsutsuroon's era price for Iron Sand.
Replaced by `systems/guild_shops/price_curves.lua`.

- `^systems::guild_shops::Guild shop price curves::Tsutsuroon::buy -- Iron Sand`

### Lu Shang's repair

`era/sql/rov/rov_synth_recipes.sql` puts the Lu Shang's repair back at Wood 80, past the 15 level cancel line for the test's crafter.
Replaced by `systems/crafting/material_loss.lua`.

- `^systems::crafting::Material loss::zero rate material always survives a break`

### Blue Magic damage

Era base stats change the damage.
Replaced by `systems/spells/blue_correlation.lua`.

- `^systems::spells::Blue Magic monster correlation::`

### Old-school Dynamis and level 75

Old-school Dynamis (`phoenix/data/zones/dynamis_*`) spawns its mobs on entry instead of at zone load, and level 99 weapon skills don't exist at 75.
Replaced by `packets/s2c/0x028_battle2/battle2.lua`.

- `^packets::s2c::0x028_battle2::BATTLE2::Basic Attacks::Guarded hits`
- `^packets::s2c::0x028_battle2::BATTLE2::Basic Attacks::Parried hits`
- `^packets::s2c::0x028_battle2::BATTLE2::Mobskills::Mob buffing self \+ ally`
- `^packets::s2c::0x028_battle2::BATTLE2::Mobskills::Sweep no valid target in range`
- `^packets::s2c::0x028_battle2::BATTLE2::Weaponskills #ws::Guarded WS`

### Jug pets

Era jug pets use Sic instead of Ready (`era/lua/globals/pets/jug.lua`).
Replaced by the Jug Pet Sic case in `packets/s2c/0x028_battle2/battle2.lua`.

- `^packets::s2c::0x028_battle2::BATTLE2::Beastmaster::Jug Pet Ready`

### Meeble nap

Phoenix's legacy Temenos (`phoenix/data/zones/temenos`) has no Meeble, and it's the meeble mixin's only user.
There's nothing to replace this with.

- `^systems::roam::Meeble nap::`

### Dynamis - Jeuno roam pathing

Phoenix's Dynamis - Jeuno uses the old-school layout.
Replaced by `systems/pathing/dynamis_jeuno_roam_pathing.lua`, which uses an Armorer from that layout.

- `^systems::pathing::Dynamis - Jeuno roam pathing away from the spawn anchor::roams out via the staircase`

## Era settings

These rules only apply under the era settings `setup_tests.py` gives CI.

### Event storage fee

`era/lua/globals/event_storage.lua` keeps the 500 gil withdrawal fee.
Replaced by `systems/trading/event_storage.lua`.

- `^systems::trading::Event Storage NPCs::stores a former race variant and returns the current one`
- `^systems::trading::Event Storage NPCs::stores a former gender variant and returns the current one`
- `^systems::trading::Event Storage NPCs::hands the item back for the fee with its recast reset`

### Repair

`era/lua/globals/job_utils/puppetmaster.lua` drops Repair's burst heal.
Replaced by `jobs/pup/abilities/repair.lua`.

- `^jobs::pup::abilities::Repair::heals the automaton with an oil at or below the synced level`

### Stoneskin recast

Era Fast Cast tiers leave Stoneskin's recast at 27 seconds.
Replaced by `packets/s2c/0x028_battle2/battle2.lua`.

- `^packets::s2c::0x028_battle2::BATTLE2::Magic #magic::Stoneskin Self`

### Ferdoulemiont's stock

`era/lua/zones/southern_san_doria/npcs/southern_san_doria_vendors.lua` replaces Ferdoulemiont's stock.
Replaced by `systems/stable_npcs.lua`.

- `^systems::Stable area NPCs::prices Ferdoulemiont's stock`

### Simurgh respawn

`era/lua/globals/old_nm_respawn_timers.lua` gives Simurgh a 21 to 24 hour window.
Replaced by `systems/spawn_handler.lua`.

- `^systems::Spawn Handler::scripted spawns::respawns Simurgh after kill within respawn window`

## Content Phoenix has off

WotG and later content is off on Phoenix, so there's nothing to replace these with.

- `^missions::Wings of the Goddess::`
- `^missions::A Shantotto Ascension::`
- `^missions::Seekers of Adoulin::`
- `^missions::Rhapsodies of Vana'diel::`
- `^quests::WOTG Nation Quests`
- `^quests::Quest: An Explorer's Footsteps::.*Batallia Downs \(S\)`
- `^jobs::dnc::`
- `^jobs::sch::`
- `^jobs::geo::`
- `^jobs::run::`
- `^systems::monstrosity::`
- `^systems::A\.M\.A\.N\. Trove::`
- `^systems::trading::Porter Moogle::`
- `^systems::spells::AoE::Majesty #pld::`
- `^systems::spells::AoE::Accession #sch::`
- `^systems::spells::AoE::Songs #brd::forces single target with Pianissimo`
- `^systems::TargetFind::Valaineral trust`
- `^systems::Kid Mithra shops::Macchi Gazlitah::`
- `^systems::Stable area NPCs::has Palabelle turn away a player outside the CRA`
- `^systems::chocobo_raising::Chocobo raising lost chick::in San d'Oria::plays a dedicated owner's question`
- `^systems::chocobo_raising::Chocobo whistle::gives Mapitoto's chocobo companion`
- `^packets::s2c::0x028_battle2::BATTLE2::Dancer #dnc::`
- `^packets::s2c::0x028_battle2::BATTLE2::Rune Fencer #run::`
- `^packets::s2c::0x028_battle2::BATTLE2::Abilities::Composure Self`
- `^packets::s2c::0x028_battle2::BATTLE2::Dragoon #drg::Frost Breath`
- `^packets::s2c::0x028_battle2::BATTLE2::Dragoon #drg::Healing Breath sequence`
- `^packets::s2c::0x028_battle2::BATTLE2::Dragoon #drg::Smiting Breath out of range sequence`

## Upstream flakes

These fail upstream too, not because of anything Phoenix changed.

### Deaggro

It fails for about one start time in five (Vana'diel noon, default settings too), and the retries land on the same hour.
Worth reporting upstream.

- `^systems::combat::Deaggro::drops its cast and engages whoever acts next`

### Ranged Attack Free Phase Delay

The player stands 5 yalms west of the rabbit at its height, and from some of its spawn spots the slope blocks line of sight.
The retries reuse the same spot.

- `^systems::combat::Ranged Attack Free Phase Delay::`

### AoE Listeners

The first Wild_Rabbit shares a spawn slot with a night-only Ding_Bats.
If West Ronfaure fills its slots at night, the bat can hold the slot and the rabbit stays despawned.
`combat/interrupt.lua` and `effects/attack_flags.lua` call `respawn()` on the rabbit, but this test doesn't.

- `^systems::AoE Listeners::`
