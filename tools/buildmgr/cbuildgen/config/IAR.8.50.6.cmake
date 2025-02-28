# This file maps the CMSIS project options to toolchain settings.
#
#   - Applies to toolchain: IAR ARM C/C++ Compiler V8.50.6

############### EDIT BELOW ###############
# Set base directory of toolchain
set(TOOLCHAIN_ROOT)
set(EXT)

############ DO NOT EDIT BELOW ###########

set(AS ${TOOLCHAIN_ROOT}/iasmarm${EXT})
set(CC ${TOOLCHAIN_ROOT}/iccarm${EXT})
set(CXX ${TOOLCHAIN_ROOT}/iccarm${EXT})
set(LD ${TOOLCHAIN_ROOT}/ilinkarm${EXT})
set(AR ${TOOLCHAIN_ROOT}/iarchive${EXT})
set(OC ${TOOLCHAIN_ROOT}/ielftool${EXT})

# Core Options

if(CPU STREQUAL "Cortex-M0")
  set(IAR_CPU "Cortex-M0")
elseif(CPU STREQUAL "Cortex-M0+")
  set(IAR_CPU "Cortex-M0+")
elseif(CPU STREQUAL "Cortex-M1")
  set(IAR_CPU "Cortex-M1")
elseif(CPU STREQUAL "Cortex-M3")
  set(IAR_CPU "Cortex-M3")
elseif(CPU STREQUAL "Cortex-M4")
  set(IAR_CPU "Cortex-M4")
  if(FPU STREQUAL "SP_FPU")
    set(IAR_CPU "Cortex-M4.fp.sp")
  endif()
elseif(CPU STREQUAL "Cortex-M7")
  set(IAR_CPU "Cortex-M7")
  if(FPU STREQUAL "DP_FPU")
    set(IAR_CPU "${IAR_CPU}.fp.dp")
  elseif(FPU STREQUAL "SP_FPU")
    set(IAR_CPU "${IAR_CPU}.fp.sp")
  endif()
elseif(CPU STREQUAL "Cortex-M23")
  set(IAR_CPU "Cortex-M23")
  if(TZ STREQUAL "NO_TZ")
    set(IAR_CPU "${IAR_CPU}.no_se")
  endif()
elseif(CPU STREQUAL "Cortex-M33")
  set(IAR_CPU "Cortex-M33")
  if(FPU STREQUAL "SP_FPU")
    set(IAR_CPU "${IAR_CPU}.fp")
  endif()
  if(DSP STREQUAL "NO_DSP")
    set(IAR_CPU "${IAR_CPU}.no_dsp")
  endif()
  if(TZ STREQUAL "NO_TZ")
    set(IAR_CPU "${IAR_CPU}.no_se")
  endif()
elseif(CPU STREQUAL "Cortex-M35P")
  set(IAR_CPU "Cortex-M35P")
  if(FPU STREQUAL "SP_FPU")
    set(IAR_CPU "${IAR_CPU}.fp")
  endif()
  if(DSP STREQUAL "NO_DSP")
    set(IAR_CPU "${IAR_CPU}.no_dsp")
  endif()
  if(TZ STREQUAL "NO_TZ")
    set(IAR_CPU "${IAR_CPU}.no_se")
  endif()
endif()
if(NOT DEFINED IAR_CPU)
  message(FATAL_ERROR "Error: CPU is not supported!")
endif()

if(BYTE_ORDER STREQUAL "Little-endian")
  set(IAR_BYTE_ORDER "little")
elseif(BYTE_ORDER STREQUAL "Big-endian")
  set(IAR_BYTE_ORDER "big")
endif()

# Helpers

function(cbuild_set_defines lang defines)
  set(TMP_DEFINES)
  foreach(DEFINE ${${defines}})
    string(REPLACE "\"" "\\\"" ENTRY ${DEFINE})
    string(REGEX REPLACE "=.*" "" KEY ${ENTRY})
    if (KEY STREQUAL ENTRY)
      set(D_OPT ${KEY})
    else()
      string(REGEX REPLACE ".*=" "" VALUE ${ENTRY})
      set(D_OPT "${KEY}=${VALUE}")
    endif()
    if(${lang} STREQUAL "ASM")
      string(APPEND TMP_DEFINES "-D${D_OPT} ")
    else()
      string(APPEND TMP_DEFINES "-D ${D_OPT} ")
    endif()
  endforeach()
  set(${defines} ${TMP_DEFINES} PARENT_SCOPE)
endfunction()

set(OPTIMIZE_VALUES    "none" "balanced" "size" "speed")
set(OPTIMIZE_CC_FLAGS  "-On"  "-Oh"      "-Ohz" "-Ohs")
set(OPTIMIZE_CXX_FLAGS ${OPTIMIZE_CC_FLAGS})

set(DEBUG_VALUES       "on"      "off")
set(DEBUG_ASM_FLAGS    "-r"      "")
set(DEBUG_CC_FLAGS     "--debug" "")
set(DEBUG_CXX_FLAGS    ${DEBUG_CC_FLAGS})

