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


using org.apache.wookie.w3c.util;
using org.apache.wookie.w3c;

using Gee;

/**
 * Utilities for working with Widget packages, i.e. Zip Files with an XML manifest
 * @author scott
 *
 */
public class WidgetPackageUtils {

	/**
	 * Implements the rule for finding a file within a widget; it returns the first localized version 
	 * first before returning a root version. An exception is thrown if the path points to a folder, and
	 * null is returned if no file is found
	 * @param path
	 * @param locales the supported locales, in list of preference
	 * @param zip
	 * @return
	 * @throws Error
	 */
	public static string? locateFilePath(string path, string[] locales, File zip) throws Error{
		string[] paths = locateFilePaths(path, locales, zip);
		if (paths != null && paths.length != 0) return paths[0];
		return null;
	}
	
	/**
	 * Returns the set of valid file paths for a given resource. All valid paths are returned, starting
	 * with localized versions for supported locales before the root version (if present).
	 * @param path
	 * @param locales
	 * @param zip
	 * @return
	 * @throws Error
	 */
	public static string[]? locateFilePaths(string path, string[] locales, File zip) throws Error{
		string path2 = path;
		ArrayList<string> paths = new ArrayList<string>();
		File child;
		
		if (path.has_prefix("/")) path2 = path.substring(1, path.length);
		string[] pathComponents = path2.split("/");
		if ("locales".ascii_casecmp (pathComponents[0])== 0){
			if (pathComponents.length < 2) return null;
			if (!LocalizationUtils.isValidLanguageTag(pathComponents[1])) return null;
		}
		// Look in localized folders first
		foreach (string locale in locales){
			string localePath = "locales/"+locale.chug()+"/"+path;
			child = zip.get_child(localePath);
			if (child != null && 
			    child.query_file_type(FileQueryInfoFlags.NONE) != FileType.DIRECTORY)
				paths.add(localePath);
			}
		// Look in root folder
		child = zip.get_child(path);
		if (child != null  && child.query_file_type(FileQueryInfoFlags.NONE) != FileType.DIRECTORY)
			paths.add(path);
		return  paths.to_array();
	}
	
	/**
	 * Return the language tag for a given path
	 * @param path
	 * @return
	 */
	public static string? languageTagForPath(string path){
		if (path == null) return null;
		string locale = null;
		string[] pathComponents = path.split("/");
		if ("locales".ascii_casecmp (pathComponents[0]) == 0){
			if (pathComponents.length < 2) return null;
			return pathComponents[1];
		}
		return locale;
	}
	
	/**
	 * Return the set of valid default files for each locale in the zip
	 * @param zip
	 * @param locales
	 * @param defaults
	 * @return
	 */
	public static string[] getDefaults(File zip, string[] locales, string[] defaults){
		ArrayList<string> content = new ArrayList<string>();
		foreach (string start in defaults){
			try {
				string[] paths = locateFilePaths(start, locales, zip);
				if (paths != null){
					foreach (string path in paths) content.add(path);
				}
			} catch (Error e) {
				// ignore and move onto next
			}
		}
		return content.to_array();	
	}
	
	/**
	 * Returns a File representing the unpacked folder for a widget with the given identifier.
	 * @param widgetFolder the folder that contains unpacked widgets
	 * @param id the widget identifier URI
	 * @return a File where the widget may be unpacked
	 * @throws IOError
	 */
	public static File createUnpackedWidgetFolder(File widgetFolder, string id) {
		string folder = convertIdToFolderName(id);
		string serverPath = widgetFolder.get_path() + Path.DIR_SEPARATOR_S + folder;
		File file = File.new_for_path(convertPathToPlatform(serverPath));
		return file;
	}

	/**
	 * Returns the local URL for a widget 
	 * @param widgetFolder the folder that contains unpacked widgets
	 * @param id the widget identifier URI
	 * @param file a file in the widget package; use "" to obtain the root of the widget folder
	 * @return
	 */
	public static string getURLForWidget(string widgetFolder, string id, string file){
		string folder = convertIdToFolderName(id);
		string path = convertPathToRelativeUri(widgetFolder + Path.DIR_SEPARATOR_S + folder + Path.DIR_SEPARATOR_S + file); //$NON-NLS-1$ //$NON-NLS-2$
		return path;
	}
	
	/**
	 * Converts a widget identifier (usually a URI) into a form suitable for use as a file system folder name
	 * @param id the widget identifier URI
	 * @return the folder name to use for the widget
	 */
	public static string convertIdToFolderName(string id){
	
		string result = id;
		if(result.has_prefix("http://")){ //$NON-NLS-1$
			 result = id.substring(7, id.length);
		}
		//id = id.replaceAll(" ", ""); //$NON-NLS-1$ //$NON-NLS-2$
		//result = result.replaceAll("[ \\:\"*?<>|`\n\r\t\0]+", "");
		return result;
	}

	public static string convertPathToRelativeUri(string path){
		return path.replace("\\", "/");
	}

	public static string convertPathToPlatform(string path) {
		string result = path.replace("\\", "/")
		.replace("/", Path.DIR_SEPARATOR_S);
		if (result.has_suffix(Path.DIR_SEPARATOR_S)) {
			result = result.substring(0, result.length - 1);
		}
		return result;
	}

	
	/**
	 * Checks for the existence of the Manifest.
	 * TODO not sure if this properly handles case-sensitive entries?
	 * @param zipfile
	 * @return true if the zip file has a manifest
	 */
	public static bool hasManifest(File zipfile){
		return zipfile.get_child(IW3CXMLConfiguration.MANIFEST_FILE) != null;
	}

	/**
	 * Retrieves the Manifest entry as a string
	 * @param zipFile the zip file from which to extract the manifest
	 * @return a string representing the manifest contents
	 * @throws IOError
	 */
//	public static string extractManifest(File zipFile) throws IOError{
//		ZipArchiveEntry entry = zipFile.getEntry(IW3CXMLConfiguration.MANIFEST_FILE);
///		return IOUtils.tostring(zipFile.getInputStream(entry), "UTF-8");
//	}

	/**
	 * uses apache commons compress to unpack all the zip entries into a target folder
	 * partly adapted from the examples on the apache commons compress site, and an
	 * example of generic Zip unpacking. Note this iterates over the ZipArchiveEntry enumeration rather
	 * than use the more typical ZipInputStream parsing model, as according to the doco it will
	 * more reliably read the entries correctly. More info here: http://commons.apache.org/compress/zip.html
	 * @param zipfile the Zip File to unpack
	 * @param targetFolder the folder into which to unpack the Zip file
	 * @throws IOError
	 */

	public static void unpackZip(File zipfile, File targetFolder) throws IOError {
		
	}
	
	/**
	 * Packages the source file/folder up as a new Zip file
	 * @param source the source file or folder to be zipped
	 * @param target the zip file to create
	 * @throws IOError
	 */
	public static void repackZip(File source, File target) throws IOError{

	}
	
	/**
	 * Recursively locates and adds files and folders to a zip archive
	 * @param file
	 * @param out
	 * @param path
	 * @throws IOError
	 */
//	private static void pack(File file, ZipArchiveOutputStream outstream, string path) throws IOError {
       
 //   }
}
}
