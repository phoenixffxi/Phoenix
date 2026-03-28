---@meta

---@class ExdataLegionPass
---@field timestamp integer                                    # How long until the pass expires. Usually 5 minutes from creation.
---@field title     xi.legion.title                            # Legion chamber
---@field signature string                                     # 12 characters pass owner name

---@class ExdataPerpetualHourglass
---@field flags     integer                                    # Undocumented flags. Changes Hourglass text color to denote status.
---@field startTime integer                                    # Reservation start time
---@field endTime   integer                                    # Reservation end time
---@field zoneId    xi.zone                                    # Zone reserved by Hourglass

---@class ExdataBettingSlip
---@field raceId       integer                                 # Chocobo race ID [0-262143]
---@field raceGrade    xi.chocoboRacing.raceGrade
---@field racePairingL integer                                 # [0-7], 0-indexed chocobo entry
---@field racePairingR integer                                 # [0-7], 0-indexed chocobo entry
---@field quills       integer                                 # [0-999]

---@class ExdataAssaultLog
---@field flags boolean[]                                      # 10 flags indexed [1-10] representing completed assaults.

---@class ExdataBrennerBook
---@field timeValue integer                                    # Seconds since epoch 1009929600 (Jan 2, 2002 00:00 UTC)
---@field level     xi.brenner.levelCap

---@class ExdataMeebleGrimoire
---@field clears table<xi.meeble.expeditionType, integer[]>    # clears[expeditionType][level] = count (0-7)
---@field count  integer                                       # Distinct expedition count
---@field zone   xi.meeble.zone

---@class ExdataHoneymoonTicket
---@field plan xi.chocoboRaising.honeymoonPlan

---@class ExdataRaceCertificate
---@field raceId    integer                                    # [0-262143]
---@field raceGrade xi.chocoboRacing.raceGrade

---@alias Exdata ExdataLegionPass|ExdataPerpetualHourglass|ExdataBettingSlip|ExdataAssaultLog|ExdataBrennerBook|ExdataMeebleGrimoire|ExdataHoneymoonTicket|ExdataRaceCertificate
