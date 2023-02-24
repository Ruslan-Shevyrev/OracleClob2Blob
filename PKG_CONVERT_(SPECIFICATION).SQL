CREATE OR REPLACE PACKAGE PKG_TOOL AS 

function  blob2clob(
rawinput   in blob
)
return clob;

function  clob2blob (
p_clob     in clob
)
return blob;

FUNCTION clob_to_blob(value            	IN CLOB,
						charset_id      IN INTEGER DEFAULT DBMS_LOB.DEFAULT_CSID) RETURN BLOB;

END PKG_TOOL;