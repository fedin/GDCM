# MEXD Testing
set(MEXD_TEST_SRCS
  TestPresentationContextRQ
  TestQueryFactory
  TestULConnectionManager
  TestServiceClassUser
  TestServiceClassUser2
  TestSCUValidation
  TestEcho
  TestFind
  )
if(GDCM_DATA_ROOT)
  set(MEXD_TEST_SRCS
    ${MEXD_TEST_SRCS}
    TestSCUFunctions
    )
endif()

# Add the include paths
include_directories(
  "${GDCM_BINARY_DIR}/Source/Common"
  "${GDCM_SOURCE_DIR}/Source/Common"
  "${GDCM_SOURCE_DIR}/Testing/Source/Data"
  "${GDCM_BINARY_DIR}/Testing/Source/Data"
  "${GDCM_SOURCE_DIR}/Source/DataStructureAndEncodingDefinition"
  "${GDCM_SOURCE_DIR}/Source/DataDictionary"
  "${GDCM_SOURCE_DIR}/Source/MediaStorageAndFileFormat"
  "${GDCM_SOURCE_DIR}/Source/MessageExchangeDefinition"
  )

create_test_sourcelist(MEXDTests gdcmMEXDTests.cxx ${MEXD_TEST_SRCS}
  EXTRA_INCLUDE gdcmTestDriver.h
  )
add_executable(gdcmMEXDTests ${MEXDTests})
target_link_libraries(gdcmMEXDTests gdcmMEXD gdcmMSFF gdcmDSED gdcmDICT gdcmCommon)

#Don't understand why I need that ??
set(GDCM_MEXD_TESTS "${EXECUTABLE_OUTPUT_PATH}/gdcmMEXDTests")

# Loop over files and create executables
foreach(name ${MEXD_TEST_SRCS})
  if(${name} STREQUAL "TestSCUFunctions"
      OR ${name} STREQUAL "TestServiceClassUser"
      OR ${name} STREQUAL "TestServiceClassUser2"
      )
    if(GDCM_DICOM_SERVER_AETITLE)
      add_test(${name} ${GDCM_MEXD_TESTS} ${name} ${GDCM_DICOM_CLIENT_AETITLE}
        ${GDCM_DICOM_SERVER_AETITLE} ${GDCM_DICOM_SERVER_PORT}
        ${GDCM_DICOM_CLIENT_PORT} ${GDCM_DICOM_SERVER_PEER})
    endif()
  else()
    add_test(${name} ${GDCM_MEXD_TESTS} ${name})
  endif()
endforeach()

set(DCMQRSCP_HOSTNAME gotlib)
set(DCMQRSCP_PORT 5677)
set(DCMQRSCP_DIRECTORY ${GDCM_TEMP_DIRECTORY})
configure_file(
  ${GDCM_SOURCE_DIR}/CMake/dcmqrscp.cfg.in
  ${CMAKE_CURRENT_BINARY_DIR}/dcmqrscp.cfg
  )
# execute_process(COMMAND ${DCMTK_DCMQRSCP_EXECUTABLE}
#   --verbose --debug -c ${CMAKE_CURRENT_BINARY_DIR}/dcmqrscp.cfg)
