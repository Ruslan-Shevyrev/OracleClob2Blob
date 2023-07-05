# PKG_CONVERT

Oracle DataBase convert package.

:one: Converting **Blob** to **Clob**

```
FUNCTION blob2clob (p_blob IN CLOB) RETURN CLOB;
```

:two: Converting **Clob** to **Blob**

```
FUNCTION clob2blob (p_clob IN CLOB) RETURN BLOB;
```

:three: Converting **Blob** to **Clob** with charset using **DBMS_LOB** package

```
FUNCTION blob2clob_cs(p_blob		IN BLOB
		p_charset_id	IN INTEGER DEFAULT DBMS_LOB.DEFAULT_CSID) RETURN CLOB
```

:four: Converting **Clob** to **Blob** with charset using **DBMS_LOB** package

```
FUNCTION clob2blob_cs(p_clob	IN CLOB,
		p_charset_id	IN INTEGER DEFAULT DBMS_LOB.DEFAULT_CSID) RETURN BLOB;
```

:information_source: Selecting **p_charset_id**

```
SELECT VALUE, NLS_CHARSET_ID(VALUE)
	FROM v$nls_valid_values
	WHERE PARAMETER = 'CHARACTERSET'
```

<table>
	<tr>
		<td valign="center" width="49%"><img src="https://github.com/Ruslan-Shevyrev/Ruslan-Shevyrev/blob/main/logoRS/logo_mini.gif" title="logo"></td>
		<td valign="center" width="49%"><img src="https://github.com/Ruslan-Shevyrev/Ruslan-Shevyrev/blob/main/logoRS/logoRS_FULL.png" title="RuslanShevyrev"></td>
	</tr>
</table>