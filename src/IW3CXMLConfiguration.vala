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

namespace org.apache.wookie.w3c {

/**
 * Constants for widget elements found in the config.xml file
 */
public abstract interface IW3CXMLConfiguration {
	
	public abstract static const string WIDGET_ELEMENT = "widget";
		public abstract static const string ID_ATTRIBUTE = "id";  // widget
		public abstract static const string VERSION_ATTRIBUTE = "version"; // widget
		public abstract static const string MODE_ATTRIBUTE = "viewmodes"; //widget
		// Values of widget view modes
		public abstract static const string[] VIEWMODES = {"windowed", "floating", "fullscreen", "maximized", "minimized", "all"};
		public abstract static const string DEFAULT_VIEWMODE = "floating";
		
	public abstract static const string NAME_ELEMENT = "name"; // widget[0..*]
	 	public abstract static const string SHORT_ATTRIBUTE = "short"; // name
	
	public abstract static const string DESCRIPTION_ELEMENT = "description"; //widget[0..*]
	
	public abstract static const string AUTHOR_ELEMENT = "author"; // widget[0..1]
	 	public abstract static const string EMAIL_ATTRIBUTE = "email"; // author
	
	// Note that we spelled it differently to W3C originally. Oops.
	public abstract static const string LICENSE_ELEMENT = "license"; // widget [0..*]
	
	public abstract static const string ICON_ELEMENT = "icon"; // widget [0..*]
	
	public abstract static const string ACCESS_ELEMENT = "access"; // widget [0..*]
	 	public abstract static const string ORIGIN_ATTRIBUTE = "origin"; // access	
	 	public abstract static const string SUBDOMAINS_ATTRIBUTE = "subdomains"; // access
	 	public abstract static const string[] SUPPORTED_SCHEMES = {"http", "https"};
	 
	public abstract static const string CONTENT_ELEMENT = "content"; // widget [0..*]
	 	public abstract static const string TYPE_ATTRIBUTE = "type"; // content
	 	public abstract static const string CHARSET_ATTRIBUTE = "encoding"; // content
	 	public abstract static const string DEFAULT_CHARSET = "UTF-8"; // content
	 	public abstract static const string DEFAULT_MEDIA_TYPE = "text/html"; // content

	public abstract static const string FEATURE_ELEMENT = "feature";	// widget [0..*]
	 	public abstract static const string REQUIRED_ATTRIBUTE = "required"; // feature
	 	public abstract static const string PARAM_ELEMENT = "param"; // feature [0..*]
	
	public abstract static const string PREFERENCE_ELEMENT = "preference"; // widget [0..*]
	 	public abstract static const string READONLY_ATTRIBUTE = "readonly";	// preference

	public abstract static const string UPDATE_ELEMENT = "update-description";	// widget [0..1]
	
	// Re-used attributes:
	public abstract static const string HEIGHT_ATTRIBUTE = "height"; //widget, icon
	public abstract static const string WIDTH_ATTRIBUTE = "width"; //widget, icon
	public abstract static const string HREF_ATTRIBUTE = "href";  // author, license
	public abstract static const string NAME_ATTRIBUTE = "name"; //feature, param, preference
	public abstract static const string SOURCE_ATTRIBUTE = "src"; // icon, content
	public abstract static const string VALUE_ATTRIBUTE = "value"; // param, preference
	public abstract static const string LANG_ATTRIBUTE = "lang"; // any with xml:lang
	public abstract static const string DEFAULT_LANG = "en"; // any with xml:lang
	public abstract static const string DIR_ATRRIBUTE = "dir"; // any with its:dir	
	//
	// Other values used
	public abstract static const string DEFAULT_WIDGET_VERSION = "1.0";
	public abstract static const string UNKNOWN = "unknown";
 	public abstract static const string DEFAULT_ICON_PATH = "/wookie/shared/images/cog.gif";
	public abstract static const int DEFAULT_HEIGHT_SMALL = 32;
	public abstract static const int DEFAULT_WIDTH_SMALL = 32;
	public abstract static const int DEFAULT_HEIGHT_LARGE = 300;
	public abstract static const int DEFAULT_WIDTH_LARGE = 150;
	public abstract static const string MANIFEST_FILE = "config.xml";
	public abstract static const string MANIFEST_NAMESPACE = "http://www.w3.org/ns/widgets";
	public abstract static const string[] SUPPORTED_CONTENT_TYPES = {"text/html", "image/svg+xml","application/xhtml+xml"};
	public abstract static const string[] START_FILES = {"index.htm","index.html","index.svg","index.xhtml","index.xht"};
	public abstract static const string[] DEFAULT_ICON_FILES = {"icon.svg","icon.ico","icon.png","icon.gif","icon.jpg"};
	
	// Deprecated: used in early drafts of spec:
	
	/**
	 * @deprecated
	 */
	public abstract static const string UID_ATTRIBUTE = "uid";
	/**
	 * @deprecated
	 */
	public abstract static const string NETWORK_ATTRIBUTE = "network";
	/**
	 * @deprecated
	 */
	public abstract static const string PLUGINS_ATTRIBUTE = "plugin";
	/**
	 * @deprecated
	 */
	public abstract static const string START_ATTRIBUTE = "start";
	/**
	 * @deprecated
	 */
	public abstract static const string CHROME_ATTRIBUTE = "chrome";
	/**
	 * @deprecated
	 */
	public abstract static const string IMG_ATTRIBUTE = "img";
}
}
