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

using org.apache.wookie.w3c;
using Xml;

/**
 * Used for creating a config.xml file from a Widget object
 */
public class WidgetOutputter {
	
	/**
	 * This should be set to the local path which was prepended to widgets when they were originally parsed
	 */
	private string widgetFolder;
	
	public WidgetOutputter(){
	}
	
	/**
	 * Output config.xml to a File
	 * @param widget
	 * @param file
	 * @throws IOError
	 */
	public void outputXML_to_file(W3CWidget widget, File file) throws IOError{
		Doc doc = createWidgetDocument(widget);
		FileStream output = FileStream.open (file.get_path(), "w");
		doc.dump (output);
	}
	
	/**
	 * Output config.xml to an OutputStream
	 * @param widget
	 * @param out
	 * @throws IOError
	 */
	public void outputXML(W3CWidget widget, FileStream outstream) {
		Doc doc = createWidgetDocument(widget);
		doc.dump (outstream);		
	}
	
	/**
	 * Output config.xml as a string
	 * @param widget
	 * @return
	 */
	public string outputXMLstring(W3CWidget widget){
		Doc doc = createWidgetDocument(widget);
		string serialized_widget;
		doc.dump_memory (out serialized_widget);
		return serialized_widget;
	}
	
	/**
	 * Create an XML document for the Widget
	 * @param widget
	 * @return a Document representing the Widget's config.xml
	 */
	private Doc createWidgetDocument(W3CWidget widget){
		W3CWidget local_widget = replacePaths(widget);
		Doc doc = new Doc ();
		doc.set_root_element (local_widget);
		return doc;
	}
	
	/**
	 * Makes paths in the config.xml point to local resources rather than their installed path
	 * @param widget
	 * @return
	 */
	private W3CWidget replacePaths(W3CWidget widget){
		
		// Get folder name for widget id
		string folder = WidgetPackageUtils.convertIdToFolderName(widget.getIdentifier());
		string installedPath = widgetFolder + Path.DIR_SEPARATOR_S + folder + Path.DIR_SEPARATOR_S;
		
		W3CWidget localWidget = widget;
		
		// Replace Content Src attributes
		foreach (IContentEntity content in localWidget.getContentList()){
			string src = content.getSrc();
			src = src.replace(installedPath, "");
			content.setSrc(src);
		}
		
		// Replace Icon Src attributes
		foreach (IIconEntity icon in localWidget.getIconsList()){
			string src = icon.getSrc();
			src = src.replace(installedPath, "");
			icon.setSrc(src);
		}
		
		return localWidget;
	}

	public string getWidgetFolder() {
		return widgetFolder;
	}

	public void setWidgetFolder(string widgetFolder) {
		this.widgetFolder = widgetFolder;
	}

}
}
