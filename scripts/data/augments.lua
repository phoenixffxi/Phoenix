-----------------------------------
-- Augments
-----------------------------------
xi = xi or {}
xi.data = xi.data or {}
xi.data.augments = xi.data.augments or {}

-- TODO: Not implemented, treat this as documentation and rework as needed
-- Evolith augment IDs ('Augment' in the evolith exdata) are 0 to 325
-- Source: FFXiMain.dll lookup table of 1024 entries with 20-byte records. Signature: 00 04 13 00 04 05 06 07 08 09 0A 0C 0C 0C 0C 0C 0C 0C 0C 0C
-- PPPP SSSS VV VV VV VV VV VV VV VV VV VV VV VV VV VV VV VV
-- PP = uint16 representing the prefix for the augment (i.e. Vs. beasts)
-- SS = uint16 representing the suffix for the augment (i.e. Attack+)
-- VV = 16 tiers of values (but Evoliths only really go up to tier 7)
-- Example: Evolith with augment ID 120 and bonus 3
-- -> Lookup table says prefix 1036 and suffix 20 and the 4th tier is '7'
-- -> 1036 and 20 are parsed from the main mnc2 augment DAT table (ROM/119/57.DAT)
-- -> 1036: Vs. dragons
-- ->   20: Rng. Acc.+
-- -> Complete augment: Vs. dragons: Rng. Acc.+7
-- Notes:
--   - Certain augments stored in the client cannot be produced server side.
--     - Enmity+ only exists for Katana weaponskills.
--     - There's no Lightning aligned enfeebling effects
--   - Certain augments have NO prefix

---@alias EvolithAugment { [1]: xi.evolith.prefix, [2]: xi.evolith.suffix, [3]: integer[] }

