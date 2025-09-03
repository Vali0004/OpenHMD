// Copyright 2018, Philipp Zabel.
// SPDX-License-Identifier: BSL-1.0
/*
 * OpenHMD - Free and Open Source API and drivers for immersive technology.
 */

/* Hid helper. */
#ifndef OPENHMD_HID_H
#define OPENHMD_HID_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static inline char* _hid_to_unix_path(const char* path)
{
    char* result = malloc(32);
    if (!result)
		return NULL;

    // Copy the bus number
    int bus = 0;
    if (sscanf(path, "%d-", &bus) != 1)
		bus = 0;

    char sysfs_name[32];
    strncpy(sysfs_name, path, sizeof(sysfs_name));
    sysfs_name[sizeof(sysfs_name)-1] = 0;
    char* colon = strchr(sysfs_name, ':');
    if (colon)
		*colon = '\0';

    char devnum_path[64];
    snprintf(devnum_path, sizeof(devnum_path),
             "/sys/bus/usb/devices/%s/devnum", sysfs_name);

    FILE* f = fopen(devnum_path, "r");
    if (!f) {
        perror(devnum_path);
        free(result);
        return NULL;
    }

    int devnum = 0;
    if (fscanf(f, "%d", &devnum) != 1) {
        perror("fscanf");
        fclose(f);
        free(result);
        return NULL;
    }
    fclose(f);

    // Construct /dev/bus/usb/<bus>/<devnum>
    snprintf(result, 32, "/dev/bus/usb/%03d/%03d", bus, devnum);
    return result;
}

#endif
