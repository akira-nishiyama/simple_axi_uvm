cmake_minimum_required(VERSION 3.1)
enable_testing( ${INCLUDE_DIRS_EXAMPLE})

find_program(   VIVADO_COMMAND
                NAME vivado
                HINTS ENV var
                REQUIRED)

find_file(  HELPER_SCRIPT_IPX
            NAME create_ip.tcl
            HINTS $ENV{VIVADO_CMAKE_HELPER})

find_file(  HELPER_SCRIPT_PRJ_GEN
            NAME project_generation.tcl
            HINTS $ENV{VIVADO_CMAKE_HELPER})

find_file(  HELPER_SCRIPT_IMPORT_BD
            NAME vivado_import_bd.tcl
            HINTS $ENV{VIVADO_CMAKE_HELPER})

find_file(  HELPER_SCRIPT_EXPORT_SIM
            NAME vivado_export_sim.tcl
            HINTS $ENV{VIVADO_CMAKE_HELPER})

find_file(  HELPER_SCRIPT_OPEN_WDB
            NAME vivado_open_wdb.tcl
            HINTS $ENV{VIVADO_CMAKE_HELPER})

find_file(  VIVADO_IPX_EXPORT_CMAKE
            NAME vivado_ipx_export.cmake
            HINTS $ENV{VIVADO_CMAKE_HELPER}
            REQUIRED)

find_file(  VIVADO_ADD_SIM_CMAKE
            NAME vivado_add_sim.cmake
            HINTS $ENV{VIVADO_CMAKE_HELPER})

find_file(  HELPER_SCRIPT_ADD_BD
            NAME vivado_import_bd.tcl
            HINTS $ENV{VIVADO_CMAKE_HELPER})

#version fixed to 1.0 due to vivado 2019.2 restriction.
project(simple_axi_uvm
    VERSION 1.0
    LANGUAGES NONE)

set(CP "cp")
set(CP_OPTION "-rf")
set(MV "mv")
set(RM "rm")
set(RM_OPTION "-rf")
set(SED "sed")
set(MKDIR "mkdir")
set(MKDIR_OPTION "-p")

set(VENDOR "Akira_Nishiyama")
set(LIBRARY_NAME "user")
set(TARGET_DEVICE "xczu3eg-sbva484-1-e")

#description
set(DESCRIPTION "ICS_IF IP")
#string(REPLACE " " ":" DESCRIPTION "${DESCRIPTION}")

set(DISPLAY_IP_NAME "ICS_IF")

#source list
#list(APPEND SRC_FILES "")
#string(REPLACE ";" ":" SRC_FILES_FOR_PRJ "${SRC_FILES}")
string(REPLACE ";" ":" SRC_FILES_FOR_PRJ " ")

#testbench list
file(GLOB UVM_AXI_FILES ${CMAKE_CURRENT_SOURCE_DIR}/src/*.sv
                        ${CMAKE_CURRENT_SOURCE_DIR}/example/*.sv)
#set(TESTBENCH_FILES "")
list(APPEND TESTBENCH_FILES "${UVM_AXI_FILES}")
string(REPLACE ";" ":" TESTBENCH_FILES_FOR_PRJ "${TESTBENCH_FILES}")

#message("${TESTBENCH_FILES}")

#ip_repo_path list
set(IP_REPO_PATH "")
list(APPEND IP_REPO_PATH "${CMAKE_CURRENT_BINARY_DIR}")
string(REPLACE ";" ":" IP_REPO_PATH "${IP_REPO_PATH}")

#vivado create_project name(currently fixed to project_1)
set(VIVADO_PRJ_NAME "project_1")
set(SIMSET_NAME "sim_1")

#create block design scripts

include(${VIVADO_IPX_EXPORT_CMAKE})
project_generation( ${PROJECT_NAME} ${VENDOR} ${LIBRARY_NAME} ${TARGET_DEVICE} ${SRC_FILES_FOR_PRJ} ${TESTBENCH_FILES_FOR_PRJ} ${IP_REPO_PATH} ${HELPER_SCRIPT_PRJ_GEN})

add_custom_target( ${PROJECT_NAME} ALL
    DEPENDS prj_gen_${PROJECT_NAME}
)

#simulation
set(DEPENDENCIES ${PROJECT_NAME})
set(SIMULATION_DIR "${CMAKE_CURRENT_BINARY_DIR}/sim")
file(MAKE_DIRECTORY ${SIMULATION_DIR}/work/xsim)
add_custom_target(gen_all DEPENDS ${DEPENDENCIES})
add_custom_target(compile_all DEPENDS gen_all)
add_custom_target(elaborate_all DEPENDS compile_all)
add_custom_target(sim_all DEPENDS elaborate_all)

#set(INCLUDE_DIRS "")
list(APPEND INCLUDE_DIRS "-i ${CMAKE_CURRENT_SOURCE_DIR}/include")
list(APPEND INCLUDE_DIRS_EXAMPLE "-i ${CMAKE_CURRENT_SOURCE_DIR}/example")

set(ADDITIONAL_VLOG_OPTS "-L uvm -d VIVADO_SIM ${INCLUDE_DIRS} ${INCLUDE_DIRS_EXAMPLE}")
set(ADDITIONAL_ELAB_OPTS "-L uvm")
set(ADDITIONAL_XSIM_OPTS "-testplusarg UVM_TESTNAME")

include(${VIVADO_ADD_SIM_CMAKE})

file(GLOB EXAMPLE_DEPENDENCIES  ${CMAKE_CURRENT_SOURCE_DIR}/include/*.svh
                                ${CMAKE_CURRENT_SOURCE_DIR}/src/*.sv
                                ${CMAKE_CURRENT_SOURCE_DIR}/example/*.sv
                                ${CMAKE_CURRENT_SOURCE_DIR}/example/*.svh)

add_sim(tb_simple_axi_uvm ${SIMULATION_DIR} "${DEPENDENCIES};${EXAMPLE_DEPENDENCIES}" "${ADDITIONAL_VLOG_OPTS}" "${ADDITIONAL_ELAB_OPTS}" "${ADDITIONAL_XSIM_OPTS}" "")

if(PRINT_VARIABLES)
    message(STATUS "*** dump start cmake variables ***")
    get_cmake_property(_variableNames VARIABLES)
    foreach(_variableName ${_variableNames})
            message(STATUS "${_variableName}=${${_variableName}}")
    endforeach()
    message(STATUS "*** dump end ***")
endif()
