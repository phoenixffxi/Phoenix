---@meta

---@class ExdataLegionPass
---@field timestamp integer     # How long until the pass expires. Usually 5 minutes from creation.
---@field title xi.legion.title # Legion chamber
---@field signature string      # 12 characters pass owner name

---@class ExdataPerpetualHourglass
---@field flags integer         # Undocumented flags. Changes Hourglass text color to denote status.
---@field startTime integer     # Reservation start time
---@field endTime integer       # Reservation end time
---@field zoneId xi.zone        # Zone reserved by Hourglass
