set(DstDownloadedFilePath ${v_ImportedLibRootDirPath}/${v_ZipFileName})
if(c_ProjectPipelineSetup OR NOT EXISTS "${v_UnzippedDirPath}")
	download_zip_replace_dir_if_not_exists(${v_SrcAddrZipFilePath} ${DstDownloadedFilePath} ${v_UnzippedDirPath} IsDownloaded)
endif()