-- Table used to retrieve effects and power for a given evolith augment ID
---@type table<integer, EvolithAugment>
xi.data.augments.evolith =
{
    [  1] = { xi.evolith.prefix.VS_BEASTS,                 xi.evolith.suffix.ATTACK,                             {   4,   5,   6,   7,   8,   9,  10,  12,  12,  12,  12,  12,  12,  12,  12,  12 } },
    [  2] = { xi.evolith.prefix.VS_BEASTS,                 xi.evolith.suffix.DEFENSE,                            {   2,   4,   6,   8,  10,  12,  15,  18,  18,  18,  18,  18,  18,  18,  18,  18 } },
    [  3] = { xi.evolith.prefix.VS_BEASTS,                 xi.evolith.suffix.ACCURACY,                           {   2,   3,   4,   5,   7,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [  4] = { xi.evolith.prefix.VS_BEASTS,                 xi.evolith.suffix.EVASION,                            {   3,   4,   5,   6,   8,  10,  13,  16,  16,  16,  16,  16,  16,  16,  16,  16 } },
    [  5] = { xi.evolith.prefix.VS_BEASTS,                 xi.evolith.suffix.MAGIC_ATTACK_BONUS,                 {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [  6] = { xi.evolith.prefix.VS_BEASTS,                 xi.evolith.suffix.MAGIC_DEFENSE_BONUS,                {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [  7] = { xi.evolith.prefix.VS_BEASTS,                 xi.evolith.suffix.MAGIC_ACCURACY,                     {   2,   2,   3,   4,   5,   6,   7,   9,   9,   9,   9,   9,   9,   9,   9,   9 } },
    [  8] = { xi.evolith.prefix.VS_BEASTS,                 xi.evolith.suffix.MAGIC_EVASION,                      {   2,   3,   4,   5,   7,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [  9] = { xi.evolith.prefix.VS_BEASTS,                 xi.evolith.suffix.RANGED_ATTACK,                      {   4,   5,   6,   7,   8,   9,  10,  12,  12,  12,  12,  12,  12,  12,  12,  12 } },
    [ 10] = { xi.evolith.prefix.VS_BEASTS,                 xi.evolith.suffix.RANGED_ACCURACY,                    {   2,   3,   4,   5,   7,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [ 11] = { xi.evolith.prefix.VS_PLANTOIDS,              xi.evolith.suffix.ATTACK,                             {   4,   5,   6,   7,   8,   9,  10,  12,  12,  12,  12,  12,  12,  12,  12,  12 } },
    [ 12] = { xi.evolith.prefix.VS_PLANTOIDS,              xi.evolith.suffix.DEFENSE,                            {   2,   4,   6,   8,  10,  12,  15,  18,  18,  18,  18,  18,  18,  18,  18,  18 } },
    [ 13] = { xi.evolith.prefix.VS_PLANTOIDS,              xi.evolith.suffix.ACCURACY,                           {   2,   3,   4,   5,   7,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [ 14] = { xi.evolith.prefix.VS_PLANTOIDS,              xi.evolith.suffix.EVASION,                            {   3,   4,   5,   6,   8,  10,  13,  16,  16,  16,  16,  16,  16,  16,  16,  16 } },
    [ 15] = { xi.evolith.prefix.VS_PLANTOIDS,              xi.evolith.suffix.MAGIC_ATTACK_BONUS,                 {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [ 16] = { xi.evolith.prefix.VS_PLANTOIDS,              xi.evolith.suffix.MAGIC_DEFENSE_BONUS,                {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [ 17] = { xi.evolith.prefix.VS_PLANTOIDS,              xi.evolith.suffix.MAGIC_ACCURACY,                     {   2,   2,   3,   4,   5,   6,   7,   9,   9,   9,   9,   9,   9,   9,   9,   9 } },
    [ 18] = { xi.evolith.prefix.VS_PLANTOIDS,              xi.evolith.suffix.MAGIC_EVASION,                      {   2,   3,   4,   5,   7,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [ 19] = { xi.evolith.prefix.VS_PLANTOIDS,              xi.evolith.suffix.RANGED_ATTACK,                      {   4,   5,   6,   7,   8,   9,  10,  12,  12,  12,  12,  12,  12,  12,  12,  12 } },
    [ 20] = { xi.evolith.prefix.VS_PLANTOIDS,              xi.evolith.suffix.RANGED_ACCURACY,                    {   2,   3,   4,   5,   7,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [ 21] = { xi.evolith.prefix.VS_VERMIN,                 xi.evolith.suffix.ATTACK,                             {   4,   5,   6,   7,   8,   9,  10,  12,  12,  12,  12,  12,  12,  12,  12,  12 } },
    [ 22] = { xi.evolith.prefix.VS_VERMIN,                 xi.evolith.suffix.DEFENSE,                            {   2,   4,   6,   8,  10,  12,  15,  18,  18,  18,  18,  18,  18,  18,  18,  18 } },
    [ 23] = { xi.evolith.prefix.VS_VERMIN,                 xi.evolith.suffix.ACCURACY,                           {   2,   3,   4,   5,   7,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [ 24] = { xi.evolith.prefix.VS_VERMIN,                 xi.evolith.suffix.EVASION,                            {   3,   4,   5,   6,   8,  10,  13,  16,  16,  16,  16,  16,  16,  16,  16,  16 } },
    [ 25] = { xi.evolith.prefix.VS_VERMIN,                 xi.evolith.suffix.MAGIC_ATTACK_BONUS,                 {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [ 26] = { xi.evolith.prefix.VS_VERMIN,                 xi.evolith.suffix.MAGIC_DEFENSE_BONUS,                {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [ 27] = { xi.evolith.prefix.VS_VERMIN,                 xi.evolith.suffix.MAGIC_ACCURACY,                     {   2,   2,   3,   4,   5,   6,   7,   9,   9,   9,   9,   9,   9,   9,   9,   9 } },
    [ 28] = { xi.evolith.prefix.VS_VERMIN,                 xi.evolith.suffix.MAGIC_EVASION,                      {   2,   3,   4,   5,   7,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [ 29] = { xi.evolith.prefix.VS_VERMIN,                 xi.evolith.suffix.RANGED_ATTACK,                      {   4,   5,   6,   7,   8,   9,  10,  12,  12,  12,  12,  12,  12,  12,  12,  12 } },
    [ 30] = { xi.evolith.prefix.VS_VERMIN,                 xi.evolith.suffix.RANGED_ACCURACY,                    {   2,   3,   4,   5,   7,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [ 31] = { xi.evolith.prefix.VS_LIZARDS,                xi.evolith.suffix.ATTACK,                             {   4,   5,   6,   7,   8,   9,  10,  12,  12,  12,  12,  12,  12,  12,  12,  12 } },
    [ 32] = { xi.evolith.prefix.VS_LIZARDS,                xi.evolith.suffix.DEFENSE,                            {   2,   4,   6,   8,  10,  12,  15,  18,  18,  18,  18,  18,  18,  18,  18,  18 } },
    [ 33] = { xi.evolith.prefix.VS_LIZARDS,                xi.evolith.suffix.ACCURACY,                           {   2,   3,   4,   5,   7,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [ 34] = { xi.evolith.prefix.VS_LIZARDS,                xi.evolith.suffix.EVASION,                            {   3,   4,   5,   6,   8,  10,  13,  16,  16,  16,  16,  16,  16,  16,  16,  16 } },
    [ 35] = { xi.evolith.prefix.VS_LIZARDS,                xi.evolith.suffix.MAGIC_ATTACK_BONUS,                 {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [ 36] = { xi.evolith.prefix.VS_LIZARDS,                xi.evolith.suffix.MAGIC_DEFENSE_BONUS,                {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [ 37] = { xi.evolith.prefix.VS_LIZARDS,                xi.evolith.suffix.MAGIC_ACCURACY,                     {   2,   2,   3,   4,   5,   6,   7,   9,   9,   9,   9,   9,   9,   9,   9,   9 } },
    [ 38] = { xi.evolith.prefix.VS_LIZARDS,                xi.evolith.suffix.MAGIC_EVASION,                      {   2,   3,   4,   5,   7,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [ 39] = { xi.evolith.prefix.VS_LIZARDS,                xi.evolith.suffix.RANGED_ATTACK,                      {   4,   5,   6,   7,   8,   9,  10,  12,  12,  12,  12,  12,  12,  12,  12,  12 } },
    [ 40] = { xi.evolith.prefix.VS_LIZARDS,                xi.evolith.suffix.RANGED_ACCURACY,                    {   2,   3,   4,   5,   7,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [ 41] = { xi.evolith.prefix.VS_BIRDS,                  xi.evolith.suffix.ATTACK,                             {   4,   5,   6,   7,   8,   9,  10,  12,  12,  12,  12,  12,  12,  12,  12,  12 } },
    [ 42] = { xi.evolith.prefix.VS_BIRDS,                  xi.evolith.suffix.DEFENSE,                            {   2,   4,   6,   8,  10,  12,  15,  18,  18,  18,  18,  18,  18,  18,  18,  18 } },
    [ 43] = { xi.evolith.prefix.VS_BIRDS,                  xi.evolith.suffix.ACCURACY,                           {   2,   3,   4,   5,   7,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [ 44] = { xi.evolith.prefix.VS_BIRDS,                  xi.evolith.suffix.EVASION,                            {   3,   4,   5,   6,   8,  10,  13,  16,  16,  16,  16,  16,  16,  16,  16,  16 } },
    [ 45] = { xi.evolith.prefix.VS_BIRDS,                  xi.evolith.suffix.MAGIC_ATTACK_BONUS,                 {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [ 46] = { xi.evolith.prefix.VS_BIRDS,                  xi.evolith.suffix.MAGIC_DEFENSE_BONUS,                {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [ 47] = { xi.evolith.prefix.VS_BIRDS,                  xi.evolith.suffix.MAGIC_ACCURACY,                     {   2,   2,   3,   4,   5,   6,   7,   9,   9,   9,   9,   9,   9,   9,   9,   9 } },
    [ 48] = { xi.evolith.prefix.VS_BIRDS,                  xi.evolith.suffix.MAGIC_EVASION,                      {   2,   3,   4,   5,   7,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [ 49] = { xi.evolith.prefix.VS_BIRDS,                  xi.evolith.suffix.RANGED_ATTACK,                      {   4,   5,   6,   7,   8,   9,  10,  12,  12,  12,  12,  12,  12,  12,  12,  12 } },
    [ 50] = { xi.evolith.prefix.VS_BIRDS,                  xi.evolith.suffix.RANGED_ACCURACY,                    {   2,   3,   4,   5,   7,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [ 51] = { xi.evolith.prefix.VS_AMORPHS,                xi.evolith.suffix.ATTACK,                             {   4,   5,   6,   7,   8,   9,  10,  12,  12,  12,  12,  12,  12,  12,  12,  12 } },
    [ 52] = { xi.evolith.prefix.VS_AMORPHS,                xi.evolith.suffix.DEFENSE,                            {   2,   4,   6,   8,  10,  12,  15,  18,  18,  18,  18,  18,  18,  18,  18,  18 } },
    [ 53] = { xi.evolith.prefix.VS_AMORPHS,                xi.evolith.suffix.ACCURACY,                           {   2,   3,   4,   5,   7,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [ 54] = { xi.evolith.prefix.VS_AMORPHS,                xi.evolith.suffix.EVASION,                            {   3,   4,   5,   6,   8,  10,  13,  16,  16,  16,  16,  16,  16,  16,  16,  16 } },
    [ 55] = { xi.evolith.prefix.VS_AMORPHS,                xi.evolith.suffix.MAGIC_ATTACK_BONUS,                 {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [ 56] = { xi.evolith.prefix.VS_AMORPHS,                xi.evolith.suffix.MAGIC_DEFENSE_BONUS,                {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [ 57] = { xi.evolith.prefix.VS_AMORPHS,                xi.evolith.suffix.MAGIC_ACCURACY,                     {   2,   2,   3,   4,   5,   6,   7,   9,   9,   9,   9,   9,   9,   9,   9,   9 } },
    [ 58] = { xi.evolith.prefix.VS_AMORPHS,                xi.evolith.suffix.MAGIC_EVASION,                      {   2,   3,   4,   5,   7,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [ 59] = { xi.evolith.prefix.VS_AMORPHS,                xi.evolith.suffix.RANGED_ATTACK,                      {   4,   5,   6,   7,   8,   9,  10,  12,  12,  12,  12,  12,  12,  12,  12,  12 } },
    [ 60] = { xi.evolith.prefix.VS_AMORPHS,                xi.evolith.suffix.RANGED_ACCURACY,                    {   2,   3,   4,   5,   7,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [ 61] = { xi.evolith.prefix.VS_AQUANS,                 xi.evolith.suffix.ATTACK,                             {   4,   5,   6,   7,   8,   9,  10,  12,  12,  12,  12,  12,  12,  12,  12,  12 } },
    [ 62] = { xi.evolith.prefix.VS_AQUANS,                 xi.evolith.suffix.DEFENSE,                            {   2,   4,   6,   8,  10,  12,  15,  18,  18,  18,  18,  18,  18,  18,  18,  18 } },
    [ 63] = { xi.evolith.prefix.VS_AQUANS,                 xi.evolith.suffix.ACCURACY,                           {   2,   3,   4,   5,   7,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [ 64] = { xi.evolith.prefix.VS_AQUANS,                 xi.evolith.suffix.EVASION,                            {   3,   4,   5,   6,   8,  10,  13,  16,  16,  16,  16,  16,  16,  16,  16,  16 } },
    [ 65] = { xi.evolith.prefix.VS_AQUANS,                 xi.evolith.suffix.MAGIC_ATTACK_BONUS,                 {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [ 66] = { xi.evolith.prefix.VS_AQUANS,                 xi.evolith.suffix.MAGIC_DEFENSE_BONUS,                {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [ 67] = { xi.evolith.prefix.VS_AQUANS,                 xi.evolith.suffix.MAGIC_ACCURACY,                     {   2,   2,   3,   4,   5,   6,   7,   9,   9,   9,   9,   9,   9,   9,   9,   9 } },
    [ 68] = { xi.evolith.prefix.VS_AQUANS,                 xi.evolith.suffix.MAGIC_EVASION,                      {   2,   3,   4,   5,   7,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [ 69] = { xi.evolith.prefix.VS_AQUANS,                 xi.evolith.suffix.RANGED_ATTACK,                      {   4,   5,   6,   7,   8,   9,  10,  12,  12,  12,  12,  12,  12,  12,  12,  12 } },
    [ 70] = { xi.evolith.prefix.VS_AQUANS,                 xi.evolith.suffix.RANGED_ACCURACY,                    {   2,   3,   4,   5,   7,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [ 71] = { xi.evolith.prefix.VS_UNDEAD,                 xi.evolith.suffix.ATTACK,                             {   4,   5,   6,   7,   8,   9,  10,  12,  12,  12,  12,  12,  12,  12,  12,  12 } },
    [ 72] = { xi.evolith.prefix.VS_UNDEAD,                 xi.evolith.suffix.DEFENSE,                            {   2,   4,   6,   8,  10,  12,  15,  18,  18,  18,  18,  18,  18,  18,  18,  18 } },
    [ 73] = { xi.evolith.prefix.VS_UNDEAD,                 xi.evolith.suffix.ACCURACY,                           {   2,   3,   4,   5,   7,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [ 74] = { xi.evolith.prefix.VS_UNDEAD,                 xi.evolith.suffix.EVASION,                            {   3,   4,   5,   6,   8,  10,  13,  16,  16,  16,  16,  16,  16,  16,  16,  16 } },
    [ 75] = { xi.evolith.prefix.VS_UNDEAD,                 xi.evolith.suffix.MAGIC_ATTACK_BONUS,                 {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [ 76] = { xi.evolith.prefix.VS_UNDEAD,                 xi.evolith.suffix.MAGIC_DEFENSE_BONUS,                {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [ 77] = { xi.evolith.prefix.VS_UNDEAD,                 xi.evolith.suffix.MAGIC_ACCURACY,                     {   2,   2,   3,   4,   5,   6,   7,   9,   9,   9,   9,   9,   9,   9,   9,   9 } },
    [ 78] = { xi.evolith.prefix.VS_UNDEAD,                 xi.evolith.suffix.MAGIC_EVASION,                      {   2,   3,   4,   5,   7,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [ 79] = { xi.evolith.prefix.VS_UNDEAD,                 xi.evolith.suffix.RANGED_ATTACK,                      {   4,   5,   6,   7,   8,   9,  10,  12,  12,  12,  12,  12,  12,  12,  12,  12 } },
    [ 80] = { xi.evolith.prefix.VS_UNDEAD,                 xi.evolith.suffix.RANGED_ACCURACY,                    {   2,   3,   4,   5,   7,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [ 81] = { xi.evolith.prefix.VS_ELEMENTALS,             xi.evolith.suffix.ATTACK,                             {   4,   5,   6,   7,   8,   9,  10,  12,  12,  12,  12,  12,  12,  12,  12,  12 } },
    [ 82] = { xi.evolith.prefix.VS_ELEMENTALS,             xi.evolith.suffix.DEFENSE,                            {   2,   4,   6,   8,  10,  12,  15,  18,  18,  18,  18,  18,  18,  18,  18,  18 } },
    [ 83] = { xi.evolith.prefix.VS_ELEMENTALS,             xi.evolith.suffix.ACCURACY,                           {   2,   3,   4,   5,   7,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [ 84] = { xi.evolith.prefix.VS_ELEMENTALS,             xi.evolith.suffix.EVASION,                            {   3,   4,   5,   6,   8,  10,  13,  16,  16,  16,  16,  16,  16,  16,  16,  16 } },
    [ 85] = { xi.evolith.prefix.VS_ELEMENTALS,             xi.evolith.suffix.MAGIC_ATTACK_BONUS,                 {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [ 86] = { xi.evolith.prefix.VS_ELEMENTALS,             xi.evolith.suffix.MAGIC_DEFENSE_BONUS,                {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [ 87] = { xi.evolith.prefix.VS_ELEMENTALS,             xi.evolith.suffix.MAGIC_ACCURACY,                     {   2,   2,   3,   4,   5,   6,   7,   9,   9,   9,   9,   9,   9,   9,   9,   9 } },
    [ 88] = { xi.evolith.prefix.VS_ELEMENTALS,             xi.evolith.suffix.MAGIC_EVASION,                      {   2,   3,   4,   5,   7,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [ 89] = { xi.evolith.prefix.VS_ELEMENTALS,             xi.evolith.suffix.RANGED_ATTACK,                      {   4,   5,   6,   7,   8,   9,  10,  12,  12,  12,  12,  12,  12,  12,  12,  12 } },
    [ 90] = { xi.evolith.prefix.VS_ELEMENTALS,             xi.evolith.suffix.RANGED_ACCURACY,                    {   2,   3,   4,   5,   7,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [ 91] = { xi.evolith.prefix.VS_ARCANA,                 xi.evolith.suffix.ATTACK,                             {   4,   5,   6,   7,   8,   9,  10,  12,  12,  12,  12,  12,  12,  12,  12,  12 } },
    [ 92] = { xi.evolith.prefix.VS_ARCANA,                 xi.evolith.suffix.DEFENSE,                            {   2,   4,   6,   8,  10,  12,  15,  18,  18,  18,  18,  18,  18,  18,  18,  18 } },
    [ 93] = { xi.evolith.prefix.VS_ARCANA,                 xi.evolith.suffix.ACCURACY,                           {   2,   3,   4,   5,   7,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [ 94] = { xi.evolith.prefix.VS_ARCANA,                 xi.evolith.suffix.EVASION,                            {   3,   4,   5,   6,   8,  10,  13,  16,  16,  16,  16,  16,  16,  16,  16,  16 } },
    [ 95] = { xi.evolith.prefix.VS_ARCANA,                 xi.evolith.suffix.MAGIC_ATTACK_BONUS,                 {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [ 96] = { xi.evolith.prefix.VS_ARCANA,                 xi.evolith.suffix.MAGIC_DEFENSE_BONUS,                {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [ 97] = { xi.evolith.prefix.VS_ARCANA,                 xi.evolith.suffix.MAGIC_ACCURACY,                     {   2,   2,   3,   4,   5,   6,   7,   9,   9,   9,   9,   9,   9,   9,   9,   9 } },
    [ 98] = { xi.evolith.prefix.VS_ARCANA,                 xi.evolith.suffix.MAGIC_EVASION,                      {   2,   3,   4,   5,   7,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [ 99] = { xi.evolith.prefix.VS_ARCANA,                 xi.evolith.suffix.RANGED_ATTACK,                      {   4,   5,   6,   7,   8,   9,  10,  12,  12,  12,  12,  12,  12,  12,  12,  12 } },
    [100] = { xi.evolith.prefix.VS_ARCANA,                 xi.evolith.suffix.RANGED_ACCURACY,                    {   2,   3,   4,   5,   7,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [101] = { xi.evolith.prefix.VS_DEMONS,                 xi.evolith.suffix.ATTACK,                             {   4,   5,   6,   7,   8,   9,  10,  12,  12,  12,  12,  12,  12,  12,  12,  12 } },
    [102] = { xi.evolith.prefix.VS_DEMONS,                 xi.evolith.suffix.DEFENSE,                            {   2,   4,   6,   8,  10,  12,  15,  18,  18,  18,  18,  18,  18,  18,  18,  18 } },
    [103] = { xi.evolith.prefix.VS_DEMONS,                 xi.evolith.suffix.ACCURACY,                           {   2,   3,   4,   5,   7,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [104] = { xi.evolith.prefix.VS_DEMONS,                 xi.evolith.suffix.EVASION,                            {   3,   4,   5,   6,   8,  10,  13,  16,  16,  16,  16,  16,  16,  16,  16,  16 } },
    [105] = { xi.evolith.prefix.VS_DEMONS,                 xi.evolith.suffix.MAGIC_ATTACK_BONUS,                 {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [106] = { xi.evolith.prefix.VS_DEMONS,                 xi.evolith.suffix.MAGIC_DEFENSE_BONUS,                {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [107] = { xi.evolith.prefix.VS_DEMONS,                 xi.evolith.suffix.MAGIC_ACCURACY,                     {   2,   2,   3,   4,   5,   6,   7,   9,   9,   9,   9,   9,   9,   9,   9,   9 } },
    [108] = { xi.evolith.prefix.VS_DEMONS,                 xi.evolith.suffix.MAGIC_EVASION,                      {   2,   3,   4,   5,   7,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [109] = { xi.evolith.prefix.VS_DEMONS,                 xi.evolith.suffix.RANGED_ATTACK,                      {   4,   5,   6,   7,   8,   9,  10,  12,  12,  12,  12,  12,  12,  12,  12,  12 } },
    [110] = { xi.evolith.prefix.VS_DEMONS,                 xi.evolith.suffix.RANGED_ACCURACY,                    {   2,   3,   4,   5,   7,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [111] = { xi.evolith.prefix.VS_DRAGONS,                xi.evolith.suffix.ATTACK,                             {   4,   5,   6,   7,   8,   9,  10,  12,  12,  12,  12,  12,  12,  12,  12,  12 } },
    [112] = { xi.evolith.prefix.VS_DRAGONS,                xi.evolith.suffix.DEFENSE,                            {   2,   4,   6,   8,  10,  12,  15,  18,  18,  18,  18,  18,  18,  18,  18,  18 } },
    [113] = { xi.evolith.prefix.VS_DRAGONS,                xi.evolith.suffix.ACCURACY,                           {   2,   3,   4,   5,   7,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [114] = { xi.evolith.prefix.VS_DRAGONS,                xi.evolith.suffix.EVASION,                            {   3,   4,   5,   6,   8,  10,  13,  16,  16,  16,  16,  16,  16,  16,  16,  16 } },
    [115] = { xi.evolith.prefix.VS_DRAGONS,                xi.evolith.suffix.MAGIC_ATTACK_BONUS,                 {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [116] = { xi.evolith.prefix.VS_DRAGONS,                xi.evolith.suffix.MAGIC_DEFENSE_BONUS,                {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [117] = { xi.evolith.prefix.VS_DRAGONS,                xi.evolith.suffix.MAGIC_ACCURACY,                     {   2,   2,   3,   4,   5,   6,   7,   9,   9,   9,   9,   9,   9,   9,   9,   9 } },
    [118] = { xi.evolith.prefix.VS_DRAGONS,                xi.evolith.suffix.MAGIC_EVASION,                      {   2,   3,   4,   5,   7,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [119] = { xi.evolith.prefix.VS_DRAGONS,                xi.evolith.suffix.RANGED_ATTACK,                      {   4,   5,   6,   7,   8,   9,  10,  12,  12,  12,  12,  12,  12,  12,  12,  12 } },
    [120] = { xi.evolith.prefix.VS_DRAGONS,                xi.evolith.suffix.RANGED_ACCURACY,                    {   2,   3,   4,   5,   7,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [121] = { xi.evolith.prefix.VS_EMPTY,                  xi.evolith.suffix.ATTACK,                             {   4,   5,   6,   7,   8,   9,  10,  12,  12,  12,  12,  12,  12,  12,  12,  12 } },
    [122] = { xi.evolith.prefix.VS_EMPTY,                  xi.evolith.suffix.DEFENSE,                            {   2,   4,   6,   8,  10,  12,  15,  18,  18,  18,  18,  18,  18,  18,  18,  18 } },
    [123] = { xi.evolith.prefix.VS_EMPTY,                  xi.evolith.suffix.ACCURACY,                           {   2,   3,   4,   5,   7,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [124] = { xi.evolith.prefix.VS_EMPTY,                  xi.evolith.suffix.EVASION,                            {   3,   4,   5,   6,   8,  10,  13,  16,  16,  16,  16,  16,  16,  16,  16,  16 } },
    [125] = { xi.evolith.prefix.VS_EMPTY,                  xi.evolith.suffix.MAGIC_ATTACK_BONUS,                 {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [126] = { xi.evolith.prefix.VS_EMPTY,                  xi.evolith.suffix.MAGIC_DEFENSE_BONUS,                {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [127] = { xi.evolith.prefix.VS_EMPTY,                  xi.evolith.suffix.MAGIC_ACCURACY,                     {   2,   2,   3,   4,   5,   6,   7,   9,   9,   9,   9,   9,   9,   9,   9,   9 } },
    [128] = { xi.evolith.prefix.VS_EMPTY,                  xi.evolith.suffix.MAGIC_EVASION,                      {   2,   3,   4,   5,   7,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [129] = { xi.evolith.prefix.VS_EMPTY,                  xi.evolith.suffix.RANGED_ATTACK,                      {   4,   5,   6,   7,   8,   9,  10,  12,  12,  12,  12,  12,  12,  12,  12,  12 } },
    [130] = { xi.evolith.prefix.VS_EMPTY,                  xi.evolith.suffix.RANGED_ACCURACY,                    {   2,   3,   4,   5,   7,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [131] = { xi.evolith.prefix.VS_LUMINIANS,              xi.evolith.suffix.ATTACK,                             {   4,   5,   6,   7,   8,   9,  10,  12,  12,  12,  12,  12,  12,  12,  12,  12 } },
    [132] = { xi.evolith.prefix.VS_LUMINIANS,              xi.evolith.suffix.DEFENSE,                            {   2,   4,   6,   8,  10,  12,  15,  18,  18,  18,  18,  18,  18,  18,  18,  18 } },
    [133] = { xi.evolith.prefix.VS_LUMINIANS,              xi.evolith.suffix.ACCURACY,                           {   2,   3,   4,   5,   7,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [134] = { xi.evolith.prefix.VS_LUMINIANS,              xi.evolith.suffix.EVASION,                            {   3,   4,   5,   6,   8,  10,  13,  16,  16,  16,  16,  16,  16,  16,  16,  16 } },
    [135] = { xi.evolith.prefix.VS_LUMINIANS,              xi.evolith.suffix.MAGIC_ATTACK_BONUS,                 {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [136] = { xi.evolith.prefix.VS_LUMINIANS,              xi.evolith.suffix.MAGIC_DEFENSE_BONUS,                {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [137] = { xi.evolith.prefix.VS_LUMINIANS,              xi.evolith.suffix.MAGIC_ACCURACY,                     {   2,   2,   3,   4,   5,   6,   7,   9,   9,   9,   9,   9,   9,   9,   9,   9 } },
    [138] = { xi.evolith.prefix.VS_LUMINIANS,              xi.evolith.suffix.MAGIC_EVASION,                      {   2,   3,   4,   5,   7,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [139] = { xi.evolith.prefix.VS_LUMINIANS,              xi.evolith.suffix.RANGED_ATTACK,                      {   4,   5,   6,   7,   8,   9,  10,  12,  12,  12,  12,  12,  12,  12,  12,  12 } },
    [140] = { xi.evolith.prefix.VS_LUMINIANS,              xi.evolith.suffix.RANGED_ACCURACY,                    {   2,   3,   4,   5,   7,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [141] = { xi.evolith.prefix.MIGHTY_STRIKES,            xi.evolith.suffix.ABILITY_DELAY,                      {   1,   1,   1,   2,   2,   3,   3,   4,   4,   4,   4,   4,   4,   4,   4,   4 } },
    [142] = { xi.evolith.prefix.HUNDRED_FISTS,             xi.evolith.suffix.ABILITY_DELAY,                      {   1,   1,   1,   2,   2,   3,   3,   4,   4,   4,   4,   4,   4,   4,   4,   4 } },
    [143] = { xi.evolith.prefix.BENEDICTION,               xi.evolith.suffix.ABILITY_DELAY,                      {   1,   1,   1,   2,   2,   3,   3,   4,   4,   4,   4,   4,   4,   4,   4,   4 } },
    [144] = { xi.evolith.prefix.MANAFONT,                  xi.evolith.suffix.ABILITY_DELAY,                      {   1,   1,   1,   2,   2,   3,   3,   4,   4,   4,   4,   4,   4,   4,   4,   4 } },
    [145] = { xi.evolith.prefix.CHAINSPELL,                xi.evolith.suffix.ABILITY_DELAY,                      {   1,   1,   1,   2,   2,   3,   3,   4,   4,   4,   4,   4,   4,   4,   4,   4 } },
    [146] = { xi.evolith.prefix.PERFECT_DODGE,             xi.evolith.suffix.ABILITY_DELAY,                      {   1,   1,   1,   2,   2,   3,   3,   4,   4,   4,   4,   4,   4,   4,   4,   4 } },
    [147] = { xi.evolith.prefix.INVINCIBLE,                xi.evolith.suffix.ABILITY_DELAY,                      {   1,   1,   1,   2,   2,   3,   3,   4,   4,   4,   4,   4,   4,   4,   4,   4 } },
    [148] = { xi.evolith.prefix.BLOOD_WEAPON,              xi.evolith.suffix.ABILITY_DELAY,                      {   1,   1,   1,   2,   2,   3,   3,   4,   4,   4,   4,   4,   4,   4,   4,   4 } },
    [149] = { xi.evolith.prefix.FAMILIAR,                  xi.evolith.suffix.ABILITY_DELAY,                      {   1,   1,   1,   2,   2,   3,   3,   4,   4,   4,   4,   4,   4,   4,   4,   4 } },
    [150] = { xi.evolith.prefix.SOUL_VOICE,                xi.evolith.suffix.ABILITY_DELAY,                      {   1,   1,   1,   2,   2,   3,   3,   4,   4,   4,   4,   4,   4,   4,   4,   4 } },
    [151] = { xi.evolith.prefix.EAGLE_EYE_SHOT,            xi.evolith.suffix.ABILITY_DELAY,                      {   1,   1,   1,   2,   2,   3,   3,   4,   4,   4,   4,   4,   4,   4,   4,   4 } },
    [152] = { xi.evolith.prefix.MEIKYO_SHISUI,             xi.evolith.suffix.ABILITY_DELAY,                      {   1,   1,   1,   2,   2,   3,   3,   4,   4,   4,   4,   4,   4,   4,   4,   4 } },
    [153] = { xi.evolith.prefix.MIJIN_GAKURE,              xi.evolith.suffix.ABILITY_DELAY,                      {   1,   1,   1,   2,   2,   3,   3,   4,   4,   4,   4,   4,   4,   4,   4,   4 } },
    [154] = { xi.evolith.prefix.SPIRIT_SURGE,              xi.evolith.suffix.ABILITY_DELAY,                      {   1,   1,   1,   2,   2,   3,   3,   4,   4,   4,   4,   4,   4,   4,   4,   4 } },
    [155] = { xi.evolith.prefix.ASTRAL_FLOW,               xi.evolith.suffix.ABILITY_DELAY,                      {   1,   1,   1,   2,   2,   3,   3,   4,   4,   4,   4,   4,   4,   4,   4,   4 } },
    [156] = { xi.evolith.prefix.AZURE_LORE,                xi.evolith.suffix.ABILITY_DELAY,                      {   1,   1,   1,   2,   2,   3,   3,   4,   4,   4,   4,   4,   4,   4,   4,   4 } },
    [157] = { xi.evolith.prefix.WILD_CARD,                 xi.evolith.suffix.ABILITY_DELAY,                      {   1,   1,   1,   2,   2,   3,   3,   4,   4,   4,   4,   4,   4,   4,   4,   4 } },
    [158] = { xi.evolith.prefix.OVERDRIVE,                 xi.evolith.suffix.ABILITY_DELAY,                      {   1,   1,   1,   2,   2,   3,   3,   4,   4,   4,   4,   4,   4,   4,   4,   4 } },
    [159] = { xi.evolith.prefix.TRANCE,                    xi.evolith.suffix.ABILITY_DELAY,                      {   1,   1,   1,   2,   2,   3,   3,   4,   4,   4,   4,   4,   4,   4,   4,   4 } },
    [160] = { xi.evolith.prefix.TABULA_RASA,               xi.evolith.suffix.ABILITY_DELAY,                      {   1,   1,   1,   2,   2,   3,   3,   4,   4,   4,   4,   4,   4,   4,   4,   4 } },
    [161] = { xi.evolith.prefix.HAND_TO_HAND_WS,           xi.evolith.suffix.ENMITY,                             { 255, 255, 254, 253, 252, 251, 250, 248, 248, 248, 248, 248, 248, 248, 248, 248 } },
    [162] = { xi.evolith.prefix.HAND_TO_HAND_WS,           xi.evolith.suffix.TP_BONUS,                           {   2,   4,   6,   9,  12,  16,  20,  25,  25,  25,  25,  25,  25,  25,  25,  25 } },
    [163] = { xi.evolith.prefix.DAGGER_WS,                 xi.evolith.suffix.ATTACK,                             {   2,   4,   6,   9,  12,  16,  20,  25,  25,  25,  25,  25,  25,  25,  25,  25 } },
    [164] = { xi.evolith.prefix.DAGGER_WS,                 xi.evolith.suffix.TRIPLE_ATTACK,                      {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [165] = { xi.evolith.prefix.SWORD_WS,                  xi.evolith.suffix.ATTACK,                             {   2,   4,   6,   8,  11,  14,  17,  20,  20,  20,  20,  20,  20,  20,  20,  20 } },
    [166] = { xi.evolith.prefix.SWORD_WS,                  xi.evolith.suffix.CRITICAL_HIT_RATE,                  {   1,   1,   2,   3,   4,   5,   6,   8,   8,   8,   8,   8,   8,   8,   8,   8 } },
    [167] = { xi.evolith.prefix.GREAT_SWORD_WS,            xi.evolith.suffix.ACCURACY,                           {   1,   2,   4,   6,   8,  10,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [168] = { xi.evolith.prefix.GREAT_SWORD_WS,            xi.evolith.suffix.DOUBLE_ATTACK,                      {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [169] = { xi.evolith.prefix.AXE_WS,                    xi.evolith.suffix.ATTACK,                             {   2,   4,   6,   8,  11,  14,  17,  20,  20,  20,  20,  20,  20,  20,  20,  20 } },
    [170] = { xi.evolith.prefix.AXE_WS,                    xi.evolith.suffix.DOUBLE_ATTACK,                      {   1,   1,   2,   3,   4,   5,   6,   8,   8,   8,   8,   8,   8,   8,   8,   8 } },
    [171] = { xi.evolith.prefix.GREAT_AXE_WS,              xi.evolith.suffix.ACCURACY,                           {   1,   2,   4,   6,   8,  10,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [172] = { xi.evolith.prefix.GREAT_AXE_WS,              xi.evolith.suffix.TP_BONUS,                           {   2,   4,   6,   9,  12,  16,  20,  25,  25,  25,  25,  25,  25,  25,  25,  25 } },
    [173] = { xi.evolith.prefix.SCYTHE_WS,                 xi.evolith.suffix.ENMITY,                             { 255, 254, 253, 252, 251, 250, 248, 246, 246, 246, 246, 246, 246, 246, 246, 246 } },
    [174] = { xi.evolith.prefix.SCYTHE_WS,                 xi.evolith.suffix.SKILLCHAIN_DAMAGE,                  {   1,   2,   3,   4,   5,   6,   8,  10,  10,  10,  10,  10,  10,  10,  10,  10 } },
    [175] = { xi.evolith.prefix.POLEARM_WS,                xi.evolith.suffix.ACCURACY,                           {   1,   2,   4,   6,   8,  10,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [176] = { xi.evolith.prefix.POLEARM_WS,                xi.evolith.suffix.CRITICAL_HIT_RATE,                  {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [177] = { xi.evolith.prefix.KATANA_WS,                 xi.evolith.suffix.ENMITY,                             {   1,   2,   3,   4,   5,   6,   8,  10,  10,  10,  10,  10,  10,  10,  10,  10 } },
    [178] = { xi.evolith.prefix.KATANA_WS,                 xi.evolith.suffix.CRITICAL_HIT_RATE,                  {   1,   1,   2,   3,   4,   5,   6,   8,   8,   8,   8,   8,   8,   8,   8,   8 } },
    [179] = { xi.evolith.prefix.GREAT_KATANA_WS,           xi.evolith.suffix.ACCURACY,                           {   1,   2,   4,   6,   8,  10,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [180] = { xi.evolith.prefix.GREAT_KATANA_WS,           xi.evolith.suffix.SKILLCHAIN_DAMAGE,                  {   1,   1,   2,   3,   4,   5,   6,   8,   8,   8,   8,   8,   8,   8,   8,   8 } },
    [181] = { xi.evolith.prefix.CLUB_WS,                   xi.evolith.suffix.ATTACK,                             {   2,   4,   6,   9,  12,  16,  20,  25,  25,  25,  25,  25,  25,  25,  25,  25 } },
    [182] = { xi.evolith.prefix.CLUB_WS,                   xi.evolith.suffix.DOUBLE_ATTACK,                      {   1,   1,   2,   3,   4,   5,   6,   8,   8,   8,   8,   8,   8,   8,   8,   8 } },
    [183] = { xi.evolith.prefix.STAFF_WS,                  xi.evolith.suffix.ENMITY,                             { 255, 254, 253, 252, 251, 250, 248, 246, 246, 246, 246, 246, 246, 246, 246, 246 } },
    [184] = { xi.evolith.prefix.STAFF_WS,                  xi.evolith.suffix.TP_BONUS,                           {   2,   4,   6,   9,  12,  16,  20,  25,  25,  25,  25,  25,  25,  25,  25,  25 } },
    [185] = { xi.evolith.prefix.ARCHERY_WS,                xi.evolith.suffix.RANGED_ACCURACY,                    {   1,   2,   4,   6,   8,  10,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [186] = { xi.evolith.prefix.ARCHERY_WS,                xi.evolith.suffix.TP_BONUS,                           {   2,   4,   6,   9,  12,  16,  20,  25,  25,  25,  25,  25,  25,  25,  25,  25 } },
    [187] = { xi.evolith.prefix.MARKSMANSHIP_WS,           xi.evolith.suffix.RANGED_ATTACK,                      {   1,   2,   4,   6,   8,  10,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [188] = { xi.evolith.prefix.MARKSMANSHIP_WS,           xi.evolith.suffix.SKILLCHAIN_DAMAGE,                  {   1,   2,   3,   4,   5,   6,   8,  10,  10,  10,  10,  10,  10,  10,  10,  10 } },
    [189] = { xi.evolith.prefix.DIVINE_MAGIC_LIGHT,        xi.evolith.suffix.MAGIC_ACCURACY,                     {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [190] = { xi.evolith.prefix.DIVINE_MAGIC_LIGHT,        xi.evolith.suffix.RECAST_DELAY,                       {   2,   2,   2,   3,   3,   4,   5,   7,   7,   7,   7,   7,   7,   7,   7,   7 } },
    [191] = { xi.evolith.prefix.HEALING_MAGIC_LIGHT,       xi.evolith.suffix.ENMITY,                             { 255, 255, 255, 254, 254, 253, 252, 250, 250, 250, 250, 250, 250, 250, 250, 250 } },
    [192] = { xi.evolith.prefix.HEALING_MAGIC_LIGHT,       xi.evolith.suffix.CASTING_TIME,                       {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [193] = { xi.evolith.prefix.ENHANCING_MAGIC_FIRE,      xi.evolith.suffix.CONSERVE_MP,                        {   1,   1,   2,   3,   4,   5,   6,   8,   8,   8,   8,   8,   8,   8,   8,   8 } },
    [194] = { xi.evolith.prefix.ENHANCING_MAGIC_FIRE,      xi.evolith.suffix.RECAST_DELAY,                       {   2,   2,   2,   3,   3,   4,   5,   7,   7,   7,   7,   7,   7,   7,   7,   7 } },
    [195] = { xi.evolith.prefix.ENHANCING_MAGIC_ICE,       xi.evolith.suffix.CONSERVE_MP,                        {   1,   1,   2,   3,   4,   5,   6,   8,   8,   8,   8,   8,   8,   8,   8,   8 } },
    [196] = { xi.evolith.prefix.ENHANCING_MAGIC_ICE,       xi.evolith.suffix.RECAST_DELAY,                       {   2,   2,   2,   3,   3,   4,   5,   7,   7,   7,   7,   7,   7,   7,   7,   7 } },
    [197] = { xi.evolith.prefix.ENHANCING_MAGIC_WIND,      xi.evolith.suffix.CONSERVE_MP,                        {   1,   1,   2,   3,   4,   5,   6,   8,   8,   8,   8,   8,   8,   8,   8,   8 } },
    [198] = { xi.evolith.prefix.ENHANCING_MAGIC_WIND,      xi.evolith.suffix.RECAST_DELAY,                       {   2,   2,   2,   3,   3,   4,   5,   7,   7,   7,   7,   7,   7,   7,   7,   7 } },
    [199] = { xi.evolith.prefix.ENHANCING_MAGIC_EARTH,     xi.evolith.suffix.CONSERVE_MP,                        {   1,   1,   2,   3,   4,   5,   6,   8,   8,   8,   8,   8,   8,   8,   8,   8 } },
    [200] = { xi.evolith.prefix.ENHANCING_MAGIC_EARTH,     xi.evolith.suffix.RECAST_DELAY,                       {   2,   2,   2,   3,   3,   4,   5,   7,   7,   7,   7,   7,   7,   7,   7,   7 } },
    [201] = { xi.evolith.prefix.ENHANCING_MAGIC_LIGHTNING, xi.evolith.suffix.CONSERVE_MP,                        {   1,   1,   2,   3,   4,   5,   6,   8,   8,   8,   8,   8,   8,   8,   8,   8 } },
    [202] = { xi.evolith.prefix.ENHANCING_MAGIC_LIGHTNING, xi.evolith.suffix.RECAST_DELAY,                       {   2,   2,   2,   3,   3,   4,   5,   7,   7,   7,   7,   7,   7,   7,   7,   7 } },
    [203] = { xi.evolith.prefix.ENHANCING_MAGIC_WATER,     xi.evolith.suffix.CONSERVE_MP,                        {   1,   1,   2,   3,   4,   5,   6,   8,   8,   8,   8,   8,   8,   8,   8,   8 } },
    [204] = { xi.evolith.prefix.ENHANCING_MAGIC_WATER,     xi.evolith.suffix.RECAST_DELAY,                       {   2,   2,   2,   3,   3,   4,   5,   7,   7,   7,   7,   7,   7,   7,   7,   7 } },
    [205] = { xi.evolith.prefix.ENHANCING_MAGIC_LIGHT,     xi.evolith.suffix.CONSERVE_MP,                        {   1,   1,   2,   3,   4,   5,   6,   8,   8,   8,   8,   8,   8,   8,   8,   8 } },
    [206] = { xi.evolith.prefix.ENHANCING_MAGIC_LIGHT,     xi.evolith.suffix.RECAST_DELAY,                       {   2,   2,   2,   3,   3,   4,   5,   7,   7,   7,   7,   7,   7,   7,   7,   7 } },
    [207] = { xi.evolith.prefix.ENHANCING_MAGIC_DARK,      xi.evolith.suffix.CONSERVE_MP,                        {   1,   1,   2,   3,   4,   5,   6,   8,   8,   8,   8,   8,   8,   8,   8,   8 } },
    [208] = { xi.evolith.prefix.ENHANCING_MAGIC_DARK,      xi.evolith.suffix.RECAST_DELAY,                       {   2,   2,   2,   3,   3,   4,   5,   7,   7,   7,   7,   7,   7,   7,   7,   7 } },
    [209] = { xi.evolith.prefix.ENFEEBLING_MAGIC_FIRE,     xi.evolith.suffix.MAGIC_ACCURACY,                     {   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1 } },
    [210] = { xi.evolith.prefix.ENFEEBLING_MAGIC_FIRE,     xi.evolith.suffix.CASTING_TIME,                       {   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1 } },
    [211] = { xi.evolith.prefix.ENFEEBLING_MAGIC_ICE,      xi.evolith.suffix.MAGIC_ACCURACY,                     {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [212] = { xi.evolith.prefix.ENFEEBLING_MAGIC_ICE,      xi.evolith.suffix.CASTING_TIME,                       {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [213] = { xi.evolith.prefix.ENFEEBLING_MAGIC_WIND,     xi.evolith.suffix.MAGIC_ACCURACY,                     {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [214] = { xi.evolith.prefix.ENFEEBLING_MAGIC_WIND,     xi.evolith.suffix.CASTING_TIME,                       {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [215] = { xi.evolith.prefix.ENFEEBLING_MAGIC_EARTH,    xi.evolith.suffix.MAGIC_ACCURACY,                     {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [216] = { xi.evolith.prefix.ENFEEBLING_MAGIC_EARTH,    xi.evolith.suffix.CASTING_TIME,                       {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [217] = { xi.evolith.prefix.ENFEEBLING_MAGIC_EARTH,    xi.evolith.suffix.NONE,                               {   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1 } },
    [218] = { xi.evolith.prefix.ENFEEBLING_MAGIC_EARTH,    xi.evolith.suffix.NONE,                               {   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1 } },
    [219] = { xi.evolith.prefix.ENFEEBLING_MAGIC_WATER,    xi.evolith.suffix.MAGIC_ACCURACY,                     {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [220] = { xi.evolith.prefix.ENFEEBLING_MAGIC_WATER,    xi.evolith.suffix.CASTING_TIME,                       {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [221] = { xi.evolith.prefix.ENFEEBLING_MAGIC_LIGHT,    xi.evolith.suffix.MAGIC_ACCURACY,                     {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [222] = { xi.evolith.prefix.ENFEEBLING_MAGIC_LIGHT,    xi.evolith.suffix.CASTING_TIME,                       {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [223] = { xi.evolith.prefix.ENFEEBLING_MAGIC_DARK,     xi.evolith.suffix.MAGIC_ACCURACY,                     {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [224] = { xi.evolith.prefix.ENFEEBLING_MAGIC_DARK,     xi.evolith.suffix.CASTING_TIME,                       {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [225] = { xi.evolith.prefix.ELEMENTAL_MAGIC_FIRE,      xi.evolith.suffix.ENMITY,                             { 255, 255, 255, 254, 254, 253, 252, 250, 250, 250, 250, 250, 250, 250, 250, 250 } },
    [226] = { xi.evolith.prefix.ELEMENTAL_MAGIC_FIRE,      xi.evolith.suffix.MAGIC_CRITICAL_HIT_RATE,            {   1,   1,   2,   2,   3,   4,   5,   7,   7,   7,   7,   7,   7,   7,   7,   7 } },
    [227] = { xi.evolith.prefix.ELEMENTAL_MAGIC_ICE,       xi.evolith.suffix.ENMITY,                             { 255, 255, 255, 254, 254, 253, 252, 250, 250, 250, 250, 250, 250, 250, 250, 250 } },
    [228] = { xi.evolith.prefix.ELEMENTAL_MAGIC_ICE,       xi.evolith.suffix.MAGIC_CRITICAL_HIT_RATE,            {   1,   1,   2,   2,   3,   4,   5,   7,   7,   7,   7,   7,   7,   7,   7,   7 } },
    [229] = { xi.evolith.prefix.ELEMENTAL_MAGIC_WIND,      xi.evolith.suffix.ENMITY,                             { 255, 255, 255, 254, 254, 253, 252, 250, 250, 250, 250, 250, 250, 250, 250, 250 } },
    [230] = { xi.evolith.prefix.ELEMENTAL_MAGIC_WIND,      xi.evolith.suffix.MAGIC_CRITICAL_HIT_RATE,            {   1,   1,   2,   2,   3,   4,   5,   7,   7,   7,   7,   7,   7,   7,   7,   7 } },
    [231] = { xi.evolith.prefix.ELEMENTAL_MAGIC_EARTH,     xi.evolith.suffix.ENMITY,                             { 255, 255, 255, 254, 254, 253, 252, 250, 250, 250, 250, 250, 250, 250, 250, 250 } },
    [232] = { xi.evolith.prefix.ELEMENTAL_MAGIC_EARTH,     xi.evolith.suffix.MAGIC_CRITICAL_HIT_RATE,            {   1,   1,   2,   2,   3,   4,   5,   7,   7,   7,   7,   7,   7,   7,   7,   7 } },
    [233] = { xi.evolith.prefix.ELEMENTAL_MAGIC_LIGHTNING, xi.evolith.suffix.ENMITY,                             { 255, 255, 255, 254, 254, 253, 252, 250, 250, 250, 250, 250, 250, 250, 250, 250 } },
    [234] = { xi.evolith.prefix.ELEMENTAL_MAGIC_LIGHTNING, xi.evolith.suffix.MAGIC_CRITICAL_HIT_RATE,            {   1,   1,   2,   2,   3,   4,   5,   7,   7,   7,   7,   7,   7,   7,   7,   7 } },
    [235] = { xi.evolith.prefix.ELEMENTAL_MAGIC_WATER,     xi.evolith.suffix.ENMITY,                             { 255, 255, 255, 254, 254, 253, 252, 250, 250, 250, 250, 250, 250, 250, 250, 250 } },
    [236] = { xi.evolith.prefix.ELEMENTAL_MAGIC_WATER,     xi.evolith.suffix.MAGIC_CRITICAL_HIT_RATE,            {   1,   1,   2,   2,   3,   4,   5,   7,   7,   7,   7,   7,   7,   7,   7,   7 } },
    [237] = { xi.evolith.prefix.ELEMENTAL_MAGIC_LIGHT,     xi.evolith.suffix.ENMITY,                             { 255, 255, 255, 254, 254, 253, 252, 250, 250, 250, 250, 250, 250, 250, 250, 250 } },
    [238] = { xi.evolith.prefix.ELEMENTAL_MAGIC_LIGHT,     xi.evolith.suffix.MAGIC_CRITICAL_HIT_RATE,            {   1,   1,   2,   2,   3,   4,   5,   7,   7,   7,   7,   7,   7,   7,   7,   7 } },
    [239] = { xi.evolith.prefix.ELEMENTAL_MAGIC_DARK,      xi.evolith.suffix.ENMITY,                             { 255, 255, 255, 254, 254, 253, 252, 250, 250, 250, 250, 250, 250, 250, 250, 250 } },
    [240] = { xi.evolith.prefix.ELEMENTAL_MAGIC_DARK,      xi.evolith.suffix.MAGIC_CRITICAL_HIT_RATE,            {   1,   1,   2,   2,   3,   4,   5,   7,   7,   7,   7,   7,   7,   7,   7,   7 } },
    [241] = { xi.evolith.prefix.DARK_MAGIC_DARK,           xi.evolith.suffix.MAGIC_ACCURACY,                     {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [242] = { xi.evolith.prefix.DARK_MAGIC_DARK,           xi.evolith.suffix.RECAST_DELAY,                       {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [243] = { xi.evolith.prefix.SONGS_FIRE,                xi.evolith.suffix.ENMITY,                             { 255, 255, 255, 254, 254, 253, 252, 250, 250, 250, 250, 250, 250, 250, 250, 250 } },
    [244] = { xi.evolith.prefix.SONGS_FIRE,                xi.evolith.suffix.CASTING_TIME,                       {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [245] = { xi.evolith.prefix.SONGS_ICE,                 xi.evolith.suffix.ENMITY,                             { 255, 255, 255, 254, 254, 253, 252, 250, 250, 250, 250, 250, 250, 250, 250, 250 } },
    [246] = { xi.evolith.prefix.SONGS_ICE,                 xi.evolith.suffix.CASTING_TIME,                       {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [247] = { xi.evolith.prefix.SONGS_WIND,                xi.evolith.suffix.ENMITY,                             { 255, 255, 255, 254, 254, 253, 252, 250, 250, 250, 250, 250, 250, 250, 250, 250 } },
    [248] = { xi.evolith.prefix.SONGS_WIND,                xi.evolith.suffix.CASTING_TIME,                       {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [249] = { xi.evolith.prefix.SONGS_EARTH,               xi.evolith.suffix.ENMITY,                             { 255, 255, 255, 254, 254, 253, 252, 250, 250, 250, 250, 250, 250, 250, 250, 250 } },
    [250] = { xi.evolith.prefix.SONGS_EARTH,               xi.evolith.suffix.CASTING_TIME,                       {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [251] = { xi.evolith.prefix.SONGS_LIGHTNING,           xi.evolith.suffix.ENMITY,                             { 255, 255, 255, 254, 254, 253, 252, 250, 250, 250, 250, 250, 250, 250, 250, 250 } },
    [252] = { xi.evolith.prefix.SONGS_LIGHTNING,           xi.evolith.suffix.CASTING_TIME,                       {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [253] = { xi.evolith.prefix.SONGS_WATER,               xi.evolith.suffix.ENMITY,                             { 255, 255, 255, 254, 254, 253, 252, 250, 250, 250, 250, 250, 250, 250, 250, 250 } },
    [254] = { xi.evolith.prefix.SONGS_WATER,               xi.evolith.suffix.CASTING_TIME,                       {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [255] = { xi.evolith.prefix.SONGS_LIGHT,               xi.evolith.suffix.ENMITY,                             { 255, 255, 255, 254, 254, 253, 252, 250, 250, 250, 250, 250, 250, 250, 250, 250 } },
    [256] = { xi.evolith.prefix.SONGS_LIGHT,               xi.evolith.suffix.CASTING_TIME,                       {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [257] = { xi.evolith.prefix.SONGS_DARK,                xi.evolith.suffix.ENMITY,                             { 255, 255, 255, 254, 254, 253, 252, 250, 250, 250, 250, 250, 250, 250, 250, 250 } },
    [258] = { xi.evolith.prefix.SONGS_DARK,                xi.evolith.suffix.CASTING_TIME,                       {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [259] = { xi.evolith.prefix.NINJUTSU_FIRE,             xi.evolith.suffix.ENMITY,                             {   1,   1,   2,   2,   3,   4,   5,   7,   7,   7,   7,   7,   7,   7,   7,   7 } },
    [260] = { xi.evolith.prefix.NINJUTSU_FIRE,             xi.evolith.suffix.MAGIC_ACCURACY,                     {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [261] = { xi.evolith.prefix.NINJUTSU_ICE,              xi.evolith.suffix.ENMITY,                             {   1,   1,   2,   2,   3,   4,   5,   7,   7,   7,   7,   7,   7,   7,   7,   7 } },
    [262] = { xi.evolith.prefix.NINJUTSU_ICE,              xi.evolith.suffix.MAGIC_ACCURACY,                     {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [263] = { xi.evolith.prefix.NINJUTSU_WIND,             xi.evolith.suffix.ENMITY,                             {   1,   1,   2,   2,   3,   4,   5,   7,   7,   7,   7,   7,   7,   7,   7,   7 } },
    [264] = { xi.evolith.prefix.NINJUTSU_WIND,             xi.evolith.suffix.MAGIC_ACCURACY,                     {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [265] = { xi.evolith.prefix.NINJUTSU_EARTH,            xi.evolith.suffix.ENMITY,                             {   1,   1,   2,   2,   3,   4,   5,   7,   7,   7,   7,   7,   7,   7,   7,   7 } },
    [266] = { xi.evolith.prefix.NINJUTSU_EARTH,            xi.evolith.suffix.MAGIC_ACCURACY,                     {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [267] = { xi.evolith.prefix.NINJUTSU_LIGHTNING,        xi.evolith.suffix.ENMITY,                             {   1,   1,   2,   2,   3,   4,   5,   7,   7,   7,   7,   7,   7,   7,   7,   7 } },
    [268] = { xi.evolith.prefix.NINJUTSU_LIGHTNING,        xi.evolith.suffix.MAGIC_ACCURACY,                     {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [269] = { xi.evolith.prefix.NINJUTSU_WATER,            xi.evolith.suffix.ENMITY,                             {   1,   1,   2,   2,   3,   4,   5,   7,   7,   7,   7,   7,   7,   7,   7,   7 } },
    [270] = { xi.evolith.prefix.NINJUTSU_WATER,            xi.evolith.suffix.MAGIC_ACCURACY,                     {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [271] = { xi.evolith.prefix.NINJUTSU_LIGHT,            xi.evolith.suffix.ENMITY,                             {   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1 } },
    [272] = { xi.evolith.prefix.NINJUTSU_LIGHT,            xi.evolith.suffix.MAGIC_ACCURACY,                     {   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1 } },
    [273] = { xi.evolith.prefix.NINJUTSU_DARK,             xi.evolith.suffix.ENMITY,                             {   1,   1,   2,   2,   3,   4,   5,   7,   7,   7,   7,   7,   7,   7,   7,   7 } },
    [274] = { xi.evolith.prefix.NINJUTSU_DARK,             xi.evolith.suffix.MAGIC_ACCURACY,                     {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [275] = { xi.evolith.prefix.BLUE_MAGIC_FIRE,           xi.evolith.suffix.MAGIC_ACCURACY,                     {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [276] = { xi.evolith.prefix.BLUE_MAGIC_FIRE,           xi.evolith.suffix.MAGIC_ATTACK_BONUS,                 {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [277] = { xi.evolith.prefix.BLUE_MAGIC_ICE,            xi.evolith.suffix.MAGIC_ACCURACY,                     {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [278] = { xi.evolith.prefix.BLUE_MAGIC_ICE,            xi.evolith.suffix.MAGIC_ATTACK_BONUS,                 {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [279] = { xi.evolith.prefix.BLUE_MAGIC_WIND,           xi.evolith.suffix.MAGIC_ACCURACY,                     {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [280] = { xi.evolith.prefix.BLUE_MAGIC_WIND,           xi.evolith.suffix.MAGIC_ATTACK_BONUS,                 {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [281] = { xi.evolith.prefix.BLUE_MAGIC_EARTH,          xi.evolith.suffix.MAGIC_ACCURACY,                     {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [282] = { xi.evolith.prefix.BLUE_MAGIC_EARTH,          xi.evolith.suffix.MAGIC_ATTACK_BONUS,                 {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [283] = { xi.evolith.prefix.BLUE_MAGIC_LIGHTNING,      xi.evolith.suffix.MAGIC_ACCURACY,                     {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [284] = { xi.evolith.prefix.BLUE_MAGIC_LIGHTNING,      xi.evolith.suffix.MAGIC_ATTACK_BONUS,                 {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [285] = { xi.evolith.prefix.BLUE_MAGIC_WATER,          xi.evolith.suffix.MAGIC_ACCURACY,                     {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [286] = { xi.evolith.prefix.BLUE_MAGIC_WATER,          xi.evolith.suffix.MAGIC_ATTACK_BONUS,                 {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [287] = { xi.evolith.prefix.BLUE_MAGIC_LIGHT,          xi.evolith.suffix.MAGIC_ACCURACY,                     {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [288] = { xi.evolith.prefix.BLUE_MAGIC_LIGHT,          xi.evolith.suffix.MAGIC_ATTACK_BONUS,                 {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [289] = { xi.evolith.prefix.BLUE_MAGIC_DARK,           xi.evolith.suffix.MAGIC_ACCURACY,                     {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [290] = { xi.evolith.prefix.BLUE_MAGIC_DARK,           xi.evolith.suffix.MAGIC_ATTACK_BONUS,                 {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [291] = { xi.evolith.prefix.BLUE_MAGIC_PHYSICAL,       xi.evolith.suffix.ATTACK,                             {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [292] = { xi.evolith.prefix.BLUE_MAGIC_PHYSICAL,       xi.evolith.suffix.ACCURACY,                           {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [293] = { xi.evolith.prefix.WEATHER_FIRE,              xi.evolith.suffix.ADDITIONAL_EFFECT_DISEASE,          {   1,   1,   2,   3,   4,   6,   8,  10,  10,  10,  10,  10,  10,  10,  10,  10 } },
    [294] = { xi.evolith.prefix.WEATHER_ICE,               xi.evolith.suffix.ADDITIONAL_EFFECT_PARALYSIS,        {   1,   1,   2,   3,   4,   6,   8,  10,  10,  10,  10,  10,  10,  10,  10,  10 } },
    [295] = { xi.evolith.prefix.WEATHER_WIND,              xi.evolith.suffix.ADDITIONAL_EFFECT_SILENCE,          {   1,   1,   2,   3,   4,   6,   8,  10,  10,  10,  10,  10,  10,  10,  10,  10 } },
    [296] = { xi.evolith.prefix.WEATHER_EARTH,             xi.evolith.suffix.ADDITIONAL_EFFECT_SLOW,             {   1,   1,   2,   3,   4,   6,   8,  10,  10,  10,  10,  10,  10,  10,  10,  10 } },
    [297] = { xi.evolith.prefix.WEATHER_LIGHTNING,         xi.evolith.suffix.ADDITIONAL_EFFECT_STUN,             {   1,   1,   1,   2,   2,   3,   4,   5,   5,   5,   5,   5,   5,   5,   5,   5 } },
    [298] = { xi.evolith.prefix.WEATHER_WATER,             xi.evolith.suffix.ADDITIONAL_EFFECT_POISON,           {   1,   1,   1,   2,   2,   3,   4,   5,   5,   5,   5,   5,   5,   5,   5,   5 } },
    [299] = { xi.evolith.prefix.WEATHER_LIGHT,             xi.evolith.suffix.ADDITIONAL_EFFECT_DEFENSE_DOWN,     {   3,   4,   5,   6,   7,   8,  10,  12,  12,  12,  12,  12,  12,  12,  12,  12 } },
    [300] = { xi.evolith.prefix.WEATHER_DARK,              xi.evolith.suffix.ADDITIONAL_EFFECT_SLEEP,            {   1,   1,   2,   3,   4,   6,   8,  10,  10,  10,  10,  10,  10,  10,  10,  10 } },
    [301] = { xi.evolith.prefix.WEATHER_FIRE,              xi.evolith.suffix.ADDITIONAL_EFFECT_FIRE_DAMAGE,      {   1,   1,   2,   4,   6,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [302] = { xi.evolith.prefix.WEATHER_ICE,               xi.evolith.suffix.ADDITIONAL_EFFECT_ICE_DAMAGE,       {   1,   1,   2,   4,   6,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [303] = { xi.evolith.prefix.WEATHER_WIND,              xi.evolith.suffix.ADDITIONAL_EFFECT_WIND_DAMAGE,      {   1,   1,   2,   4,   6,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [304] = { xi.evolith.prefix.WEATHER_EARTH,             xi.evolith.suffix.ADDITIONAL_EFFECT_EARTH_DAMAGE,     {   1,   1,   2,   4,   6,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [305] = { xi.evolith.prefix.WEATHER_LIGHTNING,         xi.evolith.suffix.ADDITIONAL_EFFECT_LIGHTNING_DAMAGE, {   1,   1,   2,   4,   6,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [306] = { xi.evolith.prefix.WEATHER_WATER,             xi.evolith.suffix.ADDITIONAL_EFFECT_WATER_DAMAGE,     {   1,   1,   2,   4,   6,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [307] = { xi.evolith.prefix.WEATHER_LIGHT,             xi.evolith.suffix.ADDITIONAL_EFFECT_LIGHT_DAMAGE,     {   1,   1,   2,   4,   6,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [308] = { xi.evolith.prefix.WEATHER_DARK,              xi.evolith.suffix.ADDITIONAL_EFFECT_DARK_DAMAGE,      {   1,   1,   2,   4,   6,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [309] = { xi.evolith.prefix.NONE,                      xi.evolith.suffix.HP,                                 {   2,   4,   6,   9,  12,  16,  20,  25,  25,  25,  25,  25,  25,  25,  25,  25 } },
    [310] = { xi.evolith.prefix.NONE,                      xi.evolith.suffix.MP,                                 {   2,   4,   6,   8,  11,  14,  17,  20,  20,  20,  20,  20,  20,  20,  20,  20 } },
    [311] = { xi.evolith.prefix.NONE,                      xi.evolith.suffix.RESIST_VIRUS,                       {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [312] = { xi.evolith.prefix.NONE,                      xi.evolith.suffix.RESIST_SLOW,                        {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [313] = { xi.evolith.prefix.NONE,                      xi.evolith.suffix.RESIST_SILENCE,                     {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [314] = { xi.evolith.prefix.NONE,                      xi.evolith.suffix.RESIST_PARALYZE,                    {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [315] = { xi.evolith.prefix.NONE,                      xi.evolith.suffix.RESIST_GRAVITY,                     {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [316] = { xi.evolith.prefix.NONE,                      xi.evolith.suffix.RESIST_PETRIFY,                     {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [317] = { xi.evolith.prefix.NONE,                      xi.evolith.suffix.RESIST_SLEEP,                       {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [318] = { xi.evolith.prefix.NONE,                      xi.evolith.suffix.RESIST_POISON,                      {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [319] = { xi.evolith.prefix.NONE,                      xi.evolith.suffix.RESIST_BIND,                        {   1,   1,   1,   2,   2,   3,   4,   6,   6,   6,   6,   6,   6,   6,   6,   6 } },
    [320] = { xi.evolith.prefix.SKILLCHAIN_LIGHT,          xi.evolith.suffix.SKILLCHAIN_DAMAGE,                  {   1,   1,   2,   3,   4,   6,   8,  10,  10,  10,  10,  10,  10,  10,  10,  10 } },
    [321] = { xi.evolith.prefix.SKILLCHAIN_DARK,           xi.evolith.suffix.SKILLCHAIN_DAMAGE,                  {   1,   1,   2,   3,   4,   6,   8,  10,  10,  10,  10,  10,  10,  10,  10,  10 } },
    [322] = { xi.evolith.prefix.SKILLCHAIN_LIGHT,          xi.evolith.suffix.SKILLCHAIN_ACCURACY,                {   1,   1,   2,   4,   6,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [323] = { xi.evolith.prefix.SKILLCHAIN_DARK,           xi.evolith.suffix.SKILLCHAIN_ACCURACY,                {   1,   1,   2,   4,   6,   9,  12,  15,  15,  15,  15,  15,  15,  15,  15,  15 } },
    [324] = { xi.evolith.prefix.SKILLCHAIN_LIGHT,          xi.evolith.suffix.MAGIC_BURST_DAMAGE,                 {   1,   1,   2,   3,   4,   6,   8,  10,  10,  10,  10,  10,  10,  10,  10,  10 } },
    [325] = { xi.evolith.prefix.SKILLCHAIN_DARK,           xi.evolith.suffix.MAGIC_BURST_DAMAGE,                 {   1,   1,   2,   3,   4,   6,   8,  10,  10,  10,  10,  10,  10,  10,  10,  10 } },
}

-- Table used to look up the Evolith augment ID to assign to an Evolith at rewards time
---@type table<xi.evolith.prefix, table<xi.evolith.suffix, integer>>
xi.data.augments.evolithIndex =
{
    [xi.evolith.prefix.VS_BEASTS] =
    {
        [xi.evolith.suffix.ATTACK             ] =  1,
        [xi.evolith.suffix.DEFENSE            ] =  2,
        [xi.evolith.suffix.ACCURACY           ] =  3,
        [xi.evolith.suffix.EVASION            ] =  4,
        [xi.evolith.suffix.MAGIC_ATTACK_BONUS ] =  5,
        [xi.evolith.suffix.MAGIC_DEFENSE_BONUS] =  6,
        [xi.evolith.suffix.MAGIC_ACCURACY     ] =  7,
        [xi.evolith.suffix.MAGIC_EVASION      ] =  8,
        [xi.evolith.suffix.RANGED_ATTACK      ] =  9,
        [xi.evolith.suffix.RANGED_ACCURACY    ] = 10,
    },

    [xi.evolith.prefix.VS_PLANTOIDS] =
    {
        [xi.evolith.suffix.ATTACK             ] = 11,
        [xi.evolith.suffix.DEFENSE            ] = 12,
        [xi.evolith.suffix.ACCURACY           ] = 13,
        [xi.evolith.suffix.EVASION            ] = 14,
        [xi.evolith.suffix.MAGIC_ATTACK_BONUS ] = 15,
        [xi.evolith.suffix.MAGIC_DEFENSE_BONUS] = 16,
        [xi.evolith.suffix.MAGIC_ACCURACY     ] = 17,
        [xi.evolith.suffix.MAGIC_EVASION      ] = 18,
        [xi.evolith.suffix.RANGED_ATTACK      ] = 19,
        [xi.evolith.suffix.RANGED_ACCURACY    ] = 20,
    },

    [xi.evolith.prefix.VS_VERMIN] =
    {
        [xi.evolith.suffix.ATTACK             ] = 21,
        [xi.evolith.suffix.DEFENSE            ] = 22,
        [xi.evolith.suffix.ACCURACY           ] = 23,
        [xi.evolith.suffix.EVASION            ] = 24,
        [xi.evolith.suffix.MAGIC_ATTACK_BONUS ] = 25,
        [xi.evolith.suffix.MAGIC_DEFENSE_BONUS] = 26,
        [xi.evolith.suffix.MAGIC_ACCURACY     ] = 27,
        [xi.evolith.suffix.MAGIC_EVASION      ] = 28,
        [xi.evolith.suffix.RANGED_ATTACK      ] = 29,
        [xi.evolith.suffix.RANGED_ACCURACY    ] = 30,
    },

    [xi.evolith.prefix.VS_LIZARDS] =
    {
        [xi.evolith.suffix.ATTACK             ] = 31,
        [xi.evolith.suffix.DEFENSE            ] = 32,
        [xi.evolith.suffix.ACCURACY           ] = 33,
        [xi.evolith.suffix.EVASION            ] = 34,
        [xi.evolith.suffix.MAGIC_ATTACK_BONUS ] = 35,
        [xi.evolith.suffix.MAGIC_DEFENSE_BONUS] = 36,
        [xi.evolith.suffix.MAGIC_ACCURACY     ] = 37,
        [xi.evolith.suffix.MAGIC_EVASION      ] = 38,
        [xi.evolith.suffix.RANGED_ATTACK      ] = 39,
        [xi.evolith.suffix.RANGED_ACCURACY    ] = 40,
    },

    [xi.evolith.prefix.VS_BIRDS] =
    {
        [xi.evolith.suffix.ATTACK             ] = 41,
        [xi.evolith.suffix.DEFENSE            ] = 42,
        [xi.evolith.suffix.ACCURACY           ] = 43,
        [xi.evolith.suffix.EVASION            ] = 44,
        [xi.evolith.suffix.MAGIC_ATTACK_BONUS ] = 45,
        [xi.evolith.suffix.MAGIC_DEFENSE_BONUS] = 46,
        [xi.evolith.suffix.MAGIC_ACCURACY     ] = 47,
        [xi.evolith.suffix.MAGIC_EVASION      ] = 48,
        [xi.evolith.suffix.RANGED_ATTACK      ] = 49,
        [xi.evolith.suffix.RANGED_ACCURACY    ] = 50,
    },

    [xi.evolith.prefix.VS_AMORPHS] =
    {
        [xi.evolith.suffix.ATTACK             ] = 51,
        [xi.evolith.suffix.DEFENSE            ] = 52,
        [xi.evolith.suffix.ACCURACY           ] = 53,
        [xi.evolith.suffix.EVASION            ] = 54,
        [xi.evolith.suffix.MAGIC_ATTACK_BONUS ] = 55,
        [xi.evolith.suffix.MAGIC_DEFENSE_BONUS] = 56,
        [xi.evolith.suffix.MAGIC_ACCURACY     ] = 57,
        [xi.evolith.suffix.MAGIC_EVASION      ] = 58,
        [xi.evolith.suffix.RANGED_ATTACK      ] = 59,
        [xi.evolith.suffix.RANGED_ACCURACY    ] = 60,
    },

    [xi.evolith.prefix.VS_AQUANS] =
    {
        [xi.evolith.suffix.ATTACK             ] = 61,
        [xi.evolith.suffix.DEFENSE            ] = 62,
        [xi.evolith.suffix.ACCURACY           ] = 63,
        [xi.evolith.suffix.EVASION            ] = 64,
        [xi.evolith.suffix.MAGIC_ATTACK_BONUS ] = 65,
        [xi.evolith.suffix.MAGIC_DEFENSE_BONUS] = 66,
        [xi.evolith.suffix.MAGIC_ACCURACY     ] = 67,
        [xi.evolith.suffix.MAGIC_EVASION      ] = 68,
        [xi.evolith.suffix.RANGED_ATTACK      ] = 69,
        [xi.evolith.suffix.RANGED_ACCURACY    ] = 70,
    },

    [xi.evolith.prefix.VS_UNDEAD] =
    {
        [xi.evolith.suffix.ATTACK             ] = 71,
        [xi.evolith.suffix.DEFENSE            ] = 72,
        [xi.evolith.suffix.ACCURACY           ] = 73,
        [xi.evolith.suffix.EVASION            ] = 74,
        [xi.evolith.suffix.MAGIC_ATTACK_BONUS ] = 75,
        [xi.evolith.suffix.MAGIC_DEFENSE_BONUS] = 76,
        [xi.evolith.suffix.MAGIC_ACCURACY     ] = 77,
        [xi.evolith.suffix.MAGIC_EVASION      ] = 78,
        [xi.evolith.suffix.RANGED_ATTACK      ] = 79,
        [xi.evolith.suffix.RANGED_ACCURACY    ] = 80,
    },

    [xi.evolith.prefix.VS_ELEMENTALS] =
    {
        [xi.evolith.suffix.ATTACK             ] = 81,
        [xi.evolith.suffix.DEFENSE            ] = 82,
        [xi.evolith.suffix.ACCURACY           ] = 83,
        [xi.evolith.suffix.EVASION            ] = 84,
        [xi.evolith.suffix.MAGIC_ATTACK_BONUS ] = 85,
        [xi.evolith.suffix.MAGIC_DEFENSE_BONUS] = 86,
        [xi.evolith.suffix.MAGIC_ACCURACY     ] = 87,
        [xi.evolith.suffix.MAGIC_EVASION      ] = 88,
        [xi.evolith.suffix.RANGED_ATTACK      ] = 89,
        [xi.evolith.suffix.RANGED_ACCURACY    ] = 90,
    },

    [xi.evolith.prefix.VS_ARCANA] =
    {
        [xi.evolith.suffix.ATTACK             ] =  91,
        [xi.evolith.suffix.DEFENSE            ] =  92,
        [xi.evolith.suffix.ACCURACY           ] =  93,
        [xi.evolith.suffix.EVASION            ] =  94,
        [xi.evolith.suffix.MAGIC_ATTACK_BONUS ] =  95,
        [xi.evolith.suffix.MAGIC_DEFENSE_BONUS] =  96,
        [xi.evolith.suffix.MAGIC_ACCURACY     ] =  97,
        [xi.evolith.suffix.MAGIC_EVASION      ] =  98,
        [xi.evolith.suffix.RANGED_ATTACK      ] =  99,
        [xi.evolith.suffix.RANGED_ACCURACY    ] = 100,
    },

    [xi.evolith.prefix.VS_DEMONS] =
    {
        [xi.evolith.suffix.ATTACK             ] = 101,
        [xi.evolith.suffix.DEFENSE            ] = 102,
        [xi.evolith.suffix.ACCURACY           ] = 103,
        [xi.evolith.suffix.EVASION            ] = 104,
        [xi.evolith.suffix.MAGIC_ATTACK_BONUS ] = 105,
        [xi.evolith.suffix.MAGIC_DEFENSE_BONUS] = 106,
        [xi.evolith.suffix.MAGIC_ACCURACY     ] = 107,
        [xi.evolith.suffix.MAGIC_EVASION      ] = 108,
        [xi.evolith.suffix.RANGED_ATTACK      ] = 109,
        [xi.evolith.suffix.RANGED_ACCURACY    ] = 110,
    },

    [xi.evolith.prefix.VS_DRAGONS] =
    {
        [xi.evolith.suffix.ATTACK             ] = 111,
        [xi.evolith.suffix.DEFENSE            ] = 112,
        [xi.evolith.suffix.ACCURACY           ] = 113,
        [xi.evolith.suffix.EVASION            ] = 114,
        [xi.evolith.suffix.MAGIC_ATTACK_BONUS ] = 115,
        [xi.evolith.suffix.MAGIC_DEFENSE_BONUS] = 116,
        [xi.evolith.suffix.MAGIC_ACCURACY     ] = 117,
        [xi.evolith.suffix.MAGIC_EVASION      ] = 118,
        [xi.evolith.suffix.RANGED_ATTACK      ] = 119,
        [xi.evolith.suffix.RANGED_ACCURACY    ] = 120,
    },

    [xi.evolith.prefix.VS_EMPTY] =
    {
        [xi.evolith.suffix.ATTACK             ] = 121,
        [xi.evolith.suffix.DEFENSE            ] = 122,
        [xi.evolith.suffix.ACCURACY           ] = 123,
        [xi.evolith.suffix.EVASION            ] = 124,
        [xi.evolith.suffix.MAGIC_ATTACK_BONUS ] = 125,
        [xi.evolith.suffix.MAGIC_DEFENSE_BONUS] = 126,
        [xi.evolith.suffix.MAGIC_ACCURACY     ] = 127,
        [xi.evolith.suffix.MAGIC_EVASION      ] = 128,
        [xi.evolith.suffix.RANGED_ATTACK      ] = 129,
        [xi.evolith.suffix.RANGED_ACCURACY    ] = 130,
    },

    [xi.evolith.prefix.VS_LUMINIANS] =
    {
        [xi.evolith.suffix.ATTACK             ] = 131,
        [xi.evolith.suffix.DEFENSE            ] = 132,
        [xi.evolith.suffix.ACCURACY           ] = 133,
        [xi.evolith.suffix.EVASION            ] = 134,
        [xi.evolith.suffix.MAGIC_ATTACK_BONUS ] = 135,
        [xi.evolith.suffix.MAGIC_DEFENSE_BONUS] = 136,
        [xi.evolith.suffix.MAGIC_ACCURACY     ] = 137,
        [xi.evolith.suffix.MAGIC_EVASION      ] = 138,
        [xi.evolith.suffix.RANGED_ATTACK      ] = 139,
        [xi.evolith.suffix.RANGED_ACCURACY    ] = 140,
    },

    [xi.evolith.prefix.MIGHTY_STRIKES] =
    {
        [xi.evolith.suffix.ABILITY_DELAY] = 141,
    },

    [xi.evolith.prefix.HUNDRED_FISTS] =
    {
        [xi.evolith.suffix.ABILITY_DELAY] = 142,
    },

    [xi.evolith.prefix.BENEDICTION] =
    {
        [xi.evolith.suffix.ABILITY_DELAY] = 143,
    },

    [xi.evolith.prefix.MANAFONT] =
    {
        [xi.evolith.suffix.ABILITY_DELAY] = 144,
    },

    [xi.evolith.prefix.CHAINSPELL] =
    {
        [xi.evolith.suffix.ABILITY_DELAY] = 145,
    },

    [xi.evolith.prefix.PERFECT_DODGE] =
    {
        [xi.evolith.suffix.ABILITY_DELAY] = 146,
    },

    [xi.evolith.prefix.INVINCIBLE] =
    {
        [xi.evolith.suffix.ABILITY_DELAY] = 147,
    },

    [xi.evolith.prefix.BLOOD_WEAPON] =
    {
        [xi.evolith.suffix.ABILITY_DELAY] = 148,
    },

    [xi.evolith.prefix.FAMILIAR] =
    {
        [xi.evolith.suffix.ABILITY_DELAY] = 149,
    },

    [xi.evolith.prefix.SOUL_VOICE] =
    {
        [xi.evolith.suffix.ABILITY_DELAY] = 150,
    },

    [xi.evolith.prefix.EAGLE_EYE_SHOT] =
    {
        [xi.evolith.suffix.ABILITY_DELAY] = 151,
    },

    [xi.evolith.prefix.MEIKYO_SHISUI] =
    {
        [xi.evolith.suffix.ABILITY_DELAY] = 152,
    },

    [xi.evolith.prefix.MIJIN_GAKURE] =
    {
        [xi.evolith.suffix.ABILITY_DELAY] = 153,
    },

    [xi.evolith.prefix.SPIRIT_SURGE] =
    {
        [xi.evolith.suffix.ABILITY_DELAY] = 154,
    },

    [xi.evolith.prefix.ASTRAL_FLOW] =
    {
        [xi.evolith.suffix.ABILITY_DELAY] = 155,
    },

    [xi.evolith.prefix.AZURE_LORE] =
    {
        [xi.evolith.suffix.ABILITY_DELAY] = 156,
    },

    [xi.evolith.prefix.WILD_CARD] =
    {
        [xi.evolith.suffix.ABILITY_DELAY] = 157,
    },

    [xi.evolith.prefix.OVERDRIVE] =
    {
        [xi.evolith.suffix.ABILITY_DELAY] = 158,
    },

    [xi.evolith.prefix.TRANCE] =
    {
        [xi.evolith.suffix.ABILITY_DELAY] = 159,
    },

    [xi.evolith.prefix.TABULA_RASA] =
    {
        [xi.evolith.suffix.ABILITY_DELAY] = 160,
    },

    [xi.evolith.prefix.HAND_TO_HAND_WS] =
    {
        [xi.evolith.suffix.ENMITY  ] = 161,
        [xi.evolith.suffix.TP_BONUS] = 162,
    },

    [xi.evolith.prefix.DAGGER_WS] =
    {
        [xi.evolith.suffix.ATTACK       ] = 163,
        [xi.evolith.suffix.TRIPLE_ATTACK] = 164,
    },

    [xi.evolith.prefix.SWORD_WS] =
    {
        [xi.evolith.suffix.ATTACK           ] = 165,
        [xi.evolith.suffix.CRITICAL_HIT_RATE] = 166,
    },

    [xi.evolith.prefix.GREAT_SWORD_WS] =
    {
        [xi.evolith.suffix.ACCURACY     ] = 167,
        [xi.evolith.suffix.DOUBLE_ATTACK] = 168,
    },

    [xi.evolith.prefix.AXE_WS] =
    {
        [xi.evolith.suffix.ATTACK       ] = 169,
        [xi.evolith.suffix.DOUBLE_ATTACK] = 170,
    },

    [xi.evolith.prefix.GREAT_AXE_WS] =
    {
        [xi.evolith.suffix.ACCURACY] = 171,
        [xi.evolith.suffix.TP_BONUS] = 172,
    },

    [xi.evolith.prefix.SCYTHE_WS] =
    {
        [xi.evolith.suffix.ENMITY           ] = 173,
        [xi.evolith.suffix.SKILLCHAIN_DAMAGE] = 174,
    },

    [xi.evolith.prefix.POLEARM_WS] =
    {
        [xi.evolith.suffix.ACCURACY         ] = 175,
        [xi.evolith.suffix.CRITICAL_HIT_RATE] = 176,
    },

    [xi.evolith.prefix.KATANA_WS] =
    {
        [xi.evolith.suffix.ENMITY           ] = 177,
        [xi.evolith.suffix.CRITICAL_HIT_RATE] = 178,
    },

    [xi.evolith.prefix.GREAT_KATANA_WS] =
    {
        [xi.evolith.suffix.ACCURACY         ] = 179,
        [xi.evolith.suffix.SKILLCHAIN_DAMAGE] = 180,
    },

    [xi.evolith.prefix.CLUB_WS] =
    {
        [xi.evolith.suffix.ATTACK       ] = 181,
        [xi.evolith.suffix.DOUBLE_ATTACK] = 182,
    },

    [xi.evolith.prefix.STAFF_WS] =
    {
        [xi.evolith.suffix.ENMITY  ] = 183,
        [xi.evolith.suffix.TP_BONUS] = 184,
    },

    [xi.evolith.prefix.ARCHERY_WS] =
    {
        [xi.evolith.suffix.RANGED_ACCURACY] = 185,
        [xi.evolith.suffix.TP_BONUS       ] = 186,
    },

    [xi.evolith.prefix.MARKSMANSHIP_WS] =
    {
        [xi.evolith.suffix.RANGED_ATTACK    ] = 187,
        [xi.evolith.suffix.SKILLCHAIN_DAMAGE] = 188,
    },

    [xi.evolith.prefix.DIVINE_MAGIC_LIGHT] =
    {
        [xi.evolith.suffix.MAGIC_ACCURACY] = 189,
        [xi.evolith.suffix.RECAST_DELAY  ] = 190,
    },

    [xi.evolith.prefix.HEALING_MAGIC_LIGHT] =
    {
        [xi.evolith.suffix.ENMITY      ] = 191,
        [xi.evolith.suffix.CASTING_TIME] = 192,
    },

    [xi.evolith.prefix.ENHANCING_MAGIC_FIRE] =
    {
        [xi.evolith.suffix.CONSERVE_MP ] = 193,
        [xi.evolith.suffix.RECAST_DELAY] = 194,
    },

    [xi.evolith.prefix.ENHANCING_MAGIC_ICE] =
    {
        [xi.evolith.suffix.CONSERVE_MP ] = 195,
        [xi.evolith.suffix.RECAST_DELAY] = 196,
    },

    [xi.evolith.prefix.ENHANCING_MAGIC_WIND] =
    {
        [xi.evolith.suffix.CONSERVE_MP ] = 197,
        [xi.evolith.suffix.RECAST_DELAY] = 198,
    },

    [xi.evolith.prefix.ENHANCING_MAGIC_EARTH] =
    {
        [xi.evolith.suffix.CONSERVE_MP ] = 199,
        [xi.evolith.suffix.RECAST_DELAY] = 200,
    },

    [xi.evolith.prefix.ENHANCING_MAGIC_LIGHTNING] =
    {
        [xi.evolith.suffix.CONSERVE_MP ] = 201,
        [xi.evolith.suffix.RECAST_DELAY] = 202,
    },

    [xi.evolith.prefix.ENHANCING_MAGIC_WATER] =
    {
        [xi.evolith.suffix.CONSERVE_MP ] = 203,
        [xi.evolith.suffix.RECAST_DELAY] = 204,
    },

    [xi.evolith.prefix.ENHANCING_MAGIC_LIGHT] =
    {
        [xi.evolith.suffix.CONSERVE_MP ] = 205,
        [xi.evolith.suffix.RECAST_DELAY] = 206,
    },

    [xi.evolith.prefix.ENHANCING_MAGIC_DARK] =
    {
        [xi.evolith.suffix.CONSERVE_MP ] = 207,
        [xi.evolith.suffix.RECAST_DELAY] = 208,
    },

    [xi.evolith.prefix.ENFEEBLING_MAGIC_FIRE] =
    {
        [xi.evolith.suffix.MAGIC_ACCURACY] = 209,
        [xi.evolith.suffix.CASTING_TIME  ] = 210,
    },

    [xi.evolith.prefix.ENFEEBLING_MAGIC_ICE] =
    {
        [xi.evolith.suffix.MAGIC_ACCURACY] = 211,
        [xi.evolith.suffix.CASTING_TIME  ] = 212,
    },

    [xi.evolith.prefix.ENFEEBLING_MAGIC_WIND] =
    {
        [xi.evolith.suffix.MAGIC_ACCURACY] = 213,
        [xi.evolith.suffix.CASTING_TIME  ] = 214,
    },

    [xi.evolith.prefix.ENFEEBLING_MAGIC_EARTH] =
    {
        [xi.evolith.suffix.MAGIC_ACCURACY] = 215,
        [xi.evolith.suffix.CASTING_TIME  ] = 216,
        [xi.evolith.suffix.NONE          ] = 217,
        [xi.evolith.suffix.NONE          ] = 218,
    },

    [xi.evolith.prefix.ENFEEBLING_MAGIC_WATER] =
    {
        [xi.evolith.suffix.MAGIC_ACCURACY] = 219,
        [xi.evolith.suffix.CASTING_TIME  ] = 220,
    },

    [xi.evolith.prefix.ENFEEBLING_MAGIC_LIGHT] =
    {
        [xi.evolith.suffix.MAGIC_ACCURACY] = 221,
        [xi.evolith.suffix.CASTING_TIME  ] = 222,
    },

    [xi.evolith.prefix.ENFEEBLING_MAGIC_DARK] =
    {
        [xi.evolith.suffix.MAGIC_ACCURACY] = 223,
        [xi.evolith.suffix.CASTING_TIME  ] = 224,
    },

    [xi.evolith.prefix.ELEMENTAL_MAGIC_FIRE] =
    {
        [xi.evolith.suffix.ENMITY                 ] = 225,
        [xi.evolith.suffix.MAGIC_CRITICAL_HIT_RATE] = 226,
    },

    [xi.evolith.prefix.ELEMENTAL_MAGIC_ICE] =
    {
        [xi.evolith.suffix.ENMITY                 ] = 227,
        [xi.evolith.suffix.MAGIC_CRITICAL_HIT_RATE] = 228,
    },

    [xi.evolith.prefix.ELEMENTAL_MAGIC_WIND] =
    {
        [xi.evolith.suffix.ENMITY                 ] = 229,
        [xi.evolith.suffix.MAGIC_CRITICAL_HIT_RATE] = 230,
    },

    [xi.evolith.prefix.ELEMENTAL_MAGIC_EARTH] =
    {
        [xi.evolith.suffix.ENMITY                 ] = 231,
        [xi.evolith.suffix.MAGIC_CRITICAL_HIT_RATE] = 232,
    },

    [xi.evolith.prefix.ELEMENTAL_MAGIC_LIGHTNING] =
    {
        [xi.evolith.suffix.ENMITY                 ] = 233,
        [xi.evolith.suffix.MAGIC_CRITICAL_HIT_RATE] = 234,
    },

    [xi.evolith.prefix.ELEMENTAL_MAGIC_WATER] =
    {
        [xi.evolith.suffix.ENMITY                 ] = 235,
        [xi.evolith.suffix.MAGIC_CRITICAL_HIT_RATE] = 236,
    },

    [xi.evolith.prefix.ELEMENTAL_MAGIC_LIGHT] =
    {
        [xi.evolith.suffix.ENMITY                 ] = 237,
        [xi.evolith.suffix.MAGIC_CRITICAL_HIT_RATE] = 238,
    },

    [xi.evolith.prefix.ELEMENTAL_MAGIC_DARK] =
    {
        [xi.evolith.suffix.ENMITY                 ] = 239,
        [xi.evolith.suffix.MAGIC_CRITICAL_HIT_RATE] = 240,
    },

    [xi.evolith.prefix.DARK_MAGIC_DARK] =
    {
        [xi.evolith.suffix.MAGIC_ACCURACY] = 241,
        [xi.evolith.suffix.RECAST_DELAY  ] = 242,
    },

    [xi.evolith.prefix.SONGS_FIRE] =
    {
        [xi.evolith.suffix.ENMITY      ] = 243,
        [xi.evolith.suffix.CASTING_TIME] = 244,
    },

    [xi.evolith.prefix.SONGS_ICE] =
    {
        [xi.evolith.suffix.ENMITY      ] = 245,
        [xi.evolith.suffix.CASTING_TIME] = 246,
    },

    [xi.evolith.prefix.SONGS_WIND] =
    {
        [xi.evolith.suffix.ENMITY      ] = 247,
        [xi.evolith.suffix.CASTING_TIME] = 248,
    },

    [xi.evolith.prefix.SONGS_EARTH] =
    {
        [xi.evolith.suffix.ENMITY      ] = 249,
        [xi.evolith.suffix.CASTING_TIME] = 250,
    },

    [xi.evolith.prefix.SONGS_LIGHTNING] =
    {
        [xi.evolith.suffix.ENMITY      ] = 251,
        [xi.evolith.suffix.CASTING_TIME] = 252,
    },

    [xi.evolith.prefix.SONGS_WATER] =
    {
        [xi.evolith.suffix.ENMITY      ] = 253,
        [xi.evolith.suffix.CASTING_TIME] = 254,
    },

    [xi.evolith.prefix.SONGS_LIGHT] =
    {
        [xi.evolith.suffix.ENMITY      ] = 255,
        [xi.evolith.suffix.CASTING_TIME] = 256,
    },

    [xi.evolith.prefix.SONGS_DARK] =
    {
        [xi.evolith.suffix.ENMITY      ] = 257,
        [xi.evolith.suffix.CASTING_TIME] = 258,
    },

    [xi.evolith.prefix.NINJUTSU_FIRE] =
    {
        [xi.evolith.suffix.ENMITY        ] = 259,
        [xi.evolith.suffix.MAGIC_ACCURACY] = 260,
    },

    [xi.evolith.prefix.NINJUTSU_ICE] =
    {
        [xi.evolith.suffix.ENMITY        ] = 261,
        [xi.evolith.suffix.MAGIC_ACCURACY] = 262,
    },

    [xi.evolith.prefix.NINJUTSU_WIND] =
    {
        [xi.evolith.suffix.ENMITY        ] = 263,
        [xi.evolith.suffix.MAGIC_ACCURACY] = 264,
    },

    [xi.evolith.prefix.NINJUTSU_EARTH] =
    {
        [xi.evolith.suffix.ENMITY        ] = 265,
        [xi.evolith.suffix.MAGIC_ACCURACY] = 266,
    },

    [xi.evolith.prefix.NINJUTSU_LIGHTNING] =
    {
        [xi.evolith.suffix.ENMITY        ] = 267,
        [xi.evolith.suffix.MAGIC_ACCURACY] = 268,
    },

    [xi.evolith.prefix.NINJUTSU_WATER] =
    {
        [xi.evolith.suffix.ENMITY        ] = 269,
        [xi.evolith.suffix.MAGIC_ACCURACY] = 270,
    },

    [xi.evolith.prefix.NINJUTSU_LIGHT] =
    {
        [xi.evolith.suffix.ENMITY        ] = 271,
        [xi.evolith.suffix.MAGIC_ACCURACY] = 272,
    },

    [xi.evolith.prefix.NINJUTSU_DARK] =
    {
        [xi.evolith.suffix.ENMITY        ] = 273,
        [xi.evolith.suffix.MAGIC_ACCURACY] = 274,
    },

    [xi.evolith.prefix.BLUE_MAGIC_FIRE] =
    {
        [xi.evolith.suffix.MAGIC_ACCURACY    ] = 275,
        [xi.evolith.suffix.MAGIC_ATTACK_BONUS] = 276,
    },

    [xi.evolith.prefix.BLUE_MAGIC_ICE] =
    {
        [xi.evolith.suffix.MAGIC_ACCURACY    ] = 277,
        [xi.evolith.suffix.MAGIC_ATTACK_BONUS] = 278,
    },

    [xi.evolith.prefix.BLUE_MAGIC_WIND] =
    {
        [xi.evolith.suffix.MAGIC_ACCURACY    ] = 279,
        [xi.evolith.suffix.MAGIC_ATTACK_BONUS] = 280,
    },

    [xi.evolith.prefix.BLUE_MAGIC_EARTH] =
    {
        [xi.evolith.suffix.MAGIC_ACCURACY    ] = 281,
        [xi.evolith.suffix.MAGIC_ATTACK_BONUS] = 282,
    },

    [xi.evolith.prefix.BLUE_MAGIC_LIGHTNING] =
    {
        [xi.evolith.suffix.MAGIC_ACCURACY    ] = 283,
        [xi.evolith.suffix.MAGIC_ATTACK_BONUS] = 284,
    },

    [xi.evolith.prefix.BLUE_MAGIC_WATER] =
    {
        [xi.evolith.suffix.MAGIC_ACCURACY    ] = 285,
        [xi.evolith.suffix.MAGIC_ATTACK_BONUS] = 286,
    },

    [xi.evolith.prefix.BLUE_MAGIC_LIGHT] =
    {
        [xi.evolith.suffix.MAGIC_ACCURACY    ] = 287,
        [xi.evolith.suffix.MAGIC_ATTACK_BONUS] = 288,
    },

    [xi.evolith.prefix.BLUE_MAGIC_DARK] =
    {
        [xi.evolith.suffix.MAGIC_ACCURACY    ] = 289,
        [xi.evolith.suffix.MAGIC_ATTACK_BONUS] = 290,
    },

    [xi.evolith.prefix.BLUE_MAGIC_PHYSICAL] =
    {
        [xi.evolith.suffix.ATTACK  ] = 291,
        [xi.evolith.suffix.ACCURACY] = 292,
    },

    [xi.evolith.prefix.WEATHER_FIRE] =
    {
        [xi.evolith.suffix.ADDITIONAL_EFFECT_DISEASE    ] = 293,
        [xi.evolith.suffix.ADDITIONAL_EFFECT_FIRE_DAMAGE] = 301,
    },

    [xi.evolith.prefix.WEATHER_ICE] =
    {
        [xi.evolith.suffix.ADDITIONAL_EFFECT_PARALYSIS ] = 294,
        [xi.evolith.suffix.ADDITIONAL_EFFECT_ICE_DAMAGE] = 302,
    },

    [xi.evolith.prefix.WEATHER_WIND] =
    {
        [xi.evolith.suffix.ADDITIONAL_EFFECT_SILENCE    ] = 295,
        [xi.evolith.suffix.ADDITIONAL_EFFECT_WIND_DAMAGE] = 303,
    },

    [xi.evolith.prefix.WEATHER_EARTH] =
    {
        [xi.evolith.suffix.ADDITIONAL_EFFECT_SLOW        ] = 296,
        [xi.evolith.suffix.ADDITIONAL_EFFECT_EARTH_DAMAGE] = 304,
    },

    [xi.evolith.prefix.WEATHER_LIGHTNING] =
    {
        [xi.evolith.suffix.ADDITIONAL_EFFECT_STUN            ] = 297,
        [xi.evolith.suffix.ADDITIONAL_EFFECT_LIGHTNING_DAMAGE] = 305,
    },

    [xi.evolith.prefix.WEATHER_WATER] =
    {
        [xi.evolith.suffix.ADDITIONAL_EFFECT_POISON      ] = 298,
        [xi.evolith.suffix.ADDITIONAL_EFFECT_WATER_DAMAGE] = 306,
    },

    [xi.evolith.prefix.WEATHER_LIGHT] =
    {
        [xi.evolith.suffix.ADDITIONAL_EFFECT_DEFENSE_DOWN] = 299,
        [xi.evolith.suffix.ADDITIONAL_EFFECT_LIGHT_DAMAGE] = 307,
    },

    [xi.evolith.prefix.WEATHER_DARK] =
    {
        [xi.evolith.suffix.ADDITIONAL_EFFECT_SLEEP      ] = 300,
        [xi.evolith.suffix.ADDITIONAL_EFFECT_DARK_DAMAGE] = 308,
    },

    [xi.evolith.prefix.NONE] =
    {
        [xi.evolith.suffix.HP             ] = 309,
        [xi.evolith.suffix.MP             ] = 310,
        [xi.evolith.suffix.RESIST_VIRUS   ] = 311,
        [xi.evolith.suffix.RESIST_SLOW    ] = 312,
        [xi.evolith.suffix.RESIST_SILENCE ] = 313,
        [xi.evolith.suffix.RESIST_PARALYZE] = 314,
        [xi.evolith.suffix.RESIST_GRAVITY ] = 315,
        [xi.evolith.suffix.RESIST_PETRIFY ] = 316,
        [xi.evolith.suffix.RESIST_SLEEP   ] = 317,
        [xi.evolith.suffix.RESIST_POISON  ] = 318,
        [xi.evolith.suffix.RESIST_BIND    ] = 319,
    },

    [xi.evolith.prefix.SKILLCHAIN_LIGHT] =
    {
        [xi.evolith.suffix.SKILLCHAIN_DAMAGE  ] = 320,
        [xi.evolith.suffix.SKILLCHAIN_ACCURACY] = 322,
        [xi.evolith.suffix.MAGIC_BURST_DAMAGE ] = 324,
    },

    [xi.evolith.prefix.SKILLCHAIN_DARK] =
    {
        [xi.evolith.suffix.SKILLCHAIN_DAMAGE  ] = 321,
        [xi.evolith.suffix.SKILLCHAIN_ACCURACY] = 323,
        [xi.evolith.suffix.MAGIC_BURST_DAMAGE ] = 325,
    },
}
