CREATE OR REPLACE PACKAGE BODY DBADMINDATA.PKG_CONVERT AS

function blob2clob (
        rawinput    in    blob 
) 
return clob
as
    inputlength  number;
    chunklength  number               := 4000;
    clobinput    clob;
    chunkcontent varchar2(4000);
begin
    inputlength := dbms_lob.getlength(rawinput);
    if inputlength > 0 then
        DBMS_LOB.CREATETEMPORARY(clobinput, TRUE);
    else 
      return null;
    end if;
    for i in 1..ceil(inputlength/chunklength) loop
        chunkcontent := utl_raw.cast_to_varchar2(dbms_lob.substr(rawinput,chunklength,(i-1)*chunklength + 1));
        DBMS_LOB.WRITEAPPEND(clobinput, length(chunkcontent), chunkcontent);
    end loop;
    return clobinput;
end blob2clob;

function clob2blob (p_clob IN CLOB) 
RETURN BLOB IS
  v_blob BLOB;
  v_offset NUMBER DEFAULT 1;
  v_amount NUMBER DEFAULT 4096;
  v_offsetwrite NUMBER DEFAULT 1;
  v_amountwrite NUMBER;
  v_buffer VARCHAR2(4096 CHAR);
BEGIN dbms_lob.createtemporary(v_blob, TRUE);
  Begin
    LOOP
      dbms_lob.READ (lob_loc => p_clob,
        amount  => v_amount,
        offset  => v_offset,
        buffer  => v_buffer);
      v_amountwrite := utl_raw.length (r => utl_raw.cast_to_raw(c => v_buffer));
      dbms_lob.WRITE (lob_loc => v_blob,
        amount  => v_amountwrite,
        offset  => v_offsetwrite,
        buffer  => utl_raw.cast_to_raw(v_buffer));
      v_offsetwrite := v_offsetwrite + v_amountwrite;
      v_offset := v_offset + v_amount;
      v_amount := 4096;
    END LOOP;
  EXCEPTION
    WHEN no_data_found THEN
    NULL;
  End;
  RETURN v_blob;
END clob2blob;

END PKG_CONVERT;