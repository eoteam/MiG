<?php
/*
*	CONSTANTS.PHP
*
*	Defines the constants that will be used throught the site by the other php scripts
*/

// VALID ACTION NAMES - FOR SECURITY!

$validMiGActions = array(
"getTemplates",
"sendUserInformation",
"ZipFolder",
"updateRelatedRecords",
"insertRelatedRecords",
"insertTag",
"updateTag",
"getContent",
"deleteContent",
"getTags",
"deleteRelatedRecords",
"deleteRecords",
"deleteTag",
"migSearch",
"getMedia",
"getContentUsers",
"getContentMedia",
"getContentTags",
"getContentContent",
"updateRecord",
"updateRecords",
"insertRecord",
"deleteRecord",
"getData",
"getUsers",
"validateUser",
"updateContainerPaths",
"getCustomFields",
"getCustomFieldsList",
"contentSearch",
"duplicateContent");

$validFrontEndActions = array(
"getContentTree"
);

//	ALLOWED FILETYPES FOR UPLOAD

$allowed_filetypes = array("jpg","jpeg","png","flv","mp3","pdf");

// VERBOSITY LEVELS FOR getContent() FUNCTION...


//search result
$arrVerbosity[0] = array("content.id","content.parentid","content.migtitle","content.statusid","content.is_fixed","content.templateid");


$arrVerbosity[1] = array("content.id","content.parentid","content.templateid","content.migtitle","content.statusid","content.containerpath",
"content.createdby","content.createdate","content.modifiedby",
"content.modifieddate","content.deleted","content.is_fixed","content.can_have_children","content.displayorder");

$arrVerbosity[2] = array("content.id","content.color","content.parentid","content.templateid","content.url","content.title",
"content.url","content.description2 as description","content.shortdescription","content.date","content.displayorder",
"content_mediaids.mediaids");

// add verbosity levels for specific front end


$mediaVerbosity[0] = array("media.*", "mimetypes.name as mimetype","content_media.displayorder","content_media.caption","content_media.credits", 
			"GROUP_CONCAT(DISTINCT terms.id) AS tagids", "GROUP_CONCAT(DISTINCT terms.name) AS tags",
			"GROUP_CONCAT(DISTINCT content_media.contentid) AS contentids", 
			"GROUP_CONCAT(DISTINCT content.migtitle) AS contenttitles");

$mediaVerbosity[1] = array("media.id","media.name","media.path","media.thumb","media.video_proxy","media.playtime","mimetypes.name as mimetype","media.url");			

//search
$mediaVerbosity[2] = array("media.id","media.name","media.path","media.playtime","mimetypes.name as mimetype","media.url","media.thumb",
			"GROUP_CONCAT(content_media.contentid) AS contentids", 
			"GROUP_CONCAT(content.title) AS contenttitles",
			"GROUP_CONCAT(content.date) AS contentdates",
			"GROUP_CONCAT(content.templateid) AS contenttemplateids",
			"GROUP_CONCAT(content_media.usage_type) AS usage_types");			
			
// IF CUSTOM FIELDS ARE TO BE INCLUDED IN VERBOSITY LEVEL, YOU MUST ADD A FLAG BELOW

// ex = $arrCFFlag[2] = true; (array key corresponds to verbosity key above!)

$CRYPT_SALT = 85; # any number ranging 1-255
$START_CHAR_CODE = 100; # 'd' letter

$arrCFFlag[1] = true;
$arrCFFlag[2] = true;


