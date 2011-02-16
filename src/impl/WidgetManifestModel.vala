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




using org.apache.wookie.w3c.updates;
using org.apache.wookie.w3c.util;
using org.apache.wookie.w3c;
using org.apache.wookie.w3c.exceptions;
using org.apache.wookie.w3c.util;

using Xml;
using Gee;
/**
 * Processes a config.xml document to create a model
 * for a widget, including all sub-objects
 * @author Paul Sharples
 */
public class WidgetManifestModel : AbstractLocalizedEntity, W3CWidget {
	
	private string fIdentifier;
	private string fVersion;
	private int fHeight;
	private int fWidth;
	private string fViewModes;
	private string[] features;
	private Gee.List<INameEntity> fNamesList;
	private Gee.List<IDescriptionEntity> fDescriptionsList;
	private IAuthorEntity fAuthor;
	private Gee.List<ILicenseEntity> fLicensesList;
	private Gee.List<IIconEntity> fIconsList;
	private Gee.List<IAccessEntity> fAccessList;
	private Gee.List<IContentEntity> fContentList;
	private Gee.List<IFeatureEntity> fFeaturesList;
	private Gee.List<IPreferenceEntity> fPreferencesList;
	private string fUpdate;
	
	private string[] supportedEncodings;
	
	private File zip;
	
	/**
	 * Constructs a new WidgetManifestModel using an XML manifest supplied as a string.
	 * @param xmlText the XML manifest file
	 * @throws JDOMException
	 * @throws IOException
	 * @throws BadManifestException
	 */
	public WidgetManifestModel (string xmlText, string[] locales, string[] features, string[] encodings, File zip) throws GLib.Error, IOError, BadManifestException {		
		base();		
		this.zip = zip;
		this.features = features;
		this.supportedEncodings = encodings;
		fNamesList = new ArrayList<INameEntity>();
		fDescriptionsList = new ArrayList<IDescriptionEntity>();
		fLicensesList = new ArrayList<ILicenseEntity>();
		fIconsList = new ArrayList<IIconEntity>();
		fContentList = new ArrayList<IContentEntity>();
		fAccessList = new ArrayList<IAccessEntity>();
		fFeaturesList = new ArrayList<IFeatureEntity>();
		fPreferencesList = new ArrayList<IPreferenceEntity>();
		Xml.Node root;
		try {
			root = Parser.parse_doc(xmlText)->get_root_element ();
		} catch (GLib.Error e) {
			throw new BadManifestException.BAD_MANIFEST("Config.xml is not well-formed XML");
		}				
		fromXML_localized(root,locales);	
		
		// Add default icons
		foreach (string iconpath in WidgetPackageUtils.getDefaults(zip, locales,IW3CXMLConfiguration.DEFAULT_ICON_FILES)){
			if (iconpath != null) {
				// don't add it if its a duplicate
				bool exists = false;
				foreach (IIconEntity icon in fIconsList){
					if (icon.getSrc() == iconpath) exists = true;
				}
				if (!exists){
					IconEntity i = new IconEntity();
					i.setLang(WidgetPackageUtils.languageTagForPath(iconpath));
					i.setSrc(iconpath);
					fIconsList.add(i);	
				}
			}
		}
		
		// Add default start files
		foreach (string startpath in WidgetPackageUtils.getDefaults(zip, locales,IW3CXMLConfiguration.START_FILES)){
			if (startpath != null) {
				// don't add it if its a duplicate
				bool exists = false;
				foreach (IContentEntity content in fContentList){
					if (content.getSrc() == startpath) exists = true;
				}
				if (!exists){
					ContentEntity c = new ContentEntity("","","");
					c.setLang(WidgetPackageUtils.languageTagForPath(startpath));
					c.setSrc(startpath);
					c.setCharSet(IW3CXMLConfiguration.DEFAULT_CHARSET);
					// Set the default content type
					if (startpath.has_suffix(".htm") || startpath.has_suffix(".html")) c.setType("text/html");
					if (startpath.has_suffix(".xht") || startpath.has_suffix(".xhtml")) c.setType("application/xhtml+xml");
					if (startpath.has_suffix(".svg")) c.setType("image/svg+xml");
					fContentList.add(c);	
				}
			}
		}
	}

