# Module test exemptions

Era and phoenix module files that `module_test_coverage.py` lets through without a test.
It reads every list item that is just a code span, like the ones below, as an exempt file.

Only list a file that does nothing under CI's settings (see `setup_tests.py`), and say why.
Once a file has a test, remove its entry: the check fails on an exemption that is no longer needed.

## Off under CI's settings

### Era HNM pop system

`hnmSystem:setEnabled(false)`, so the module never applies.

- `modules/era/lua/globals/era_hnm_system.lua`

### Castle Oztroja Astral Ring drop

`m:setEnabled(false)`, and it is gated on CoP, which CI leaves on.

- `modules/era/lua/zones/castle_oztroja/zone.lua`

### Automaton maneuver bonuses

Gated on `not xi.pre(xi.expansion.WOTG)`, so it only applies once WotG is turned on.

- `modules/era/lua/globals/job_utils/automaton.lua`

### CoP signet effects

Gated on `xi.pre(xi.expansion.TOAU)`, and CI leaves ToAU on.

- `modules/era/lua/effects/era_signet_effects.lua`

### Cosmetic wardrobe

Gated on `ENABLE_COSMETIC_WARDROBE`, which `settings/default` leaves off. The item list is only read by the module.

- `modules/phoenix/lua/custom/cosmetic_wardrobe.lua`
- `modules/phoenix/lua/data/cosmetic_wardrobe_items.lua`
