/************************************************************************
 * Tester Gear - CPP Module
 *
 * Registers a global Lua function:
 *   addItemToContainer(entity, itemId, locationId [, quantity [, silent]])
 *
 * This allows Lua modules to place items directly into a specific
 * container (inventory, wardrobes, etc.) without modifying base code.
 ************************************************************************/

#include "map/entities/charentity.h"
#include "map/item_container.h"
#include "map/lua/lua_baseentity.h"
#include "map/utils/charutils.h"
#include "map/utils/moduleutils.h"

class TesterGearModule : public CPPModule
{
    void OnInit() override
    {
        // Register as a global free function: addItemToContainer(entity, itemId, locationId [, qty [, silent]])
        lua.set_function("addItemToContainer", [](CLuaBaseEntity* self, uint16 itemId, uint8 locationId, sol::optional<uint32> qty, sol::optional<bool> silent) -> bool
                         {
                             if (!self || self->GetBaseEntity()->objtype != TYPE_PC)
                             {
                                 ShowWarning("addItemToContainer: called on a non-player entity");
                                 return false;
                             }

                             auto*  PChar    = static_cast<CCharEntity*>(self->GetBaseEntity());
                             uint32 quantity = qty.value_or(1);
                             bool   silence  = silent.value_or(false);

                             return charutils::AddItem(PChar, locationId, itemId, quantity, silence) != ERROR_SLOTID;
                         });
    }
};

REGISTER_CPP_MODULE(TesterGearModule);
