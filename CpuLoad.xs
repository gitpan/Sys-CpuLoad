#include <stdlib.h>
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

MODULE = Sys::CpuLoad		PACKAGE = Sys::CpuLoad

void
getbsdload()
    PREINIT:
        double loadavg[3];
    PPCODE:
        getloadavg(loadavg, 3);
        EXTEND(SP, 3);
        PUSHs(sv_2mortal(newSVnv(loadavg[0])));
        PUSHs(sv_2mortal(newSVnv(loadavg[1])));
        PUSHs(sv_2mortal(newSVnv(loadavg[2])));

