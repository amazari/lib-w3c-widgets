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

/**
 * i18n formatting utilities
 * 
 * The methods in this class can be used to generate i18n strings using
 * CSS bidi properties for use in display. This involves inserting HTML 
 * <span> tags containing CSS styling properties for text direction
 * 
 */
public class FormattingUtils {
	
	/**
	 * Returns the CSS formatted i18n string for the widget name
	 * @param name the Widget's Name entity
	 * @return a CSS-formatted i18n string
	 */
	public static string getFormattedWidgetName(INameEntity name){
		return getFormattedWithDirection(name.getDir(), name.getName());
	}
	/**
	 * Returns the CSS formatted i18n string for the widget short name
	 * @param name the Widget's Name entity
	 * @return a CSS-formatted i18n string
	 */
	public static string getFormattedWidgetShortName(INameEntity name){
		return getFormattedWithDirection(name.getDir(), name.getShort());
	}
	/**
	 * Returns the CSS formatted i18n string for the widget version
	 * @param widget the Widget
	 * @return a CSS-formatted i18n string
	 */
	public static string getFormattedWidgetVersion(W3CWidget widget){
		return getFormattedWithDirection(widget.getDir(), widget.getVersion());
	}
	/**
	 * Returns the CSS formatted i18n string for the widget description
	 * @param description the Widget's description entity
	 * @return a CSS-formatted i18n string
	 */
	public static string getFormattedWidgetDescription(IDescriptionEntity description){
		return getFormattedWithDirection(description.getDir(), description.getDescription());
	}
	/**
	 * Returns the CSS formatted i18n string for the widget author's name
	 * @param author the Widget's author entity
	 * @return a CSS-formatted i18n string
	 */
	public static string getFormattedWidgetAuthor(IAuthorEntity author){
		return getFormattedWithDirection(author.getDir(), author.getAuthorName());
	}
	/**
	 * Returns the CSS formatted i18n string for the widget license
	 * @param license the Widget's License entity
	 * @return a CSS-formatted i18n string
	 */
	public static string getFormattedWidgetLicense(ILicenseEntity license){
		return getFormattedWithDirection(license.getDir(), license.getLicenseText());
	}

	/**
	 * Generates a CSS i18n string from a raw string. Only use this
	 * method where the only possible directional information is inline
	 * and you want to ensure that embedded "dir" attributes are correctly
	 * formatted
	 * 
	 * @param value
	 * @return a CSS i18n string
	 */
	protected static string getFormatted(string value){
		string result;
		// Reformat embedded SPAN tags
		result = reformatSpan(value);
		return result;
	}
	
	/**
	 * Generates a CSS i18n string using a given direction and value
	 * @param dir the text direction
	 * @param value the value to modify
	 * @return a CSS i18n string
	 */
	protected static string getFormattedWithDirection(string dir, string value){
		
		// If the string has no embedded spans with dir attributes, and no set dir, just return the string
	if (dir == null && !value.contains("dir=")) return value;
		string result;
		string mode = "embed";
		if (dir == null) dir = "ltr";
		// Reformat embedded SPAN tags
		result = reformatSpan(value);
		// Apply DIR to the string
		if (dir == "lro") {dir = "ltr"; mode="bidi-override";};
		if (dir == "rlo") {dir = "rtl"; mode="bidi-override";};
		return "<span style=\"unicode-bidi:"+mode+"; direction:"+dir+"\">"+result+"</span>";
	}
	
	/**
	 * Reformats any embedded <span dir="xyz"> tags to use
	 * CSS BIDI properties
	 * @param value
	 * @return a string with corrected BIDI properties
	 */
	private static string reformatSpan(string value){

		string result = value;
		string mode="embed";
		if (value.contains("lro")){
			result = value.replace("lro", "ltr");	
			mode = "bidi-override";
		}
		if (value.contains("rlo")){
			result = value.replace("rlo", "rtl");	
			mode = "bidi-override";
		}
		
		result = result.replace("span dir=\"", "span style=\"unicode-bidi:"+mode+"; direction:");

		return result;
	}

}
}