set(WARNINGS_VALUES    "on" "off")
set(WARNINGS_ASM_FLAGS ""   "-w-")
set(WARNINGS_CC_FLAGS  ""   "--no_warnings")
set(WARNINGS_CXX_FLAGS ${WARNINGS_CC_FLAGS})
set(WARNINGS_LD_FLAGS  ${WARNINGS_CC_FLAGS})

function(cbuild_set_option_flags lang option value flags)
  if(NOT DEFINED ${option}_${lang}_FLAGS)
    return()
  endif()
  list(FIND ${option}_VALUES "${value}" _index)
  if (${_index} GREATER -1)
    list(GET ${option}_${lang}_FLAGS ${_index} flag)
    set(${flags} "${flag} ${${flags}}" PARENT_SCOPE)
  else()
    string(TOLOWER "${option}" _option)
    message(FATAL_ERROR "unkown "${_option}" value '${value}' !")
  endif()
endfunction()

function(cbuild_set_options_flags lang optimize debug warnings flags)
  set(opt_flags)
  cbuild_set_option_flags(${lang} OPTIMIZE "${optimize}" opt_flags)
  cbuild_set_option_flags(${lang} DEBUG    "${debug}"    opt_flags)
  cbuild_set_option_flags(${lang} WARNINGS "${warnings}" opt_flags)
  set(${flags} "${opt_flags} ${${flags}}" PARENT_SCOPE)
endfunction()

# Assembler

set(ASM_CPU "--cpu ${IAR_CPU}")
set(ASM_BYTE_ORDER "--endian ${IAR_BYTE_ORDER}")
set(ASM_FLAGS)
set(ASM_DEFINES ${DEFINES})
cbuild_set_defines(ASM ASM_DEFINES)
set(ASM_OPTIONS_FLAGS)
cbuild_set_options_flags(ASM "${OPTIMIZE}" "${DEBUG}" "${WARNINGS}" ASM_OPTIONS_FLAGS)

# C Compiler

set(CC_CPU "--cpu=${IAR_CPU}")
set(CC_BYTE_ORDER "--endian=${IAR_BYTE_ORDER}")
set(CC_FLAGS)
set(CC_DEFINES ${DEFINES})
cbuild_set_defines(CC CC_DEFINES)
set(CC_OPTIONS_FLAGS)
cbuild_set_options_flags(CC "${OPTIMIZE}" "${DEBUG}" "${WARNINGS}" CC_OPTIONS_FLAGS)
set(_PI "-include ")

if(SECURE STREQUAL "Secure")
  set(CC_SECURE "--cmse")
endif()

# C++ Compiler

set(CXX_CPU "${CC_CPU}")
set(CXX_BYTE_ORDER "${CC_BYTE_ORDER}")
set(CXX_FLAGS "${CC_FLAGS}")
set(CXX_OPTIONS_FLAGS "${CC_OPTIONS_FLAGS}")
set(CXX_DEFINES "${CC_DEFINES}")
set(CXX_SECURE "${CC_SECURE}")

# Linker

set(LD_CPU "--cpu=${IAR_CPU}")
set(_LS "--config ")

if(SECURE STREQUAL "Secure")
  set(LD_SECURE "--import_cmse_lib_out \"${OUT_DIR}/${TARGET}_CMSE_Lib.o\"")
endif()

set(LD_FLAGS)
set(LD_OPTIONS_FLAGS)
cbuild_set_options_flags(LD "${OPTIMIZE}" "${DEBUG}" "${WARNINGS}" LD_OPTIONS_FLAGS)

# Target Output

set (LIB_PREFIX)
set (LIB_SUFFIX ".a")
set (EXE_SUFFIX ".out")

# ELF to HEX conversion
set (ELF2HEX --silent --ihex "${OUT_DIR}/${TARGET}${EXE_SUFFIX}" "${OUT_DIR}/${TARGET}.hex")

# ELF to BIN conversion
set (ELF2BIN --silent --bin "${OUT_DIR}/${TARGET}${EXE_SUFFIX}" "${OUT_DIR}/${TARGET}.bin")

# Set CMake variables for toolchain initialization
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_CROSSCOMPILING TRUE)
set(CMAKE_ASM_COMPILER "${AS}")
set(CMAKE_C_COMPILER "${CC}")
set(CMAKE_CXX_COMPILER "${CXX}")
set(CMAKE_OBJCOPY "${OC}")
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/CMakeASM")

# Set CMake variables for skipping compiler identification
set(CMAKE_ASM_COMPILER_FORCED TRUE)
set(CMAKE_C_COMPILER_FORCED TRUE)
set(CMAKE_C_COMPILER_WORKS TRUE)
set(CMAKE_CXX_COMPILER_ID "${CMAKE_C_COMPILER_ID}")
set(CMAKE_CXX_COMPILER_ID_RUN "${CMAKE_C_COMPILER_ID_RUN}")
set(CMAKE_CXX_COMPILER_VERSION "${CMAKE_C_COMPILER_VERSION}")
set(CMAKE_CXX_COMPILER_FORCED "${CMAKE_C_COMPILER_FORCED}")
set(CMAKE_CXX_COMPILER_WORKS "${CMAKE_C_COMPILER_WORKS}")
