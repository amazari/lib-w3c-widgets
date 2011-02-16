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
 * the <name> element
 */
public class NameEntity : AbstractLocalizedEntity, INameEntity {

	private string fName;
	private string fShort;

	
	public NameEntity(){
		fName = "";
		fShort = "";
		setLang(null);
	}
	
	public NameEntity.with(string name, string short1, string language) {
		base();
		fName = name;
		fShort = short1;
		setLang(language);
	}
	
	public string getName() {
		return fName;
	}
	
	public void setName(string name) {
		fName = name;
	}
	
	public string getShort() {
		return fShort;
	}
	
	public void setShort(string short1) {
		fShort = short1;
	}
	
	public void fromXML(Xml.Node element) {		
		base.fromXML(element);
		// Get the text value of name
		fName = getLocalizedTextContent(element);
		// Get the short attribute (if exists)
		fShort = UnicodeUtils.normalizeSpaces(element.get_prop(IW3CXMLConfiguration.SHORT_ATTRIBUTE));
	}
	
	public override Xml.Node toXml() {
		Xml.Node nameElem = new Xml.Node(IW3CXMLConfiguration.NAME_ELEMENT, IW3CXMLConfiguration.MANIFEST_NAMESPACE);
		nameElem.set_content(getName());
		if (getShort() != null && getShort().length > 0) nameElem.set_prop(IW3CXMLConfiguration.SHORT_ATTRIBUTE, getShort());
		nameElem = setLocalisationAttributes(nameElem);
		return nameElem;
	}

}
}