	public string getViewModes() {
		return fViewModes;
	}
	
	public string getVersion() {
		return fVersion;
	}
	
	public Gee.List<IPreferenceEntity> getPrefences(){
		return fPreferencesList;
	}
	
	public Gee.List<IFeatureEntity> getFeatures(){
		return fFeaturesList;
	}
	
	public Gee.List<IAccessEntity> getAccessList(){
		return fAccessList;
	}
	
	public IAuthorEntity getAuthor(){
		return fAuthor;
	}

	public Gee.List<IContentEntity> getContentList() {
		return fContentList;
	}
	
	public Gee.List<IDescriptionEntity> getDescriptions(){
		return fDescriptionsList;
	}
	
	public Gee.List<INameEntity> getNames() {
		return fNamesList;
	}
	
	public Gee.List<IIconEntity> getIconsList() {
		return fIconsList;
	}

	public Gee.List<ILicenseEntity> getLicensesList() {
		return fLicensesList;
	}

	public string getIdentifier() {
		return fIdentifier;
	}

	public int getHeight() {
		return fHeight;
	}

	public int getWidth() {
		return fWidth;
	}
	
	public string getUpdate(){
		return fUpdate;
	}
	
	public void fromXML(Xml.Node element){
		warning("WidgetManifestModel.fromXML() called with no locales");
		try {
			fromXML(element);
		} catch (BadManifestException e) {
			error("WidgetManifestModel.fromXML() called with no locales and Bad Manifest");
		}
	}

	public string getLocalName(string locale){
		INameEntity name = (INameEntity)LocalizationUtils.getLocalizedElement((ILocalizedElement[])fNamesList.to_array(), new string[]{locale});
		if (name != null) return name.getName();
		return IW3CXMLConfiguration.UNKNOWN;
	}

