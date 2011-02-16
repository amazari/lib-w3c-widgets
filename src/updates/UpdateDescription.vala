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
using org.apache.wookie.w3c.exceptions;
using org.apache.wookie.w3c.util;

/**
 * An UpdateDescription for a Widget
 */
public class UpdateDescription{
	
	private string _href;
	
	public UpdateDescription(string href){
		_href = href;
	}
	
	public string getHref() {
		return _href;
	}

	public void fromXML(Xml.Node element) throws BadManifestException {
		string href = element.get_prop("href");
		if (href != null && href != "" && IRIValidator.isValidIRI(href)){
			_href = href;
		}
	}
	
	public 
	Xml.Node toXML(){
		var element = new Xml.Node.eat_name(IW3CXMLConfiguration.MANIFEST_NAMESPACE,IW3CXMLConfiguration.UPDATE_ELEMENT);
		element.set_prop(IW3CXMLConfiguration.HREF_ATTRIBUTE, getHref());
		return element;
	}

}
}
