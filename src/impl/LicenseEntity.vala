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

namespace org.apache.wookie.w3c.impl {

using org.apache.wookie.w3c;
using org.apache.wookie.w3c.util;
/**
 * the <license> element
 */
 
using Xml;

public class LicenseEntity : AbstractLocalizedEntity, ILicenseEntity {
	
	private string fLicenseText;
	private string fHref;
	
	public LicenseEntity(){
		fLicenseText = "";
	}
	
	public LicenseEntity.with(string licenseText, string href, string language, string dir) {
		base();
		fLicenseText = licenseText;
		fHref = href;
		setDir(dir);
		setLang(language);
	}

	public string getLicenseText() {
		return fLicenseText;
	}

	public void setLicenseText(string licenseText) {
		fLicenseText = licenseText;
	}

	public string getHref() {
		return fHref;
	}

	public void setHref(string href) {
		fHref = href;
	}
	
	public void fromXML(Xml.Node element) {
		base.fromXML(element);
		fLicenseText = getLocalizedTextContent(element);
		fHref = UnicodeUtils.normalizeSpaces(element.get_prop(IW3CXMLConfiguration.HREF_ATTRIBUTE));		
		if (fHref == "") fHref = null;
	}

	public override Xml.Node toXml() {
		var element = new Xml.Node(IW3CXMLConfiguration.LICENSE_ELEMENT, IW3CXMLConfiguration.MANIFEST_NAMESPACE);
		element.set_content(getLicenseText());
		if (getHref()!=null && getHref().length>0) element.set_prop(IW3CXMLConfiguration.HREF_ATTRIBUTE, getHref());
		element = setLocalisationAttributes(element);
		return element;
	}

}
}
