CREATE OR REPLACE PACKAGE BODY PKG_CONVERT AS

FUNCTION blob2clob (p_blob IN blob) RETURN CLOB 
AS 
	inputlength NUMBER;
	chunklength NUMBER := 4000;
	clobinput	CLOB;
	chunkcontent varchar2(4000);
BEGIN
	inputlength := dbms_lob.getlength(p_blob);
	IF inputlength > 0 THEN
		DBMS_LOB.CREATETEMPORARY(clobinput, TRUE);
	ELSE
		RETURN NULL;
	END IF;
	FOR i IN 1..CEIL(inputlength/chunklength) LOOP
		chunkcontent := utl_raw.cast_to_varchar2(dbms_lob.SUBSTR(p_blob,chunklength,(i-1)*chunklength + 1));
		DBMS_LOB.WRITEAPPEND(clobinput, LENGTH(chunkcontent), chunkcontent);
	END LOOP;
	RETURN clobinput;
END blob2clob;

FUNCTION clob2blob (p_clob IN CLOB) RETURN BLOB 
IS
	v_blob			BLOB;
	v_offset		NUMBER DEFAULT 1;
	v_amount		NUMBER DEFAULT 4096;
	v_offsetwrite 	NUMBER DEFAULT 1;
	v_amountwrite 	NUMBER;
	v_buffer VARCHAR2(4096 CHAR);
BEGIN
	dbms_lob.createtemporary(v_blob, TRUE);
	BEGIN
		LOOP
			dbms_lob.READ (lob_loc	=> p_clob,
							amount	=> v_amount,
							offset	=> v_offset,
							buffer	=> v_buffer);
			v_amountwrite := utl_raw.length (r => utl_raw.cast_to_raw(c => v_buffer));
			dbms_lob.WRITE (lob_loc	=> v_blob,
							amount	=> v_amountwrite,
							offset	=> v_offsetwrite,
							buffer	=> utl_raw.cast_to_raw(v_buffer));
			v_offsetwrite := v_offsetwrite + v_amountwrite;
			v_offset := v_offset + v_amount;
			v_amount := 4096;
		END LOOP;
	EXCEPTION WHEN no_data_found THEN
		NULL;
	END;
	RETURN v_blob;
END clob2blob;

FUNCTION clob_to_blob(p_clob			IN CLOB,
						charset_id	IN INTEGER DEFAULT DBMS_LOB.DEFAULT_CSID) RETURN BLOB
AS
	RESULT			BLOB;
	dest_offset		INTEGER := 1;
	src_offset		INTEGER := 1;
	lang_context	INTEGER := DBMS_LOB.DEFAULT_LANG_CTX;
	warning			INTEGER;
BEGIN
	DBMS_LOB.CreateTemporary(lob_loc	=> result,
							cache		=> TRUE);
						
	DBMS_LOB.CONVERTTOBLOB(dest_lob			=> result,
							src_clob		=> p_clob,
							amount			=> LENGTH(p_clob),
							dest_offset		=> dest_offset,
							src_offset		=> src_offset,
							blob_csid		=> charset_id,
							lang_context	=> lang_context,
							warning			=> warning);
	RETURN RESULT;
END clob_to_blob;

END PKG_CONVERT;