/* This file is part of RTags (http://rtags.net).

   RTags is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   RTags is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with RTags.  If not, see <http://www.gnu.org/licenses/>. */

#include "SymbolInfoJob.h"

#include "Project.h"
#include "QueryMessage.h"
#include "RTags.h"
#include "Server.h"

SymbolInfoJob::SymbolInfoJob(Location loc, const std::shared_ptr<QueryMessage> &query, const std::shared_ptr<Project> &proj)
    : QueryJob(query, proj), location(loc)
{
}

int SymbolInfoJob::execute()
{
    int ret = 1;
    int idx = -1;
    auto symbol = project()->findSymbol(location, &idx);
    if (!symbol.isNull()) {
        write(symbol);
        ret = 0;
    }
    return ret;
}
