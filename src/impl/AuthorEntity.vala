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
using W3CWidgets.util;

using Xml;
/**
 * The <author> element
 */
public class AuthorEntity : AbstractLocalizedEntity, IElement, IAuthorEntity {
	
	private string fAuthorName;
	private string fHref;
	private string fEmail;
	
	public AuthorEntity(){
		fAuthorName = "";
		fHref = "";
		fEmail = "";
	}
	
	public AuthorEntity.with(string authorName, string href, string email) {
		base();
		fAuthorName = authorName;
		fHref = href;
		fEmail = email;
	}
	
	public string getAuthorName() {
		return fAuthorName;
	}
	
	public void setAuthorName(string authorName) {
		fAuthorName = authorName;
	}
	
	public string getHref() {
		return fHref;
	}
	
	public void setHref(string href) {
		fHref = href;
	}
	
	public string getEmail() {
		return fEmail;
	}
	
	public void setEmail(string email) {
		fEmail = email;
	}
	
	public override void fromXML(Xml.Node* element) {
		base.fromXML(element);
		fAuthorName = getLocalizedTextContent(element);		
		fHref = UnicodeUtils.normalizeSpaces(element->get_prop(IW3CXMLConfiguration.HREF_ATTRIBUTE));	
		if (fHref == "") fHref = null;
		if (!IRIValidator.isValidIRI(fHref)) fHref = null;
		fEmail = UnicodeUtils.normalizeSpaces(element->get_prop(IW3CXMLConfiguration.EMAIL_ATTRIBUTE));
		if (fEmail == "") fEmail = null;
	}

	public override Xml.Node toXml() {
		var element = new Xml.Node(Xml.NameSpace.MANIFEST, IW3CXMLConfiguration.NAME_ELEMENT);
		element.set_content(getAuthorName());
		if (getHref()!=null && getHref().length>0) element.set_prop(IW3CXMLConfiguration.HREF_ATTRIBUTE, getHref());
		if (getEmail()!=null && getEmail().length>0) element.set_prop(IW3CXMLConfiguration.EMAIL_ATTRIBUTE, getEmail());
		element = setLocalisationAttributes(element);
		return element;
	}

}
}
