package com.ingee.util;

import java.io.FileOutputStream;
import java.io.IOException;

import org.springframework.web.multipart.MultipartFile;

public class UploadFileWriter {
	private FileOutputStream fos;

	public void writeFile(MultipartFile multipartFile, String path, String fileName) {
		try {
			byte fileData[] = multipartFile.getBytes();
			fos = new FileOutputStream(path + "/" + fileName);
			fos.write(fileData);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (fos != null)
				try {
					fos.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
		}
	}
}