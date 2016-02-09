server {
    listen      %ip%:%proxy_port%;
    server_name %domain_idn% %alias_idn%;
    error_log  /var/log/httpd/domains/%domain%.error.log error;
    access_log /var/log/httpd/domains/%domain%.bytes bytes  buffer=8k  flush=5m;
    access_log /var/log/httpd/domains/%domain%.log combined buffer=16k flush=1m;
    index index.php index.html index.htm;
    root %docroot%;

    location ~* ^.+\.(3gp|gif|jpg|jpeg|png|ico|wmv|avi|asf|asx|mpg|mpeg|mp4|pls|mp3|mid|wav|swf|flv|exe|zip|tar|rar|gz|tgz|bz2|uha|7z|ttf|svg|woff|doc|docx|xls|xlsx|pdf|iso)$ {
        expires max;
        include /etc/nginx/includes/headers.conf;
    }
    location ~* ^.+\.(css|js|html|htm|txt)$ {
        expires 10d;
        include /etc/nginx/includes/headers.conf;
    }

    location / {
        include /etc/nginx/includes/proxy.conf;
        proxy_redirect off;
        proxy_cache off;
        proxy_pass http://%ip%:%web_port%;
    }

    location @fallback {
        proxy_pass http://%ip%:%web_port%;
        proxy_redirect off;
        add_header X-Cached $upstream_cache_status;
        include /etc/nginx/includes/proxy.conf;
        include /etc/nginx/includes/cache.conf;
    }

    location /error/ {
        alias   %home%/%user%/web/%domain%/document_errors/;
    }

    location = /robots.txt  { log_not_found off; }
    location = /favicon.ico { log_not_found off; expires max; }

    location ~ /\.(ht|svn|git|hg|bzr)  {return 404;}

    include %home%/%user%/conf/web/nginx.%domain%.conf*;
}