	public void updateIconPaths(string path){
		foreach (IIconEntity icon in fIconsList){
			if(!icon.getSrc().has_prefix("http:")) icon.setSrc(path + icon.getSrc());
		}
	}

	
	public void fromXML_localized(Xml.Node element, string[] locales) throws BadManifestException {						
		// check the namespace uri 
		if(element.ns->href != IW3CXMLConfiguration.MANIFEST_NAMESPACE){			
			throw new BadManifestException.BAD_MANIFEST("'"+element.ns->href
					+ "' is a bad namespace. (Should be '" + IW3CXMLConfiguration.MANIFEST_NAMESPACE +"')");
		}				
		// IDENTIFIER IS OPTIONAL
		fIdentifier = element.get_prop(IW3CXMLConfiguration.ID_ATTRIBUTE);
		if(fIdentifier == null){
			// try the old one
			fIdentifier = element.get_prop(IW3CXMLConfiguration.UID_ATTRIBUTE);
		}
		// Normalize spaces
		if(fIdentifier != null) fIdentifier = UnicodeUtils.normalizeSpaces(fIdentifier);
		// Not a valid IRI?
		if (!IRIValidator.isValidIRI(fIdentifier)){
			fIdentifier = null;
		}
		if(fIdentifier == null){
			//give up & generate one
			RandomGUID r = new RandomGUID();
			fIdentifier = "http://incubator.apache.org/wookie/generated/" + r.tostring();
		}
		// VERSION IS OPTIONAL		
		fVersion = UnicodeUtils.normalizeSpaces(element.get_prop(IW3CXMLConfiguration.VERSION_ATTRIBUTE));
		
		// HEIGHT IS OPTIONAL	
		string height  = element.get_prop(IW3CXMLConfiguration.HEIGHT_ATTRIBUTE);
		if(height != null){
			try { 
				fHeight = NumberUtils.processNonNegativeInteger(height); 
			} catch (GLib.Error e) { 
				// Not a valid number - pass through without setting 
			} 
		}

		// WIDTH IS OPTIONAL		
		string width  = element.get_prop(IW3CXMLConfiguration.WIDTH_ATTRIBUTE);
		if(width != null){
			try { 
				fWidth = NumberUtils.processNonNegativeInteger(width); 
			} catch (GLib.Error e) { 
				// Not a valid number - pass through without setting 
			} 
		}

		// VIEWMODES IS OPTIONAL	
		fViewModes = element.get_prop(IW3CXMLConfiguration.MODE_ATTRIBUTE);
		if(fViewModes == null){
			fViewModes = IW3CXMLConfiguration.DEFAULT_VIEWMODE;
		} else {
			fViewModes = UnicodeUtils.normalizeSpaces(fViewModes);
			string modes = "";
			// remove any unsupported modes
			foreach (string mode in fViewModes.split(" ")){
				if (Arrays.contains (IW3CXMLConfiguration.VIEWMODES, mode))
				 modes = modes + mode +" ";
			}
			fViewModes = modes.chug ();
		}
		// DIR and XML:LANG ARE OPTIONAL
		base.fromXML(element);
		

		
		// parse the children
		bool foundContent = false;
		Xml.Node* iter = element.children;
		for (; iter != null; iter = iter->next) {
			string tag = iter->name;			

			// NAME IS OPTIONAL - get the name elements (multiple based on xml:lang)
			if(tag == IW3CXMLConfiguration.NAME_ELEMENT) {				
				INameEntity aName = new NameEntity();
				aName.fromXML(iter);				
				// add it to our list only if its not a repetition of an
				// existing name for the locale
				if (isFirstLocalizedEntity(fNamesList,aName)) fNamesList.add(aName);
			}
			
			// DESCRIPTION IS OPTIONAL multiple on xml:lang
			if(tag == IW3CXMLConfiguration.DESCRIPTION_ELEMENT) {				
				IDescriptionEntity aDescription = new DescriptionEntity();
				aDescription.fromXML(iter);
				// add it to our list only if its not a repetition of an
				// existing description for the locale and the language tag is valid
				if (isFirstLocalizedEntity(fDescriptionsList,aDescription) && aDescription.isValid()) fDescriptionsList.add(aDescription);
			}
			
			// AUTHOR IS OPTIONAL - can only be one, ignore subsequent repetitions
			if(tag == IW3CXMLConfiguration.AUTHOR_ELEMENT && fAuthor == null) {
				fAuthor = new AuthorEntity();
				fAuthor.fromXML(iter);
			}	
			
			// UDPATE DESCRIPTION IS OPTONAL - can only be one, ignore subsequent repetitions
			if(tag == IW3CXMLConfiguration.UPDATE_ELEMENT && fUpdate == null) {
				UpdateDescription update = new UpdateDescription("");
				update.fromXML(iter);
				// It must have a valid HREF attribute, or it is ignored
				if (update.getHref() != null) fUpdate = update.getHref();
			}	
		
			// LICENSE IS OPTIONAL - can be many
			if(tag == IW3CXMLConfiguration.LICENSE_ELEMENT) {				
				ILicenseEntity aLicense = new LicenseEntity();
				aLicense.fromXML(iter);
				// add it to our list only if its not a repetition of an
				// existing entry for the locale and the language tag is valid
				if (isFirstLocalizedEntity(fLicensesList,aLicense) && aLicense.isValid()) fLicensesList.add(aLicense);
			}
			
			// ICON IS OPTIONAL - can be many
			if(tag == IW3CXMLConfiguration.ICON_ELEMENT) {						
				IIconEntity anIcon = new IconEntity();
				anIcon.fromXML(iter,locales,zip);
				if (anIcon.getSrc()!=null) fIconsList.add(anIcon);
			}
			
			// ACCESS IS OPTIONAL  can be many 
			if(tag == IW3CXMLConfiguration.ACCESS_ELEMENT) {											
				IAccessEntity access = new AccessEntity();
				access.fromXML(iter);
				if (access.getOrigin()!=null){
					if (access.getOrigin() =="*") {
						fAccessList.insert(0, access);
					} else {
						fAccessList.add(access);
					}
				}
			}
			
			// CONTENT IS OPTIONAL - can be 0 or 1
			if(tag == IW3CXMLConfiguration.CONTENT_ELEMENT) {	
				if (!foundContent){
					foundContent = true;
					IContentEntity aContent = new ContentEntity("", "", "");	
					aContent.fromXML(iter,locales,supportedEncodings,zip);
					if (aContent.getSrc()!=null) fContentList.add(aContent);
				}
			}
			
			// FEATURE IS OPTIONAL - can be many
			if(tag == IW3CXMLConfiguration.FEATURE_ELEMENT) {
				IFeatureEntity feature = new FeatureEntity.from_strings(this.features);
				feature.fromXML(iter);
				if (feature.getName()!=null) fFeaturesList.add(feature);
			}
			
			// PREFERENCE IS OPTIONAL - can be many
			if(tag == IW3CXMLConfiguration.PREFERENCE_ELEMENT) {
				IPreferenceEntity preference = new PreferenceEntity();
				preference.fromXML(iter);
				// Skip preferences without names
				if (preference.getName() != null){
					// Skip preferences already defined
					bool found = false;
					foreach (IPreferenceEntity pref in getPrefences())
					{
						if (pref.getName() == preference.getName()) found = true;
					}
					if (!found) fPreferencesList.add(preference);
				}
			}
			
		}
	}

