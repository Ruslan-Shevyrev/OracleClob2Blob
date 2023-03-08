CREATE OR REPLACE PACKAGE BODY PKG_CONVERT AS

FUNCTION blob2clob (p_blob IN BLOB) RETURN CLOB
AS 
	n_inputlength 	NUMBER;
	n_chunklength 	NUMBER := 4000;
	c_clobinput		CLOB;
	v_chunkcontent 	VARCHAR2(4000);
BEGIN
	n_inputlength := dbms_lob.getlength(p_blob);
	IF n_inputlength > 0 THEN
		DBMS_LOB.CREATETEMPORARY(c_clobinput, TRUE);
	ELSE
		RETURN NULL;
	END IF;
	FOR i IN 1..CEIL(n_inputlength/n_chunklength) LOOP
		v_chunkcontent := utl_raw.cast_to_varchar2(dbms_lob.SUBSTR(p_blob,n_chunklength,(i-1)*n_chunklength + 1));
		DBMS_LOB.WRITEAPPEND(c_clobinput, LENGTH(v_chunkcontent), v_chunkcontent);
	END LOOP;
	RETURN c_clobinput;
END blob2clob;

FUNCTION clob2blob (p_clob IN CLOB) RETURN BLOB 
IS
	b_blob			BLOB;
	n_offset		NUMBER DEFAULT 1;
	n_amount		NUMBER DEFAULT 4096;
	n_offsetwrite 	NUMBER DEFAULT 1;
	n_amountwrite 	NUMBER;
	v_buffer 		VARCHAR2(4096 CHAR);
BEGIN
	dbms_lob.createtemporary(b_blob, TRUE);
	BEGIN
		LOOP
			dbms_lob.READ (lob_loc	=> p_clob,
							amount	=> n_amount,
							offset	=> n_offset,
							buffer	=> v_buffer);
			n_amountwrite := utl_raw.length (r => utl_raw.cast_to_raw(c => v_buffer));
			dbms_lob.WRITE (lob_loc	=> b_blob,
							amount	=> n_amountwrite,
							offset	=> n_offsetwrite,
							buffer	=> utl_raw.cast_to_raw(v_buffer));
			n_offsetwrite := n_offsetwrite + n_amountwrite;
			n_offset := n_offset + n_amount;
			n_amount := 4096;
		END LOOP;
	EXCEPTION WHEN no_data_found THEN
		NULL;
	END;
	RETURN v_blob;
END clob2blob;

FUNCTION clob2blob_cs(p_clob			IN CLOB,
						p_charset_id	IN INTEGER DEFAULT DBMS_LOB.DEFAULT_CSID) RETURN BLOB
AS
	b_blob			BLOB;
	n_dest_offset	INTEGER := 1;
	n_src_offset	INTEGER := 1;
	n_lang_context	INTEGER := DBMS_LOB.DEFAULT_LANG_CTX;
	n_warning		INTEGER;
BEGIN
	DBMS_LOB.CreateTemporary(lob_loc	=> b_blob,
							cache		=> TRUE);
						
	DBMS_LOB.CONVERTTOBLOB(dest_lob			=> b_blob,
							src_clob		=> p_clob,
							amount			=> LENGTH(p_clob),
							dest_offset		=> n_dest_offset,
							src_offset		=> n_src_offset,
							blob_csid		=> p_charset_id,
							lang_context	=> n_lang_context,
							warning			=> n_warning);
	RETURN b_blob;
END clob2blob_cs;

END PKG_CONVERT;