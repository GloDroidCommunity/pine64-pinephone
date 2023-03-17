#pragma once

#define DEVICE_HANDLE_BUTTONS() \
 if test STRESC(\$volume_key) = STRESC("up");   \
 then                                           \
  run enter_fastboot ;                          \
 fi;                                            \
 if test STRESC(\$volume_key) = STRESC("down"); \
 then                                           \
  setenv androidrecovery true ;                 \
 fi;                                            \


/* Select proper DTS version for PinePhone (v1.1 or v1.2) */
#define DEVICE_HANDLE_FDT() \
 setenv main_fdt_id 0x11;  /* -> PinePhone v1.1 */                              \
 if test STRESC(\${fdtfile}) != STRESC(allwinner/sun50i-a64-pinephone-1.1.dtb); \
 then                                                                           \
  setenv main_fdt_id 0x12; /* -> PinePhone v1.2 */                              \
 fi;                                                                            \


/* GPIOs:
 * PD18 - Green LED
 * PD19 - Red LED
 * PD20 - Blue LED
 */

/* Set blue LED when in fastboot mode */
#define PRE_ENTER_FASTBOOT() \
 gpio clear PD18; gpio set PD20; \
