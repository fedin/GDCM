# - Try to find the OpenSSL encryption library
# Once done this will define
#
#  OPENSSL_FOUND - system has the OpenSSL library
#  OPENSSL_INCLUDE_DIR - the OpenSSL include directory
#  OPENSSL_LIBRARIES - The libraries needed to use OpenSSL

# Copyright (c) 2006, Alexander Neundorf, <neundorf@kde.org>
# Copyright (c) 2009, Mathieu Malaterre, <mathieu.malaterre@gmail.com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.


IF(OPENSSL_LIBRARIES)
   SET(OpenSSL_FIND_QUIETLY TRUE)
ENDIF(OPENSSL_LIBRARIES)

IF(SSL_EAY_DEBUG AND SSL_EAY_RELEASE)
   SET(LIB_FOUND 1)
ENDIF(SSL_EAY_DEBUG AND SSL_EAY_RELEASE)

# http://www.slproweb.com/products/Win32OpenSSL.html
FIND_PATH(OPENSSL_INCLUDE_DIR openssl/ssl.h 
  PATHS "[HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\OpenSSL (32-bit)_is1;Inno Setup: App Path]/include"
)

IF(WIN32 AND MSVC)
   # /MD and /MDd are the standard values - if somone wants to use
   # others, the libnames have to change here too
   # use also ssl and ssleay32 in debug as fallback for openssl < 0.9.8b

   FIND_LIBRARY(LIB_EAY_DEBUG NAMES libeay32MDd libeay32
  PATHS "[HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\OpenSSL (32-bit)_is1;Inno Setup: App Path]/lib/VC"
)
    FIND_LIBRARY(LIB_EAY_RELEASE NAMES libeay32MD libeay32
  PATHS "[HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\OpenSSL (32-bit)_is1;Inno Setup: App Path]/lib/VC"
)
   # FIND_LIBRARY(SSL_EAY_DEBUG NAMES  ssleay32
   FIND_LIBRARY(SSL_EAY_DEBUG NAMES ssleay32MDd ssl ssleay32
  PATHS "[HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\OpenSSL (32-bit)_is1;Inno Setup: App Path]/lib/VC"
)
   #FIND_LIBRARY(SSL_EAY_RELEASE NAMES  ssleay32
   FIND_LIBRARY(SSL_EAY_RELEASE NAMES ssleay32MD ssl ssleay32
  PATHS "[HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\OpenSSL (32-bit)_is1;Inno Setup: App Path]/lib/VC"
)

   IF(MSVC_IDE)
      IF(SSL_EAY_DEBUG AND SSL_EAY_RELEASE)
         SET(OPENSSL_LIBRARIES optimized ${SSL_EAY_RELEASE} ${LIB_EAY_RELEASE} debug ${SSL_EAY_DEBUG} ${LIB_EAY_DEBUG})
      ELSE(SSL_EAY_DEBUG AND SSL_EAY_RELEASE)
         SET(OPENSSL_LIBRARIES NOTFOUND)
         MESSAGE(STATUS "Could not find the debug and release version of openssl")
      ENDIF(SSL_EAY_DEBUG AND SSL_EAY_RELEASE)
   ELSE(MSVC_IDE)
      STRING(TOLOWER ${CMAKE_BUILD_TYPE} CMAKE_BUILD_TYPE_TOLOWER)
      IF(CMAKE_BUILD_TYPE_TOLOWER MATCHES debug)
         SET(OPENSSL_LIBRARIES ${SSL_EAY_DEBUG})
      ELSE(CMAKE_BUILD_TYPE_TOLOWER MATCHES debug)
         SET(OPENSSL_LIBRARIES ${SSL_EAY_RELEASE})
      ENDIF(CMAKE_BUILD_TYPE_TOLOWER MATCHES debug)
   ENDIF(MSVC_IDE)
   MARK_AS_ADVANCED(SSL_EAY_DEBUG SSL_EAY_RELEASE)
ELSE(WIN32 AND MSVC)

   FIND_LIBRARY(OPENSSL_LIBRARIES NAMES ssl ssleay32 ssleay32MD 
#  PATHS "[HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\OpenSSL (32-bit)_is1;Inno Setup: App Path]/bin"
)

ENDIF(WIN32 AND MSVC)

IF(OPENSSL_INCLUDE_DIR AND OPENSSL_LIBRARIES)
   SET(OPENSSL_FOUND TRUE)
ELSE(OPENSSL_INCLUDE_DIR AND OPENSSL_LIBRARIES)
   SET(OPENSSL_FOUND FALSE)
ENDIF (OPENSSL_INCLUDE_DIR AND OPENSSL_LIBRARIES)

IF (OPENSSL_FOUND)
   IF (NOT OpenSSL_FIND_QUIETLY)
      MESSAGE(STATUS "Found OpenSSL: ${OPENSSL_LIBRARIES}")
   ENDIF (NOT OpenSSL_FIND_QUIETLY)
ELSE (OPENSSL_FOUND)
   IF (OpenSSL_FIND_REQUIRED)
      MESSAGE(FATAL_ERROR "Could NOT find OpenSSL")
   ENDIF (OpenSSL_FIND_REQUIRED)
ENDIF (OPENSSL_FOUND)

MARK_AS_ADVANCED(OPENSSL_INCLUDE_DIR OPENSSL_LIBRARIES)