	/**
	 * Checks to see if the given list already contains an ILocalizedEntity
	 * with a language that matches that of the given entity. If it does, then the
	 * method returns false.
	 * @param list a list of ILocalizedEntity instances
	 * @param ent an ILocalizedEntity
	 * @return true if the list contains an entity with matching language
	 */
	
	private bool isFirstLocalizedEntity(Gee.List list, ILocalizedEntity ent){
		bool first = true;
		foreach (ILocalizedEntity entity in (ILocalizedEntity[])list.to_array())
			if (entity.getLang() == ent.getLang()) first = false;
		return first;
	}

	public override Xml.Node toXml() {
		Xml.Node widgetElem = new Xml.Node(IW3CXMLConfiguration.WIDGET_ELEMENT,IW3CXMLConfiguration.MANIFEST_NAMESPACE);
		widgetElem.set_prop(IW3CXMLConfiguration.ID_ATTRIBUTE, getIdentifier());
		if (getVersion() != null && getVersion().length > 0) widgetElem.set_prop(IW3CXMLConfiguration.VERSION_ATTRIBUTE, getVersion());
		if (getHeight() > 0) widgetElem.set_prop(IW3CXMLConfiguration.HEIGHT_ATTRIBUTE,getHeight().to_string());
		if (getWidth() > 0) widgetElem.set_prop(IW3CXMLConfiguration.WIDTH_ATTRIBUTE,getWidth().to_string());
		if (getViewModes() != null) widgetElem.set_prop(IW3CXMLConfiguration.MODE_ATTRIBUTE, getViewModes());
		
		
		// Name
		foreach (INameEntity name in getNames()){
			Xml.Node nameElem = name.toXml();
			widgetElem.add_child(nameElem);
		}
		// Description
		foreach (IDescriptionEntity description in getDescriptions()){
			widgetElem.add_child(description.toXml());
		}
		// Author
		if (getAuthor() != null) widgetElem.add_child(getAuthor().toXml());
		
		// Update
		if (getUpdate()!= null){
			widgetElem.add_child(new UpdateDescription(getUpdate()).toXML());
		}
		
		
		// Licenses
		foreach (ILicenseEntity license in getLicensesList()){
			widgetElem.add_child(license.toXml());
		}
		
		// Icons
		foreach (IIconEntity icon in getIconsList()){
			Xml.Node iconElem = icon.toXml();
			widgetElem.add_child(iconElem);				
		}
		
		// Access 
		foreach (IAccessEntity access in getAccessList()){
			Xml.Node accessElem = access.toXml();
			widgetElem.add_child(accessElem);
		}
		
		// Content
		foreach (IContentEntity content in getContentList()){
			Xml.Node contentElem = content.toXml();
			widgetElem.add_child(contentElem);			
		}
		
		// Features
		foreach (IFeatureEntity feature in getFeatures()){
			widgetElem.add_child(feature.toXml());
		}
			
		// Preferences
		foreach (IPreferenceEntity preference in getPrefences()){
			widgetElem.add_child(preference.toXml());
		}
		
		return widgetElem;
	}
}
}
