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
 
 
using W3CWidgets.exceptions;
using W3CWidgets.impl;
using W3CWidgets.util;

using Soup;

namespace W3CWidgets {

/**
 * Factory for parsing W3C Widget packages (.wgt files).
 * 
 * <p>To use the factory you MUST supply a valid output directory into which the Factory will unpack the widget. Other factory
 * properties are optional.<p>
 * 
 * <p>Factory properties:</p>
 * 
 * <dl>
 *   <dt>outputDirectory</dt>
 *   <dd>The directory where the widget will be saved. The factory will expand the widget archive into this
 *   directory, using the widget's identifier to generate a directory name and structure in which to place it</dd>
 *   <dt>startPageProcessor</dt>
 *   <dd>An implementation of the IStartPageProcessor interface. Setting this property allows you to inject a class that can pre-process
 *   start pages for the widget; for example to inject javascript, tidy up HTML, insert template code etc. If this is not set, 
 *   no pre-processing is done by the factory.</dd>
 *   <dt>locales</dt>
 *   <dd>The supported locales (as BCP47 language-tags) to be processed for the widget. This determines which start files, icons, and other localized elements
 *   will be processed and expanded. This is set to "en" by default</dd>
 *   <dt>encodings</dt>
 *   <dd>The supported encodings to be processed for the widget. This determines which custom encodings will be allowed for start files. 
 *   This is set to UTF-8 by default.</dd>
 *   <dt>localPath</dt>
 *   <dd>The base URL from which unpacked widgets will be served, e.g. "/myapp/widgets". The URLs of start files will be appended to
 *   this base URL to create the widget URL. The default value of this property is "/widgets"</dd>
 *   <dt>features</dt>
 *   <dd>The features supported by the implementation; this should be supplied as IRIs e.g. "http://wave.google.com". The features
 *   are matched against features requested by the widget; if the widget requires features that are unsupported, an Exception will be
 *   thrown when parsing the widget package. The default value of this property is an empty string array.</dd>
 * </dl>
 * 
 */
public class W3CWidgetFactory : Object {
		
	// this value is set by the parser
	private File unzippedWidgetDirectory;
	private File outputDirectory;
	private IStartPageProcessor startPageProcessor;
	private string[] locales;
	private string localPath;
	private string[] features;
	private string[] encodings;

	/**
	 * Set the features to be included when parsing widgets
	 * @param features
	 */
	public void setFeatures(string[] features) {
		this.features = features;
	}

	public W3CWidgetFactory(){
		// Defaults
		this.locales = new string[]{"en"};
		this.features = new string[0];
		this.localPath = "/widgets";
		this.outputDirectory = null;
		this.encodings = new string[]{"UTF-8"};
		this.startPageProcessor = null;
	}
	
	/**
	 * Set the directory to use to save widgets.
	 * @param outputDirectory
	 * @throws IOException if the directory does not exist
	 */
	public void setOutputDirectory(string outputDirectory) throws IOError {
		File file = File.new_for_path(outputDirectory);
		if (!file.query_exists()) 
			throw new IOError.NOT_FOUND("the output directory does not exist");
			
		FileInfo file_info = file.query_info (FILE_ATTRIBUTE_ACCESS_CAN_WRITE, FileQueryInfoFlags.NONE);
		bool can_write = file_info.get_attribute_boolean (FILE_ATTRIBUTE_ACCESS_CAN_WRITE);
		if (!can_write) 
			throw new IOError.PERMISSION_DENIED("the output directory cannot be written to");
		if (file.query_file_type(FileQueryInfoFlags.NONE) != FileType.DIRECTORY) 
			throw new IOError.NOT_DIRECTORY("the output directory is not a folder");
		this.outputDirectory = file;
	}

	/**
	 * Set the start page processor to use when parsing widgets
	 * @param startPageProcessor
	 */
	public void setStartPageProcessor(IStartPageProcessor startPageProcessor) {
		this.startPageProcessor = startPageProcessor;
	}

	/**
	 * Set the supported locales to be used when parsing widgets
	 * @param locales
	 */
	public void setLocales(string[] locales) {
		this.locales = locales;
	}

	/**
	 * Set the base URL to use
	 * @param localPath
	 * @throws Exception 
	 */
	public void setLocalPath(string localPath) {
		this.localPath = localPath;
	}
	
	/**
	 * Parse a given ZipFile and return a W3CWidget object representing the processed information in the package.
	 * The widget will be saved in the outputFolder.
	 * 
	 * @param zipFile
	 * @return the widget model
	 * @throws BadWidgetZipFileException if there is a problem with the zip package
	 * @throws BadManifestException if there is a problem with the config.xml manifest file in the package
	 */
	public W3CWidget parse_zip(File zipFile) throws Error, BadWidgetZipFileException, BadManifestException{
		if (outputDirectory == null) 
			throw new IOError.FAILED("No output directory has been set; use setOutputDirectory(File) to set the location to output widget files");
		return processWidgetPackage(zipFile);
	}
	
	/**
	 * Parse a widget at a given URL and return a W3CWidget object representing the processed information in the package.
	 * The widget will be saved in the outputFolder.
	 * @param url
	 * @return
	 * @throws BadWidgetZipFileException if there is a problem with the zip package
	 * @throws BadManifestException if there is a problem with the config.xml manifest file in the package
	 * @throws InvalidContentTypeException if the widget has an invalid content type
	 * @throws IOException if the widget cannot be downloaded
	 */
	public W3CWidget parse_url(URI url) throws BadWidgetZipFileException, BadManifestException, InvalidContentTypeException, IOError {
		File file = download(url,false);
		return parse_zip(file);
	}
	
