AM_CPPFLAGS = $(DEPENDENCIES_CFLAGS)

lib_LTLIBRARIES = libw3cwidgets.la

libw3cwidgets_la_SOURCES = \
ILocalizedEntity.vala			\
IAccessEntity.vala			\
IContentEntity.vala			\
IW3CXMLConfiguration.vala		\
IStartPageProcessor.vala		\
IDescriptionEntity.vala		\
IAuthorEntity.vala			\
INameEntity.vala			\
IElement.vala				\
IParamEntity.vala			\
IIconEntity.vala			\
W3CWidget.vala			\
IPreferenceEntity.vala		\
ILocalizedElement.vala		\
IFeatureEntity.vala			\
ILicenseEntity.vala			\
exceptions/InvalidContentTypeException.vala	\
exceptions/InvalidStartFileException.vala	\
exceptions/BadManifestException.vala	\
exceptions/BadWidgetZipFileException.vala	\
updates/InvalidUDDException.vala	\
updates/UpdateDescriptionDocument.vala\
updates/UpdateDescription.vala	\
util/Arrays.vala				\
util/libuuid.vapi			\
util/libwrapuuid.vala			\
util/WidgetOutputter.vala		\
util/LocalizationUtils.vala		\
util/UnicodeUtils.vala		\
util/NumberUtils.vala			\
util/RandomGUID.vala			\
util/ContentTypeUtils.vala		\
util/WidgetPackageUtils.vala		\
util/FormattingUtils.vala		\
util/IRIValidator.vala		\
impl/LicenseEntity.vala		\
impl/ParamEntity.vala			\
impl/AbstractLocalizedEntity.vala	\
impl/WidgetManifestModel.vala		\
impl/AuthorEntity.vala		\
impl/DescriptionEntity.vala		\
impl/IconEntity.vala			\
impl/NameEntity.vala			\
impl/PreferenceEntity.vala		\
impl/FeatureEntity.vala		\
impl/ContentEntity.vala		\
impl/AccessEntity.vala		\
W3CWidgetFactory.vala

libw3cwidgets_la_VALAFLAGS = --disable-warnings --library w3c-widgets -H w3c-widgets.h --pkg gio-2.0 --pkg libxml-2.0 --pkg gee-1.0 --pkg libsoup-2.4 --vapidir ./util -X -luuid 


CLEANFILES = *.h *.c *.vapi *.stamp *~
