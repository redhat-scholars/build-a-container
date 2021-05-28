#!/bin/bash

echo $QUERY_STRING | sed -rn 's/visitor=([^&]+)&?.*/\1/p' >> /var/log/web/visitor_info.txt

cat <<EOF 
Content-type: text/html

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
<h1>Thank you!</h1>
I have collected your info as $(whoami)"</h1>
</body>
</html>
EOF