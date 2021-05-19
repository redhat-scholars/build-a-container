#!/bin/bash

cat <<EOF 
Content-type: text/html

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
<h1>"Hello!  I am $(whoami)"</h1>
</body>
</html>
EOF