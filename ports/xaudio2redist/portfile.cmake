
set(VCPKG_POLICY_DLLS_IN_STATIC_LIBRARY enabled)

vcpkg_download_distfile(ARCHIVE
    URLS "https://www.nuget.org/api/v2/package/Microsoft.XAudio2.Redist/${VERSION}"
    FILENAME "xaudio2redist.${VERSION}.zip"
    SHA512 d9db1e64d31926af252f196238f9793710b53c894c47f2936c5fe3b7d37297711fe293d44f36da189bb6ee34855698569bc51a69cb03d81a49ff3c167cec43b9
)

vcpkg_extract_source_archive(
    PACKAGE_PATH
    ARCHIVE ${ARCHIVE}
    NO_REMOVE_ONE_LEVEL
)

if(VCPKG_TARGET_ARCHITECTURE STREQUAL "x86")
    set(XAUDIO_ARCH x86)
else()
    set(XAUDIO_ARCH x64)
endif()

file(GLOB HEADER_FILES "${PACKAGE_PATH}/build/native/include/*.h")
file(INSTALL ${HEADER_FILES} DESTINATION "${CURRENT_PACKAGES_DIR}/include/${PORT}")

file(INSTALL "${PACKAGE_PATH}/build/native/release/lib/${XAUDIO_ARCH}/xaudio2_9redist.lib" DESTINATION "${CURRENT_PACKAGES_DIR}/lib")

if(VCPKG_CRT_LINKAGE STREQUAL "dynamic")
   file(INSTALL "${PACKAGE_PATH}/build/native/release/lib/${XAUDIO_ARCH}/xapobaseredist_md.lib" DESTINATION "${CURRENT_PACKAGES_DIR}/lib")
   set(lib_suffix "_md")
else()
   file(INSTALL "${PACKAGE_PATH}/build/native/release/lib/${XAUDIO_ARCH}/xapobaseredist.lib" DESTINATION "${CURRENT_PACKAGES_DIR}/lib")
   set(lib_suffix "")
endif()

file(INSTALL "${PACKAGE_PATH}/build/native/release/bin/${XAUDIO_ARCH}/xaudio2_9redist.dll" DESTINATION "${CURRENT_PACKAGES_DIR}/bin")

if(NOT DEFINED VCPKG_BUILD_TYPE)
    file(INSTALL "${PACKAGE_PATH}/build/native/debug/lib/${XAUDIO_ARCH}/xaudio2_9redist.lib" DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib")

    if(VCPKG_CRT_LINKAGE STREQUAL "dynamic")
        file(INSTALL "${PACKAGE_PATH}/build/native/debug/lib/${XAUDIO_ARCH}/xapobaseredist_md.lib" DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib")
    else()
        file(INSTALL "${PACKAGE_PATH}/build/native/debug/lib/${XAUDIO_ARCH}/xapobaseredist.lib" DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib")
    endif()

    file(INSTALL "${PACKAGE_PATH}/build/native/debug/bin/${XAUDIO_ARCH}/xaudio2_9redist.dll" DESTINATION "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()

configure_file("${CMAKE_CURRENT_LIST_DIR}/xaudio2redist-config.cmake.in"
    "${CURRENT_PACKAGES_DIR}/share/${PORT}/${PORT}-config.cmake"
    @ONLY)

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
vcpkg_install_copyright(FILE_LIST "${PACKAGE_PATH}/LICENSE.txt")
