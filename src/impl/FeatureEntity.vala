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

using Gee;

/**
 * @author Paul Sharples
 * @version $Id: FeatureEntity.java,v 1.3 2009-09-02 18:37:31 scottwilson Exp $
 */
public class FeatureEntity : Object, IFeatureEntity, IElement {
	
	private string fName;
	private bool fRequired;
	private Gee.List<IParamEntity> fParams;
	private string[] features; // the set of platform-supported features
	
	public FeatureEntity.from_strings(string[] features){
		fName = "";
		fRequired = false;
		fParams = new ArrayList<IParamEntity>();
		this.features = features;
	}
	
	public FeatureEntity.full(string name, bool required,
			Gee.List<IParamEntity> params) {
		fName = name;
		fRequired = required;
		fParams = params;
	}
	
	public FeatureEntity.simple(string name, bool required) {
		fName = name;
		fRequired = required;
		fParams = new ArrayList<IParamEntity>();
	}
	
	public bool hasParams(){
		if(fParams.size > 0){
			return true;
		}
		return false;
	}
	
	public string getName() {
		return fName;
	}
	
	public void setName(string name) {
		fName = name;
	}
	
	public bool isRequired() {
		return fRequired;
	}
	
	public void setRequired(bool required) {
		fRequired = required;
	}
	
	public Gee.List<IParamEntity> getParams() {
		return fParams;
	}
	
	public void setParams(Gee.List<IParamEntity> params) {
		fParams = params;
	}
	
	public void fromXML(Xml.Node* element) throws BadManifestException {
		fName = UnicodeUtils.normalizeSpaces(element->get_prop(IW3CXMLConfiguration.NAME_ATTRIBUTE));
		fRequired = true;
		string isRequired = UnicodeUtils.normalizeSpaces(element->get_prop(IW3CXMLConfiguration.REQUIRED_ATTRIBUTE));
		if(isRequired == "false") fRequired = false;

		if(fName == ""){
			fName = null;
		} else {
			// Not a valid IRI?
			if (!IRIValidator.isValidIRI(fName)){
				if (fRequired) {
					throw new BadManifestException.BAD_MANIFEST("Feature name is not a valid IRI");
				} else {
					fName = null;	
				}
			}
			// Not supported?
			bool supported = false;
			if (fName != null){
				foreach (string supportedFeature in features){
					if(fName == supportedFeature) supported = true; 
				}
			}
			if (!supported){
				if (fRequired){
					throw new BadManifestException.BAD_MANIFEST("Required feature is not supported");
				} else {
					fName = null;
				}
			}	
		}
		
		// parse the children (look for <param> elements)
		
		for (Xml.Node* iter = element->children; iter != null; iter = iter->next) 
		{
			
			string tag = iter->name;			

			// PARAM optional, can be 0 or many
			if(tag == IW3CXMLConfiguration.PARAM_ELEMENT) {	
				IParamEntity aParam = new ParamEntity();
				aParam.fromXML(iter);
				if (aParam.getName()!=null && aParam.getValue()!=null) 						fParams.add(aParam);
			}
		}
		
	}

	public Xml.Node toXml() {
		Xml.Node element = new Xml.Node(Xml.NameSpace.MANIFEST, IW3CXMLConfiguration.FEATURE_ELEMENT);
		element.set_prop(IW3CXMLConfiguration.NAME_ATTRIBUTE, getName());
		element.set_prop(IW3CXMLConfiguration.REQUIRED_ATTRIBUTE, isRequired().to_string());
		foreach (IParamEntity param in getParams()){
			element.add_child(param.toXml());
		}
		return element;
	}

}
}
