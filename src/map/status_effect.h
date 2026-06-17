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
#include "common/mmo.h"

#include <vector>

#include "modifier.h"

#include "data/enums/status_effect.h"
#include "data/enums/status_effect_flag.h"

#define MAX_EFFECTID 814 // 768 real + 46 custom

/************************************************************************
 *                                                                       *
 *  Unsolved problems:                                                   *
 *                                                                       *
 *  - updating the effect (e.g., rewriting Protect I to Protect II)      *
 *                                                                       *
 ************************************************************************/

class CBattleEntity;

enum EffectSourceType : uint8_t
{
    SOURCE_NONE           = 0,
    SOURCE_EQUIPPED_ITEM  = 1,
    SOURCE_TEMPORARY_ITEM = 2,
    SOURCE_MOB            = 3,
    SOURCE_FOOD           = 4,
    SOURCE_CORSAIR_ROLL   = 5,
};

class CStatusEffect
{
public:
    auto   GetStatusID() -> xi::StatusEffect;
    uint32 GetSubID() const;
    auto   GetSourceType() const -> uint16;
    auto   GetSourceTypeParam() const -> uint32;
    auto   GetOriginID() const -> uint32;
    uint16 GetIcon() const;
    uint16 GetPower() const;
    uint16 GetSubPower() const;
    uint16 GetSubIcon() const;
    uint16 GetTier() const;
    auto   GetEffectFlags() const -> xi::StatusEffectFlag;
    uint16 GetEffectType() const;
    uint8  GetEffectSlot() const;

    timer::duration   GetTickTime() const;
    timer::duration   GetDuration() const;
    int               GetElapsedTickCount() const;
    timer::time_point GetStartTime();
    CBattleEntity*    GetOwner();

    void SetEffectFlags(xi::StatusEffectFlag Flags);
    void AddEffectFlag(xi::StatusEffectFlag Flag);
    void DelEffectFlag(xi::StatusEffectFlag Flag);
    auto HasEffectFlag(xi::StatusEffectFlag Flag) -> bool;
    void SetEffectType(uint16 Type);
    void SetEffectSlot(uint8 Slot);
    void SetIcon(uint16 Icon);
    auto SetSource(uint16 sourceType, uint32 sourceTypeParam) -> void;
    void SetPower(uint16 Power);
    void SetSubPower(uint16 subPower);
    void SetSubIcon(uint16 subIcon);
    void SetTier(uint16 tier);
    void SetDuration(timer::duration Duration);
    void SetOwner(CBattleEntity* Owner);
    void SetTickTime(timer::duration tick);
    auto SetOriginID(uint32 originID) -> void;

    void IncrementElapsedTickCount();
    void SetStartTime(timer::time_point StartTime);

    void addMod(Mod modType, int16 amount);
    void setMod(Mod modType, int16 value);

    void SetEffectName(std::string name);

    const std::string& GetName();

    std::vector<CModifier> modList; // List of modifiers
    bool                   deleted{ false };

    CStatusEffect(xi::StatusEffect id, uint16 icon, uint16 power, timer::duration tick, timer::duration duration, uint32 subid = 0, uint16 subPower = 0, uint16 subIcon = 0, uint16 tier = 0, xi::StatusEffectFlag flags = xi::StatusEffectFlag::None, uint16 sourceType = EffectSourceType::SOURCE_NONE, uint32 sourceTypeParam = 0, uint32 originID = 0);

    ~CStatusEffect();

private:
    CBattleEntity* m_POwner{ nullptr };

    xi::StatusEffect     m_StatusID{ xi::StatusEffect::None };  // Main effect type
    uint32               m_SubID{ 0 };                          // Additional effect type
    uint16               m_Icon{ 0 };                           // Effect icon
    uint16               m_Power{ 0 };                          // Strength of effect
    uint16               m_SubPower{ 0 };                       // Secondary power of the effect
    uint16               m_SubIcon{ 0 };                        // Secondary icon for the sub effect (used for things like setting an Aura sub effect icon)
    uint16               m_Tier{ 0 };                           // Tier of the effect
    xi::StatusEffectFlag m_Flags{ xi::StatusEffectFlag::None }; // Effect flags (conditions for its disappearance)
    uint32               m_OriginID{ 0 };                       // The effect's origin ID. (This is usually the ID of the entity that created the effect)
    uint16               m_SourceType{ 0 };                     // The effect's source type
    uint32               m_SourceTypeParam{ 0 };                // The effect's source ID
    uint16               m_Type{ 0 };                           // Used to enforce only one
    uint8                m_Slot{ 0 };                           // Used to determine slot order for songs/rolls

    timer::duration   m_TickTime{ 0ms }; // Effect repetition time
    timer::duration   m_Duration{ 0ms }; // Duration of effect
    timer::time_point m_StartTime;       // Time to obtain effect
    int               m_tickCount{ 0 };  // Elapsed ticks

    std::string m_Name; // Effect name for scripts
};
