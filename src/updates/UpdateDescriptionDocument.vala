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
namespace org.apache.wookie.w3c.updates {


using org.apache.wookie.w3c;
using org.apache.wookie.w3c.impl;
using org.apache.wookie.w3c.util;

using Gee;
using Xml;

/**
 * An update description document (UDD) as defined at http://www.w3.org/TR/widgets-updates
 */
public class UpdateDescriptionDocument : Object {
	
	private File updateSource;
	private string versionTag;
	private ArrayList<Details> details;
	
	
		/**
	 * Load a UDD from a URL
	 * @param href the URL to load the UDD from
	 * @throws InvalidUDDException if the UDD cannot be found, or is not valid
	 */
	public UpdateDescriptionDocument(string href) throws Updates.INVALID_UUD{
		try {
			Doc doc = Parser.parse_file(href);
			fromXML(doc);
		} catch (GLib.Error e) {
			throw new Updates.INVALID_UUD("the document is not a valid UDD");
		}
	}
	
	/**
	 * Get the details of the update, typically a short description of any new features.
	 * @param locale the preferred locale for the details
	 * @return the update details
	 */
	public string getDetails(string locale) {
		//Details localDetails = (Details) LocalizationUtils.getLocalizedElement(details.to_array(), new string[]{locale});
		return details[0].text;
	}
	
	/**
	 * Get the URL for the updated widget
	 * @return the URL
	 */
	public File getUpdateSource() {
		return updateSource;
	}
	
	/**
	 * Get the version tag for the update
	 * @return the version tag
	 */
	public string getVersionTag() {
		return versionTag;
	}

	
	/**
	 * Parse a UDD from XML
	 * @param document the XML document to parse
	 * @throws InvalidUDDException if the document is not a valid UDD
	 */
	public void fromXML(Doc document) throws Updates.INVALID_UUD{
		
		Xml.Node root;
		try {
			root = document.get_root_element();
		} catch (GLib.Error e1) {
			throw new Updates.INVALID_UUD("Root element must be <update-info>");
		}
		if (root.name != "update-info") throw new Updates.INVALID_UUD("Root element must be <update-info>");
		if (root.ns->href != IW3CXMLConfiguration.MANIFEST_NAMESPACE) throw new Updates.INVALID_UUD("Wrong namespace for Update Description Document");
		if (root.get_prop("version") == null) throw new Updates.INVALID_UUD("no version attribute");
		if (root.get_prop("src") == null) throw new Updates.INVALID_UUD("no src attribute");
		versionTag = root.get_prop("version");
		try {
			updateSource = File.new_for_uri(root.get_prop("src"));
		} catch (GLib.Error e) {
			throw new Updates.INVALID_UUD("src attribute is not a valid URL");
		}
		Xml.Node* detailsElements = root.children;
		this.details = new ArrayList<Details>();
		 for (Xml.Node* iter = root.children; iter != null; iter = iter->next) {
       
			Details detailsItem = new Details();
			detailsItem.fromXML(iter);
			this.details.add(detailsItem);
		}
	}
	
	/**
	 * Inner class used to represent Details as a localized entity
	 */
	static class Details : AbstractLocalizedEntity, IElement, ILocalizedElement, ILocalizedEntity {
		public string text{get;set; default="Details";}
		
		public Details(){
		}


		public new void fromXML(Xml.Node* element) {
			base.fromXML(element);
			this.text = getLocalizedTextContent(element);
		}

		public override Xml.Node toXml() {
			var element = new Xml.Node(IW3CXMLConfiguration.MANIFEST_NAMESPACE, "details");
			element.set_content(text);
			element = setLocalisationAttributes(element);
			return element;
		}
	}
}
}
