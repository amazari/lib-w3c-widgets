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

using Xml;
/**
 * @author Paul Sharples
 * @version $Id: ParamEntity.java,v 1.3 2009-09-02 18:37:31 scottwilson Exp $
 */
public class ParamEntity : Object, IParamEntity, IElement {
	
	private string fName;
	private string fValue;
	
	public ParamEntity(){
		fName = null;
		fValue = null;
	}
	
	public ParamEntity.with(string name, string value) {
		fName = name;
		fValue = value;
	}

	public string getName() {
		return fName;
	}

	public void setName(string name) {
		fName = name;
	}

	public string getValue() {
		return fValue;
	}

	public void setValue(string value) {
		fValue = value;
	}
	
	public virtual void fromXML(Xml.Node* element) throws BadManifestException {
		fName = UnicodeUtils.normalizeSpaces(element->get_prop(IW3CXMLConfiguration.NAME_ATTRIBUTE));
		if (fName == "") fName = null;
		fValue = UnicodeUtils.normalizeSpaces(element->get_prop(IW3CXMLConfiguration.VALUE_ATTRIBUTE));
		if (fValue == "") fValue = null;
	}

	public virtual Xml.Node toXml() {
		var element = new Xml.Node(Xml.NameSpace.MANIFEST, IW3CXMLConfiguration.PARAM_ELEMENT);
		element.set_prop(IW3CXMLConfiguration.NAME_ATTRIBUTE, getName());
		element.set_prop(IW3CXMLConfiguration.VALUE_ATTRIBUTE, getValue());
		return element;
	}

}
}