$htmlSymbols = array(
			"“"=>"&#147;",
			"”"=>"&#148;",
			"—"=>"&#8211;",
			"Œ" => "&#338;",  
			"œ" => "&#339;",
			"Š" => "&#352;",
			"š" => "&#353;",
			"Ÿ" => "&#376;",
			"ƒ" => "&#402;",
			"ˆ" => "&#710;",
			"˜" => "&#732;",
			"–" => "&#8211;", 
			"—" => "&#8212;", 
			"‘" => "&#8216;", 
			"’" => "&#8217;", 
			"‚" => "&#8218;", 
			"“" => "&#8220;", 
			"”" => "&#8221;", 
			"„" => "&#8222;", 
			"†" => "&#8224;", 
			"‡" => "&#8225;", 
			"•" => "&#8226;", 
			"…" => "&#8230;", 
			"‰" => "&#8240;", 
			"′" => "&#8242;", 
			"″" => "&#8243;", 
			"‹" => "&#8249;", 
			"›" => "&#8250;", 
			"‾" => "&#8254;", 
			"€" => "&#8364;", 
			"™" => "&#8482;", 
			"←" => "&#8592;", 
			"↑" => "&#8593;", 
			"→" => "&#8594;", 
			"↓" => "&#8595;", 
			"↔" => "&#8596;", 
			"↵" => "&#8629;", 
			"⌈" => "&#8968;", 
			"⌉" => "&#8969;", 
			"⌊" => "&#8970;", 
			"⌋" => "&#8971;", 
			"◊" => "&#9674;", 
			"♠" => "&#9824;", 
			"♣" => "&#9827;", 
			"♥" => "&#9829;", 
			"♦" => "&#9830;",
			"Α" => "&#913;",
			"Β" => "&#914;",
			"Γ" => "&#915;",
			"Δ" => "&#916;",
			"Ε" => "&#917;",
			"Ζ" => "&#918;",
			"Η" => "&#919;",
			"Θ" => "&#920;",
			"Ι" => "&#921;",
			"Κ" => "&#922;",
			"Λ" => "&#923;",
			"Μ" => "&#924;",
			"Ν" => "&#925;",
			"Ξ" => "&#926;",
			"Ο" => "&#927;",
			"Π" => "&#928;",
			"Ρ" => "&#929;",
			"Σ" => "&#931;",
			"Τ" => "&#932;",
			"Υ" => "&#933;",
			"Φ" => "&#934;",
			"Χ" => "&#935;",
			"Ψ" => "&#936;",
			"Ω" => "&#937;",
			"α" => "&#945;",
			"β" => "&#946;",
			"γ" => "&#947;",
			"δ" => "&#948;",
			"ε" => "&#949;",
			"ζ" => "&#950;",
			"η" => "&#951;",
			"θ" => "&#952;",
			"ι" => "&#953;",
			"κ" => "&#954;",
			"λ" => "&#955;",
			"μ" => "&#956;",
			"ν" => "&#957;",
			"ξ" => "&#958;",
			"ο" => "&#959;",
			"π" => "&#960;",
			"ρ" => "&#961;",
			"ς" => "&#962;",
			"σ" => "&#963;",
			"τ" => "&#964;",
			"υ" => "&#965;",
			"φ" => "&#966;",	
			"χ" => "&#967;",
			"ψ" => "&#968;",
			"ω" => "&#969;",
			"ϑ" => "&#977;",
			"ϒ" => "&#978;",
			"ϖ" => "&#982;",
			"∀" => "&#8704;",
			"∂" => "&#8706;",
			"∃" => "&#8707;",
			"∅" => "&#8709;",
			"∇" => "&#8711;",
			"∈" => "&#8712;",
			"∉" => "&#8713;",
			"∋" => "&#8715;",
			"∏" => "&#8719;",
			"∑" => "&#8721;",
			"−" => "&#8722;",
			"∗" => "&#8727;",
			"√" => "&#8730;",
			"∝" => "&#8733;",
			"∞" => "&#8734;",
			"∠" => "&#8736;",
			"∧" => "&#8743;",
			"∨" => "&#8744;",
			"∩" => "&#8745;",
			"∪" => "&#8746;",
			"∫" => "&#8747;",
			"∴" => "&#8756;",
			"∼" => "&#8764;",
			"≅" => "&#8773;",
			"≈" => "&#8776;",
			"≠" => "&#8800;",
			"≡" => "&#8801;",
			"≤" => "&#8804;",
			"≥" => "&#8805;",
			"⊂" => "&#8834;",
			"⊃" => "&#8835;",
			"⊄" => "&#8836;",
			"⊆" => "&#8838;",
			"⊇" => "&#8839;",
			"⊕" => "&#8853;",
			"⊗" => "&#8855;",
			"⊥" => "&#8869;",
			"⋅" => "&#8901;",								 
			            );
?>