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

using W3CWidgets;
using W3CWidgets.exceptions;
using W3CWidgets.util;
//using org.jdom.Element;
using Xml;

namespace W3CWidgets.impl {

/**
 * @author Paul Sharples
 * @version $Id: PreferenceEntity.java,v 1.3 2009-09-02 18:37:31 scottwilson Exp $
 */
public class PreferenceEntity : ParamEntity, IElement, IPreferenceEntity {
	
	private bool fReadOnly;
	
	public PreferenceEntity() {
		base();
		fReadOnly = false;
	}

	public bool isReadOnly() {
		return fReadOnly;
	}

	public void setReadOnly(bool readOnly) {
		fReadOnly = readOnly;
	}
	
	public override void fromXML(Xml.Node* element) throws BadManifestException {
		base.fromXML(element);
		string isReadOnly = UnicodeUtils.normalizeSpaces(element->get_prop(IW3CXMLConfiguration.READONLY_ATTRIBUTE));
		if (isReadOnly == "true"){
			fReadOnly = true;
		} else {
			fReadOnly = false;
		}	
	}

	public override Xml.Node toXml() {
		var element = new Xml.Node(Xml.NameSpace.MANIFEST, IW3CXMLConfiguration.PREFERENCE_ELEMENT);
		element.new_prop(IW3CXMLConfiguration.READONLY_ATTRIBUTE, isReadOnly().to_string());
		element.new_prop(IW3CXMLConfiguration.NAME_ATTRIBUTE, getName());
		element.new_prop(IW3CXMLConfiguration.VALUE_ATTRIBUTE, getValue());
		return element;
	}
}
}
