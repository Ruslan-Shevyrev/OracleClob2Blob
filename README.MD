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

:three: Converting **Clob** to **Blob** with charset using Package **DBMS_LOB**

```
FUNCTION clob2blob_cs(p_clob	IN CLOB,
		charset_id	IN INTEGER DEFAULT DBMS_LOB.DEFAULT_CSID) RETURN BLOB;
```

<table>
	<tr>
		<td valign="center" width="49%"><img src="https://github.com/Ruslan-Shevyrev/Ruslan-Shevyrev/blob/main/logoRS/logo_mini.gif" title="logo"></td>
		<td valign="center" width="49%"><img src="https://github.com/Ruslan-Shevyrev/Ruslan-Shevyrev/blob/main/logoRS/logoRS_FULL.png" title="RuslanShevyrev"></td>
	</tr>
</table>