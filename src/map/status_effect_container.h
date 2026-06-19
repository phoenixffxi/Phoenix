/*
===========================================================================

  Copyright (c) 2010-2015 Darkstar Dev Teams

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see http://www.gnu.org/licenses/

===========================================================================
*/

#pragma once

#include "common/cbasetypes.h"

#include <set>

#include "status_effect.h"

/************************************************************************
 *                                                                       *
 *                                                                       *
 *                                                                       *
 ************************************************************************/

class CBattleEntity;

enum class EffectNotice : uint8
{
    ShowMessage = 0, // Display the "effect wears off" or "gains effect" message to the player
    Silent      = 1, // Suppress the message entirely
};

class CStatusEffectContainer
{
public:
    uint64 m_Flags{ 0 };        // Bits of overflow of bytes m_statusicons (two battles for each effect)
    uint8  m_StatusIcons[32]{}; // Icons status effects

    bool ApplyBardEffect(CStatusEffect* PStatusEffect, uint8 maxSongs);
    bool CanGainStatusEffect(CStatusEffect* PStatusEffect); // returns true if the status effect will take effect
    bool AddStatusEffect(CStatusEffect* StatusEffect, EffectNotice = EffectNotice::ShowMessage);
    auto DelStatusEffect(xi::StatusEffect StatusID) -> bool;
    auto DelStatusEffectSilent(xi::StatusEffect StatusID) -> bool;
    auto DelStatusEffect(xi::StatusEffect StatusID, uint16 SubID) -> bool;
    auto DelStatusEffectBySource(xi::StatusEffect StatusID, EffectSourceType EffectSourceType, uint16 SourceTypeParam) -> bool;
    void DelStatusEffectsByFlag(xi::StatusEffectFlag flag, EffectNotice notice = EffectNotice::ShowMessage); // Remove all the status effects with the specified type
    void DelStatusEffectsByIcon(uint16 BuffNo);                                                              // Remove all effects with the specified icon
    void DelStatusEffectsByType(uint16 Type);
    auto DelStatusEffectByTier(xi::StatusEffect StatusID, uint16 power) -> bool;
    void KillAllStatusEffect();
    void ApplyStateAlteringEffects(CStatusEffect* StatusEffect);

    auto HasStatusEffect(xi::StatusEffect StatusID) -> bool;               // We check the presence of the effect
    auto HasStatusEffect(xi::StatusEffect StatusID, uint16 SubID) -> bool; // Check the presence of an effect with a unique Subid
    auto HasStatusEffect(std::initializer_list<xi::StatusEffect>) -> bool;
    auto HasStatusEffectByFlag(xi::StatusEffectFlag flag) -> bool;

    auto  EraseStatusEffect() -> xi::StatusEffect;                                             // We delete the first negative effect
    auto  HealingWaltz() -> xi::StatusEffect;                                                  // dancers healing waltz
    uint8 EraseAllStatusEffect();                                                              // erases all status effects
    auto  DispelStatusEffect(xi::StatusEffectFlag flag) -> xi::StatusEffect;                   // We delete the first positive effect
    auto  DispelAllStatusEffect(xi::StatusEffectFlag flag) -> uint8;                           // dispels all status effects
    auto  StealStatusEffect(xi::StatusEffectFlag flag, EffectNotice notice) -> CStatusEffect*; // dispels one effect and returns it

    auto GetStatusEffect(xi::StatusEffect StatusID) -> CStatusEffect*;
    auto GetStatusEffect(xi::StatusEffect StatusID, uint32 SubID) -> CStatusEffect*;
    auto GetStatusEffectBySource(xi::StatusEffect StatusID, EffectSourceType Sourcetype, uint16 SourceTypeParam) -> CStatusEffect*;

    auto GetStatusEffectsInIDRange(xi::StatusEffect start, xi::StatusEffect end) -> std::vector<xi::StatusEffect>;