	/**
	 * Parse a widget at a given URL and return a W3CWidget object representing the processed information in the package.
	 * The widget will be saved in the outputFolder.
	 * @param url
	 * @param ignoreContentType set to true to instruct the parser to ignore invalid content type exceptions
	 * @return
	 * @throws BadWidgetZipFileException if there is a problem with the zip package
	 * @throws BadManifestException if there is a problem with the config.xml manifest file in the package
	 * @throws InvalidContentTypeException if the widget has an invalid content type
	 * @throws IOException if the widget cannot be downloaded
	 */
	public W3CWidget parse(string path, bool ignoreContentType) throws BadWidgetZipFileException, BadManifestException, InvalidContentTypeException, IOError, Error{
		var url = new URI(path);
		File file = download(url, ignoreContentType);
		return parse_zip(file);
	}
	
	/**
	 * The standard MIME type for a W3C Widget
	 */
	private static const string WIDGET_CONTENT_TYPE = "application/widget";
	
	/**
	 * Download widget from given URL
	 * @param url the URL to download
	 * @param ignoreContentType if set to true, will ignore invalid content types (not application/widget)
	 * @return the File downloaded
	 * @throws InvalidContentTypeException 
	 * @throws HttpException
	 * @throws IOException
	 */
	private File download(URI url, bool ignoreContentType) throws InvalidContentTypeException, IOError {
		
		var soup_session = new SessionSync();

   		var message = new Soup.Message.from_uri ("GET", url);
   		
   		soup_session.send_message (message);
		
		string type = message.response_headers.get("Content-Type");
		if (!ignoreContentType && !type.has_prefix(WIDGET_CONTENT_TYPE)) 
			throw new InvalidContentTypeException.INVALID_CONTENT_TYPE("Problem downloading widget: expected a content type of "+WIDGET_CONTENT_TYPE+" but received:"+type);
		
		string tmp_dir = Environment.get_tmp_dir ();
		File file = File.new_for_path(@"$tmp_dir/wookie");
		
		var outstream = file.append_to (FileCreateFlags.NONE);
		outstream.write (message.response_body.data);
		outstream.close ();
		
		return file;
	}

	public void setEncodings(string[] encodings) requires (encodings.length > 0) {
		
		this.encodings = encodings;
	}

	/**
	 * Process a widget package for the given zip file
	 * @param zipFile
	 * @return a W3CWidget representing the widget
	 * @throws BadWidgetZipFileException
	 * @throws BadManifestException
	 */
	private W3CWidget processWidgetPackage(File zipFile) throws BadWidgetZipFileException, BadManifestException{
	
		string tmp_dir_path = Environment.get_tmp_dir ();
		Process.spawn_command_line_sync (@"unzip -d $tmp_dir_path -o -- $(zipFile.get_path())");
		
		File tmp_dir = File.new_for_path (tmp_dir_path);
		
		File manifest = tmp_dir.get_child (IW3CXMLConfiguration.MANIFEST_FILE);
		
		
		if (manifest.query_exists ()){
			try {
				var file_info = manifest.query_info ("*", FileQueryInfoFlags.NONE);
				int64 size = file_info.get_size();
				// read the manifest
				FileInputStream input = manifest.read();
				
				uint8[] buffer = new uint8[size];
				 input.read (buffer);
				 
				// build the model
				WidgetManifestModel widgetModel = new 
				WidgetManifestModel((string)buffer, locales, 
				features, encodings,
				tmp_dir);															

				// get the widget identifier
				string manifestIdentifier = widgetModel.getIdentifier();						
				// create the folder structure to unzip the zip into
				unzippedWidgetDirectory = outputDirectory.get_child (manifestIdentifier);
				unzippedWidgetDirectory.make_directory();
				
				// now unzip it into that folder
				Process.spawn_command_line_sync (@"unzip -d $(unzippedWidgetDirectory.get_path()) -o -- $(zipFile.get_path())");
				
				// Iterate over all start files and update paths
				foreach (IContentEntity content in widgetModel.getContentList()){
					// now update the js links in the start page
					File startFile = unzippedWidgetDirectory.get_child (content.getSrc());
					string relativestartUrl = (WidgetPackageUtils.getURLForWidget(localPath, manifestIdentifier, content.getSrc())); 					
					content.setSrc(relativestartUrl);
					if(startFile.query_exists() && startPageProcessor != null){		
						startPageProcessor.processStartFile(startFile, widgetModel, content);
					}	
				}
				if (widgetModel.getContentList().is_empty){
					throw new InvalidStartFileException.INVALID_START_FILE("Widget has no start page");
				}
				
				// get the path to the root of the unzipped folder
				string thelocalPath = WidgetPackageUtils.getURLForWidget(localPath, manifestIdentifier, "");
				// now pass this to the model which will prepend the path to local resources (not web icons)
				widgetModel.updateIconPaths(thelocalPath);				
				
				// check to see if this widget already exists in the DB - using the ID (guid) key from the manifest
				return widgetModel;
			} catch (InvalidStartFileException e) {
				throw e;
			} catch (BadManifestException e) {
				throw e;
			} catch (Error e){
				throw new BadManifestException.BAD_MANIFEST(e.message);
			}
		}
		else{
			// no manifest file found in zip archive
			throw new BadWidgetZipFileException.BAD_WIDGET_ZIP("No manifest file found in zip"); //$NON-NLS-1$ 
		}
	}
	
	public File getUnzippedWidgetDirectory() {
		return unzippedWidgetDirectory;
	}

}
}
