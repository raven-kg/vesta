<VirtualHost %ip%:%web_port%>
    #default.tpl
    ServerName %domain_idn%
    %alias_string%
    ServerAdmin %email%
    DocumentRoot %docroot%
    ScriptAlias /cgi-bin/ %home%/%user%/web/%domain%/cgi-bin/
    Alias /vstats/ %home%/%user%/web/%domain%/stats/
    Alias /error/ %home%/%user%/web/%domain%/document_errors/
    #SuexecUserGroup %user% %group%
    CustomLog /var/log/%web_system%/domains/%domain%.bytes bytes
    CustomLog /var/log/%web_system%/domains/%domain%.log combined
    ErrorLog /var/log/%web_system%/domains/%domain%.error.log
    <Directory %docroot%>
        AllowOverride All
        Options +Includes -Indexes +ExecCGI
    </Directory>
    <Directory %home%/%user%/web/%domain%/stats>
        AllowOverride All
    </Directory>

    <IfModule mod_ruid2.c>
        RMode config
        RUidGid %user% %group%
        RGroups apache
    </IfModule>
    <IfModule itk.c>
        AssignUserID %user% %group%
#        MaxClientsVHost 8
#        NiceValie -2
    </IfModule>
    <IfModule php5_module>
#        php_admin_value session.save_handler redis
#        php_admin_value session.save_path "tcp://127.0.0.1::6379?prefix=%domain%&timeout=2"
#        php_admin_value session.serialize_handler igbinary
    </IfModule>

    IncludeOptional %home%/%user%/conf/web/%web_system%.%domain%.conf*

</VirtualHost>

