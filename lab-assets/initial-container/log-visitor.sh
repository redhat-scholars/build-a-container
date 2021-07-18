#!/bin/bash

VISITOR=$(echo $QUERY_STRING | sed -rn 's/visitor=([^&]+)&?.*/\1/p')
echo $VISITOR >> /var/log/www/visitor_info.txt

cat <<EOF
Content-type: text/html

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
<title>Thank You</title>
<h1>Thank you ${VISITOR}!</h1>
I have collected your info as user: $(whoami) <br> <br>

Click <a href=/hello.html>here</a> to register another visitor.
</body>
</html>
EOF