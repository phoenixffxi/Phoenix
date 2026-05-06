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

#include <DetourNavMesh.h>
#include <DetourNavMeshQuery.h>

#include "common/logging.h"
#include "common/mmo.h"

#include <cfloat>
#include <memory>
#include <vector>

class CNavMesh
{
public:
    static void ToFFXIPos(const position_t* pos, float* out);
    static void ToFFXIPos(float* out);
    static void ToFFXIPos(position_t* out);
    static void ToDetourPos(const position_t* pos, float* out);
    static void ToDetourPos(float* out);
    static void ToDetourPos(position_t* out);

public:
    CNavMesh(uint16 zoneID);
    ~CNavMesh();

    bool load(const std::string& path);
    bool installNavMesh(dtNavMesh* newNavMesh);
    bool save(const std::string& path) const;
    void unload();

    auto findPath(const position_t& start, const position_t& end) -> std::vector<pathpoint_t>;
    auto findRandomPosition(const position_t& start, float maxRadius) -> std::pair<int16, position_t>;

    // Returns true if the point is in water (not implemented)
    bool inWater(const position_t& point);

    // Returns true if no wall was hit
    //
    // Recast Detour Docs:
    // Casts a 'walkability' ray along the surface of the navigation mesh from the start position toward the end position.
    // Note: This is not a point-to-point in 3D space calculation, it is 2D across the navmesh!
    bool raycast(const position_t& start, const position_t& end);

    bool validPosition(const position_t& position);
    bool findClosestValidPoint(const position_t& position, float* validPoint);
    bool findFurthestValidPoint(const position_t& startPosition, const position_t& endPosition, float* validPoint);

    // Like validPosition(), but will also set the given position to the valid position that it finds.
    void snapToValidPosition(position_t& position);

    [[nodiscard]] static auto detourStatusString(const uint32 status) -> std::string;

private:
    bool onSameFloor(const position_t& start, float* spos, const position_t& end, float* epos, dtQueryFilter& filter);

    std::string    m_filename;
    uint16         m_zoneID;
    dtNavMesh*     m_navMesh;
    dtNavMeshQuery m_navMeshQuery;

    std::vector<dtPolyRef>     m_navMeshQueryPolyData;
    std::vector<float>         m_navMeshQueryStraightPathFloatData;
    std::vector<unsigned char> m_navMeshQueryStraightPathFlagData;
    std::vector<dtPolyRef>     m_navMeshQueryStraightPathPolyData;

    std::vector<dtPolyRef> m_navMeshQueryRaycastHitPath;
    dtRaycastHit           m_raycastHit;
};
