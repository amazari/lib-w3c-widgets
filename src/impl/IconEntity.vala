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
 * @version $Id: IconEntity.java,v 1.3 2009-09-02 18:37:31 scottwilson Exp $
 */
public class IconEntity : AbstractLocalizedEntity, IIconEntity{
	
	private string fSrc;
	private int fHeight;
	private int fWidth;
	
	public IconEntity(){
		fSrc = "";
		fHeight = 0;
		fWidth = 0;
	}
	
	public IconEntity.with(string src, int height, int width) {
		base();
		fSrc = src;
		fHeight = height;
		fWidth = width;
	}
	
	public string getSrc() {
		return fSrc;
	}
	public void setSrc(string src) {
		fSrc = src;
	}
	public int getHeight() {
		return fHeight;
	}
	public void setHeight(int height) {
		fHeight = height;
	}
	public int getWidth() {
		return fWidth;
	}
	public void setWidth(int width) {
		fWidth = width;
	}
	
	public new void fromXML(Xml.Node* element){
	}
	
	public void fromXML_localized(Xml.Node element,string[] locales, File zip) throws BadManifestException{		
		// src is required
		fSrc = UnicodeUtils.normalizeSpaces(element.get_prop(IW3CXMLConfiguration.SOURCE_ATTRIBUTE));

		// Check custom icon file exists; remove the src value if it doesn't
		try {
			fSrc = WidgetPackageUtils.locateFilePath(fSrc,locales, zip);
			setLang(WidgetPackageUtils.languageTagForPath(fSrc));
		} catch (Error e) {
			fSrc = null;
		}
		try {
			if (!ContentTypeUtils.isSupportedImageType(fSrc)) fSrc = null;
		} catch (Error e1) {
			print (e1.message);
		}

		// height is optional
		string height  = element.get_prop(IW3CXMLConfiguration.HEIGHT_ATTRIBUTE);
		if(height != null){
			try { 
				fHeight = NumberUtils.processNonNegativeInteger(height); 
			} catch (Error e) { 
				// Not a valid number - pass through without setting 
			} 
		}

		// width is optional
		string width  = element.get_prop(IW3CXMLConfiguration.WIDTH_ATTRIBUTE);
		if(width != null){
			try {
				fWidth = NumberUtils.processNonNegativeInteger(width); 
			} catch (Error e) {
				// Not a valid number - pass through without setting 
			}
		}
	}

	public override Xml.Node toXml() {
		var element = new Xml.Node(Xml.NameSpace.MANIFEST, IW3CXMLConfiguration.ICON_ELEMENT);
		element.set_prop(IW3CXMLConfiguration.SOURCE_ATTRIBUTE, getSrc());
		if (getHeight() > 0) element.set_prop(IW3CXMLConfiguration.HEIGHT_ATTRIBUTE,getHeight().to_string());
		if (getWidth() > 0) element.set_prop(IW3CXMLConfiguration.WIDTH_ATTRIBUTE,getWidth().to_string());
		return element;
	}


}
}
