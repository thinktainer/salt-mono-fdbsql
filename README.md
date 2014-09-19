# salt-mono-fdbsql
[Salt](http://www.saltstack.com) states for a mono box with connectivity to a
locally installed foundationdb sql layer from mono via an odbc driver.
The conn.fs in the home folder can be compiled with

	fsharpc -r:System.Data conn.fs
	
This will create conn.exe in the same folder
which should print out the foundationdb sql layer version.

