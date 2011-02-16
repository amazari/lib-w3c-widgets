/*
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 * limitations under the License.
 */
namespace org.apache.wookie.w3c.util {


/**
 * Utils for content type sniffing
 */
public class ContentTypeUtils {

	private static const string[] SUPPORTED_IMAGE_TYPES = {"image/png", "image/jpeg", "image/svg+xml", "image/gif", "image/vnd.microsoft.icon"};

	/**
	 * Checks to see if a filename is a supported image type based on its file extension
	 * @param filename the filename to check
	 * @return true if the filename has an extension for a supported image type
	 */
	public static bool isSupportedImageType(string filename){
		string type = getContentType(filename);
		return isSupported(type, SUPPORTED_IMAGE_TYPES);
	}	

	/**
	 * Checks to see if a file is a supported image type
	 * @param file the file to check
	 * @return true if the file is a supported image type
	 */
	public static bool isFileSupportedImageType(File file){
		if (file == null) return false;
		string type = getFileContentType(file);
		return isSupported(type, SUPPORTED_IMAGE_TYPES);
	}	

	/**
	 * Gets the content type of a file
	 * TODO actually implement SNIFF algorithm
	 * @param file
	 * @return the matched content type, or null if there is no match
	 */
	private static string getFileContentType(File file){
		string type = getContentType(file.get_basename());
		if (type == null){ 
			//TODO implement the SNIFF spec for binary content-type checking
		}
		return type;
	}

	/**
	 * Extracts the file extension from the given filename and looks up the
	 * content type
	 * @param filename
	 * @return the matched content type, or null if there is no match
	 */
	private static string getContentType(string filename){

		if (filename.length == 0) return null;
		if (filename.has_suffix(".")) return null;
		if (filename.has_prefix(".") && filename.last_index_of(".")==0) return null;
		if (filename.contains(".")){
			string type = null;
			string[] parts = filename.split("\\.");
			string ext = parts[parts.length-1];
			if (ext.length != 0){
				type = getContentTypeForExtension(ext);
			return type;
			}
		}
		return null;
	}

	/**
	 * @param ext
	 * @return the content-type for the given file extension, or null if there is no match
	 */
	private static string getContentTypeForExtension(string ext){
		if(ext == "html") return "text/html";
		if(ext == "htm") return "text/html";
		if(ext == "css") return "text/css";
		if(ext == "js") return "application/javascript";
		if(ext == "xml") return "application/xml";
		if(ext == "txt") return "text/plain";		
		if(ext == "wav") return "audio/x-wav";
		if(ext == "xhtml") return "application/xhtml+xml";
		if(ext == "xht") return "application/xhtml+xml";
		if(ext == "gif") return "image/gif";
		if(ext == "png") return "image/png";
		if(ext == "ico") return "image/vnd.microsoft.icon";
		if(ext == "svg") return "image/svg+xml";
		if(ext == "jpg") return "image/jpeg";
		return null;

	}

	/**
	 * Checks to see if the supplied value is one of the supported values
	 * @param value
	 * @param supportedValues
	 * @return true if the value is one of the supported values
	 */
	public static bool isSupported(string value, string[] supportedValues){
		if (value == null) return false;
		bool supported = false;
		foreach (string type in supportedValues){
			if (value == type) supported = true;
		}
		return supported;
	}

}
}
