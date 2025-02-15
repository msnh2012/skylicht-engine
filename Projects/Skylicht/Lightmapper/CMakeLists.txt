include_directories(
	${SKYLICHT_ENGINE_PROJECT_DIR}/Skylicht/System
	${SKYLICHT_ENGINE_PROJECT_DIR}/Skylicht/Lightmapper
	${SKYLICHT_ENGINE_PROJECT_DIR}/Irrlicht/Include	
	${SKYLICHT_ENGINE_PROJECT_DIR}/Skylicht/Engine
)

file(GLOB_RECURSE skylicht_lightmapper_source 
	./**.cpp 
	./**.c 
	./**.h)
	
setup_project_group("${skylicht_lightmapper_source}" ${CMAKE_CURRENT_SOURCE_DIR})
	
add_library(Lightmapper ${ENGINE_SHARED_OR_STATIC_LIB} ${skylicht_lightmapper_source})

if (BUILD_SHARED_LIBS)
set_target_properties(Lightmapper PROPERTIES WINDOWS_EXPORT_ALL_SYMBOLS true)
endif()

set_target_properties(Lightmapper PROPERTIES VERSION ${SKYLICHT_VERSION})

target_link_libraries(Lightmapper Engine)

if (INSTALL_LIBS)
install(TARGETS Lightmapper
			EXPORT LightmapperTargets
			RUNTIME DESTINATION ${SKYLICHT_RUNTIME_INSTALL_DIR}
			LIBRARY DESTINATION ${SKYLICHT_LIBRARY_INSTALL_DIR}
			ARCHIVE DESTINATION ${SKYLICHT_ARCHIVE_INSTALL_DIR})
			
install (DIRECTORY ${SKYLICHT_ENGINE_PROJECT_DIR}/Skylicht/Lightmapper
	DESTINATION ${SKYLICHT_INCLUDE_INSTALL_DIR}/Skylicht
	FILES_MATCHING PATTERN "*.h*")

install(EXPORT LightmapperTargets
	FILE LightmapperTargets.cmake
	NAMESPACE Skylicht::
	DESTINATION ${SKYLICHT_TARGET_INSTALL_DIR}
)
endif()