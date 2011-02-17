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

namespace W3CWidgets.impl {


using W3CWidgets;
using W3CWidgets.exceptions;
using W3CWidgets.util;

/**
 * @author Paul Sharples
 * @version $Id: ContentEntity.java,v 1.3 2009-09-02 18:37:31 scottwilson Exp $
 */
public class ContentEntity : AbstractLocalizedEntity, IContentEntity {
	
	private string fSrc;
	private string fCharSet;
	private string fType;
	
	public ContentEntity(string src, string charSet, string type) {
		base();
		fSrc = src;
		fCharSet = charSet;
		fType = type;
	}

	public string getSrc() {
		return fSrc;
	}

	public void setSrc(string src) {
		fSrc = src;
	}

	public string? getCharSet() {
		return fCharSet;
	}

	public void setCharSet(string charSet) {
		fCharSet = charSet;
	}

	public string? getType() {
		return fType;
	}

	public void setType(string type) {
		fType = type;
	}
	

	public void fromXML_localized(Xml.Node element, string[] locales, string[] encodings, File zip) throws BadManifestException {
		
		// Src
		fSrc = UnicodeUtils.normalizeSpaces(element.get_prop(IW3CXMLConfiguration.SOURCE_ATTRIBUTE));
		// Check file exists; remove the src value if it doesn't
		try {
			fSrc = WidgetPackageUtils.locateFilePath(fSrc,locales, zip);
			setLang(WidgetPackageUtils.languageTagForPath(fSrc));
		} catch (Error e) {
			fSrc = null;
		}

		string charsetParameter = null;
		
		// Content Type
		fType = UnicodeUtils.normalizeSpaces(element.get_prop(IW3CXMLConfiguration.TYPE_ATTRIBUTE));
		if(fType == ""){
			fType = IW3CXMLConfiguration.DEFAULT_MEDIA_TYPE;
		} else {
			// Split the content type, as we may also have a charset parameter
			string[] type = fType.split(";");
			// If a type attribute is specified, and is either invalid or unsupported, we must treat it as an invalid widget
			if (!isSupported(type[0], IW3CXMLConfiguration.SUPPORTED_CONTENT_TYPES)) throw new InvalidContentTypeException.INVALID_CONTENT_TYPE ("Content type is not supported");
			fType = type[0];
			// Get the charset parameter if present
			if (type.length > 1){
				string[] charset_caca = type[type.length-1].split("=");
				charsetParameter = charset_caca[charset_caca.length-1];	
			}
		}
		
		// Charset encoding. Use encoding attribute by preference, and the use the charset parameter of the content type
		string charset = UnicodeUtils.normalizeSpaces(element.get_prop(IW3CXMLConfiguration.CHARSET_ATTRIBUTE));
		if (isSupported(charset, encodings)) setCharSet(charset);
		if (getCharSet()==null && isSupported(charsetParameter, encodings)) setCharSet(charsetParameter);		
		if (getCharSet()==null) setCharSet(IW3CXMLConfiguration.DEFAULT_CHARSET);
	}
	
	/**
	 * Checks to see if the supplied value is one of the supported values
	 * @param value
	 * @param supportedValues
	 * @return true if the value is one of the supported values
	 */
	private bool isSupported(string value, string[] supportedValues){
		bool supported = false;
		foreach (string type in supportedValues){
			if (value == type) supported = true;
		}
		return supported;
	}

	public override Xml.Node toXml() {
		Xml.Node contentElem = new Xml.Node(Xml.NameSpace.XML, IW3CXMLConfiguration.CONTENT_ELEMENT);
		contentElem.set_prop(IW3CXMLConfiguration.SOURCE_ATTRIBUTE,getSrc());
		if (getType() != null) contentElem.set_prop(IW3CXMLConfiguration.TYPE_ATTRIBUTE,getType());
		if (getCharSet() != null) contentElem.set_prop(IW3CXMLConfiguration.CHARSET_ATTRIBUTE,getCharSet());
		
		contentElem = setLocalisationAttributes(contentElem);
		return contentElem;
	}

}
}
