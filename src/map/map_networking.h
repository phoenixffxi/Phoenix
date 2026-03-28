/*
===========================================================================

  Copyright (c) 2025 LandSandBoat Dev Teams

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

#include <common/blowfish.h>
#include <common/cbasetypes.h>
#include <common/ipp.h>
#include <common/scheduler.h>

#include "map_config.h"
#include "map_constants.h"
#include "map_session.h"
#include "map_session_container.h"
#include "map_socket.h"
#include "map_statistics.h"

class CBasicPacket;

class MapNetworking
{
public:
    using UsePreviousKey = xi::Flag<struct UsePreviousKeyTag>;

    MapNetworking(Scheduler& scheduler, MapStatistics& mapStatistics, MapConfig config);

    //
    // Networking
    //

    // TODO: Pass around std::span<uint8> instead of uint8* and size_t*
    // TODO: Stop changing the buffsize size_t as we go along
    // TODO: All of these need to become coroutines
    void handle_incoming_packet(ByteSpan buffer, IPP ipp);

    int32 map_decipher_packet(uint8*, size_t, MapSession*, blowfish_t*); // Decipher packet
    int32 recv_parse(uint8*, size_t*, MapSession*, IPP ipp);             // main function to parse recv packets
    int32 parse(uint8*, size_t*, MapSession*);                           // main function parsing the packets
    int32 send_parse(uint8*, size_t*, MapSession*, UsePreviousKey);      // main function is building big packet

    int32 sendSinglePacketNoPChar(uint8*, size_t*, MapSession*, UsePreviousKey, CBasicPacket*); // used to resend 0x00B if client didn't receive it (dropped packet)

    void tapStatistics();

    //
    // Accessors
    //

    auto ipp() const -> IPP;
    auto sessions() -> MapSessionContainer&;
    auto scheduler() -> Scheduler&;
    auto socket() -> MapSocket&;

private:
    Scheduler&                 scheduler_;
    MapStatistics&             mapStatistics_;
    IPP                        mapIPP_;
    MapSessionContainer        mapSessions_;
    std::unique_ptr<MapSocket> mapSocket_;
    MapConfig                  config_;

    // TODO: We can probably dedupe these and move the main buffer into MapSocket
    NetworkBuffer PBuff;          // Global packet clipboard
    NetworkBuffer PBuffCopy;      // Copy of above, used to decrypt a second time if necessary.
    NetworkBuffer PScratchBuffer; // Temporary packet clipboard

    // TODO: Move these to MapStatistics
    uint32 TotalPacketsToSendPerTick{ 0U };
    uint32 TotalPacketsSentPerTick{ 0U };
    uint32 TotalPacketsDelayedPerTick{ 0U };
};
