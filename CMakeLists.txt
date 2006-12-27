PROJECT(RUBY-HUNSPELL)

SET(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake ${CMAKE_MODULE_PATH})

SUBDIRS(tests hunspell)
ENABLE_TESTING()

FIND_PACKAGE(Ruby REQUIRED)

FIND_PATH( HUNSPELL_INCLUDE_DIR hunspell.hxx
	   /usr/include
	   /usr/include/hunspell
	   /usr/local/include
	   /usr/local/include/hunspell
	 )

FIND_LIBRARY( HUNSPELL_LIBRARY NAMES hunspell libhunspell
	      PATHS
	      /usr/lib
	      /usr/local/lib
	    )

FIND_LIBRARY( HUNSPELL_PARSERS_LIBRARY NAMES parsers libparsers
	      PATHS
	      /usr/lib
	      /usr/local/lib
	    )

if ( HUNSPELL_INCLUDE_DIR AND HUNSPELL_LIBRARY )
   message(STATUS "Found hunspell: ${HUNSPELL_LIBRARY}")
else ( HUNSPELL_INCLUDE_DIR AND HUNSPELL_LIBRARY )
   message(FATAL_ERROR "Could NOT find hunspell")
endif ( HUNSPELL_INCLUDE_DIR AND HUNSPELL_LIBRARY )

INCLUDE_DIRECTORIES(${RUBY_INCLUDE_PATH} ${HUNSPELL_INCLUDE_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/generator)

if ( NOT MSVC )
   set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fvisibility=hidden")
   ADD_DEFINITIONS(-DHAVE_VISIBILITY)
endif ( NOT MSVC )
