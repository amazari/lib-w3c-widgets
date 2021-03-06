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
using Xml;
/**
 * The <description> element
 */
public class DescriptionEntity : AbstractLocalizedEntity, IElement, IDescriptionEntity {
	
	private string fDescription;
	
	public DescriptionEntity(){
		fDescription = "";
		setLang(null);
	}
	
	public DescriptionEntity.with(string description, string language) {
		base();
		fDescription = description;
		setLang(language);
	}
	
	public string getDescription() {
		return fDescription;
	}
	
	public void setDescription(string description) {
		fDescription = description;
	}
	
	public override void fromXML(Xml.Node* element) {
		base.fromXML(element);
		fDescription = getLocalizedTextContent(element);
	}

	public override  Xml.Node toXml() {
		var element = new Xml.Node(Xml.NameSpace.MANIFEST, IW3CXMLConfiguration.DESCRIPTION_ELEMENT);
		element.set_content(getDescription());
		element = setLocalisationAttributes(element);
		return element;
	}


}
}
