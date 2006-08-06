PROJECT(RUBY-HUNSPELL)

SET(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake ${CMAKE_MODULE_PATH})

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

if ( HUNSPELL_INCLUDE_DIR AND HUNSPELL_LIBRARY )
   message(STATUS "Found hunspell: ${HUNSPELL_LIBRARY}")
else ( HUNSPELL_INCLUDE_DIR AND HUNSPELL_LIBRARY )
   message(FATAL_ERROR "Could NOT find hunspell")
endif ( HUNSPELL_INCLUDE_DIR AND HUNSPELL_LIBRARY )

INCLUDE_DIRECTORIES(${RUBY_INCLUDE_PATH} ${HUNSPELL_INCLUDE_DIR})

# This is unfortunately the only way to inject a CC flag
ADD_DEFINITIONS(-fvisibility=hidden)

SET(GENERATOR_PATH ${CMAKE_CURRENT_SOURCE_DIR}/generator)
ADD_CUSTOM_COMMAND(
	OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/hunspell/hunspell.cpp
		${CMAKE_CURRENT_BINARY_DIR}/hunspell/hunspell.h
	COMMAND ${RUBY_EXECUTABLE}
	ARGS -I${GENERATOR_PATH} -C${CMAKE_CURRENT_BINARY_DIR}/hunspell
		${GENERATOR_PATH}/generator.rb ${GENERATOR_PATH}/description.yml
	DEPENDS ${GENERATOR_PATH}/generator.rb ${GENERATOR_PATH}/class.rb
		${GENERATOR_PATH}/method.rb ${GENERATOR_PATH}/namespace.rb
		${GENERATOR_PATH}/function.rb
		${GENERATOR_PATH}/description.yml
)

ADD_LIBRARY(hunspell MODULE ${CMAKE_CURRENT_BINARY_DIR}/hunspell/hunspell.cpp)
SET_TARGET_PROPERTIES(hunspell PROPERTIES PREFIX "")
TARGET_LINK_LIBRARIES(hunspell ${HUNSPELL_LIBRARY})

SET(CMAKE_INSTALL_PREFIX "")
INSTALL_TARGETS(${RUBY_ARCH_DIR} hunspell)