    auto GetStatusEffectCountInIDRange(xi::StatusEffect start, xi::StatusEffect end) -> uint8;
    auto GetNewestStatusEffectInIDRange(xi::StatusEffect start, xi::StatusEffect end) -> xi::StatusEffect;
    void RemoveOldestStatusEffectInIDRange(xi::StatusEffect start, xi::StatusEffect end);
    void RemoveNewestStatusEffectInIDRange(xi::StatusEffect start, xi::StatusEffect end);
    void RemoveAllStatusEffectsInIDRange(xi::StatusEffect start, xi::StatusEffect end);

    void UpdateStatusIcons(); // We recall the effects of the effects
    void CheckEffectsExpiry(timer::time_point tick);
    void TickEffects(timer::time_point tick);
    void TickRegen(timer::time_point tick);

    void LoadStatusEffects();                    // We load the character effects
    void SaveStatusEffects(bool logout = false); // We keep the character effects

    auto  GetEffectsCount(xi::StatusEffect ID) -> uint8;               // We get the number of effects with the specified ID
    auto  GetEffectsCountWithFlag(xi::StatusEffectFlag flag) -> uint8; // We get the number of effects with the specified flag
    uint8 GetLowestFreeSlot();                                         // returns the lowest free slot for songs/rolls

    auto ApplyCorsairEffect(CStatusEffect* PStatusEffect, uint8 maxRolls, uint8 bustDuration) -> bool;
    bool CheckForElevenRoll();
    bool HasBustEffect(uint16 id);
    bool HasCorsairEffect(uint32 charid);
    void Fold(uint32 charid);

    uint8 GetActiveManeuverCount();
    void  RemoveOldestManeuver();
    void  RemoveAllManeuvers();

    auto GetAllRuneEffects() -> std::vector<xi::StatusEffect>;

    uint8 GetActiveRuneCount();
    auto  GetHighestRuneEffect() -> xi::StatusEffect;
    auto  GetNewestRuneEffect() -> xi::StatusEffect;
    void  RemoveOldestRune();
    void  RemoveNewestRune();
    void  RemoveAllRunes();

    void WakeUp(); // remove sleep effects
    bool IsAsleep();
    bool HasPreventActionEffect(bool ignoreCharm = false); // checks if owner has an effect that prevents actions, like stun, petrify, sleep etc

    uint16 GetConfrontationEffect();                        // gets confrontation number (bcnm, confrontation, campaign, reive mark)
    void   CopyConfrontationEffect(CBattleEntity* PEntity); // copies confrontation status (pet summoning, etc)

    template <typename F, typename... Args>
    void ForEachEffect(F func, Args&&... args)
    {
        for (auto&& PEffect : m_StatusEffectSet)
        {
            func(PEffect, std::forward<Args>(args)...);
        }
    }

    CStatusEffectContainer(CBattleEntity* PEntity);
    ~CStatusEffectContainer();

private:
    CBattleEntity* m_POwner = nullptr;

    // void ReplaceStatusEffect(xi::StatusEffect effect); //this needs to be implemented
    void RemoveStatusEffect(CStatusEffect* PStatusEffect, EffectNotice notice = EffectNotice::ShowMessage); // We remove the effect by its number in the container
    void DeleteStatusEffects();
    auto SetEffectParams(CStatusEffect* StatusEffect) -> void; // We set the effect of the effect
    void HandleAura(CStatusEffect* PStatusEffect);

    void OverwriteStatusEffect(CStatusEffect* StatusEffect);

    std::multiset<CStatusEffect*, bool (*)(CStatusEffect* AStatus, CStatusEffect* BStatus)> m_StatusEffectSet{};
};

/************************************************************************
 *                                                                       *
 *                                                                       *
 *                                                                       *
 ************************************************************************/

namespace effects
{

void        LoadEffectsParameters();
uint16      GetEffectElement(uint16 effect);
std::string GetEffectName(uint16 effect);

}; // namespace effects
