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

using Xml;
/**
 * Abstract base class for entities containing i18n or l10n content, including
 * utility methods for extracting and processing text that uses language tags
 * and text direction (e.g. RTL)
 */
public abstract class AbstractLocalizedEntity : IElement, ILocalizedElement, ILocalizedEntity {
	
	static string LEFT_TO_RIGHT = "ltr";
	static string RIGHT_TO_LEFT = "rtl";
	static string LEFT_TO_RIGHT_OVERRIDE = "lro";
	static string RIGHT_TO_LEFT_OVERRIDE = "rlo";
	
	/**
	 * a Language string conforming to BCP47
	 */
	protected string lang;
	/**
	 * Text direction conforming to http://www.w3.org/TR/2007/REC-its-20070403/
	 */
	protected string dir;
	
	public string getLang() {
		return lang;
	}
	
	/**
	 * Set the language tag for the object
	 * @param language the language tag to set; this should be a valid BCP-47 language tag
	 */
	public void setLang(string lang) {
		this.lang = lang;
	}
	
	public string getDir() {
		return dir;
	}
	
	public void setDir(string dir) {
		this.dir = dir;
	}
	
	public abstract Xml.Node toXml();
	
	/**
	 * Checks whether the language tag for the entity is OK.
	 * A null value is OK, as is a BCP47 tag
	 */
	public bool isValid(){
		if (getLang() == null) return true;
		if (LocalizationUtils.isValidLanguageTag(getLang())) return true;
		return false;
	}
	
	/* (non-Javadoc)
	 * @see org.apache.wookie.manifestmodel.IManifestModelBase#fromXML(org.jdom.Element)
	 */
	public void fromXML(Xml.Node element) {
		string lang =  UnicodeUtils.normalizeSpaces(element.get_ns_prop(IW3CXMLConfiguration.LANG_ATTRIBUTE, "xml"));
		if (lang != "") setLang(lang);
		dir = getTextDirection(element);
	}

	/**
	 * Returns the text content of an element, recursively adding
	 * any text nodes found in its child nodes AND any <span> elements
	 * that include localization information
	 * @param element
	 * @return a string containing the element text
	 */
	public static string getLocalizedTextContent(Xml.Node element){
		var content = new StringBuilder();
		
		Xml.Node* iter = element.children;
		for (;iter != null; iter = iter->next){
			if (iter->type == ElementType.ELEMENT_NODE){
				Xml.Node xml_node = iter;
				if (xml_node.get_prop("dir")!= null || 
				    xml_node.get_prop("lang")!= null && 
				    xml_node.name =="span") {
					
					content.append (@"<span dir='$(getTextDirection(xml_node))'");
					string lang = xml_node.get_prop ("lang");
					if (lang != null)
					{
						content.append(@" xml:lang='$lang'");
					}
					content.append(">");
					content.append(getLocalizedTextContent(xml_node));
					content.append("</span>");
				} else {
					content.append(getLocalizedTextContent(xml_node));
				}
			}
			if (iter->type == ElementType.TEXT_NODE){
				content.append(iter->content);
			}
		}
		return UnicodeUtils.normalizeWhitespace(content.str);
	}
	
	
	/**
	 * Returns the direction (rtl, ltr, lro, rlo) of the child text of an element
	 * @param element the element to parse
	 * @return the string "ltr", "rtl", "lro" or "rlo"
	 */
	public static string getTextDirection(Xml.Node element){
		try {
			string dir = element.get_prop(IW3CXMLConfiguration.DIR_ATRRIBUTE);
			if (dir == null){
				if (element.parent == null) return LEFT_TO_RIGHT;
				return getTextDirection(element.parent);
			} else {
				string dirValue = UnicodeUtils.normalizeSpaces(dir);
				if (dirValue == "rtl") return RIGHT_TO_LEFT;
				if (dirValue =="ltr") return LEFT_TO_RIGHT;
				if (dirValue == "rlo") return RIGHT_TO_LEFT_OVERRIDE;
				if (dirValue =="lro") return LEFT_TO_RIGHT_OVERRIDE;
				return getTextDirection(element.parent);			
			}
		} catch (Xml.Error e) {
			// In the case of an error we always return the default value
			return LEFT_TO_RIGHT;
		}
	}

	/**
	 * Set the dir and lang attributes of an element representing the entity - used when marshalling an entity to XML
	 * @param element the element to add attributes to
	 * @return the element with dir and lang attributes added if appropriate
	 */
	protected Xml.Node setLocalisationAttributes(Xml.Node element){
		if (getDir() != null) element.set_prop(IW3CXMLConfiguration.DIR_ATRRIBUTE,getDir());
		if (getLang() != null) {
		 element.set_ns_prop(IW3CXMLConfiguration.LANG_ATTRIBUTE,getLang(), "xml");
		 }
		return element;
	}

}
}
