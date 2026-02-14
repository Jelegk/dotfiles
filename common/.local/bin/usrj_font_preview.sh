#!/bin/sh
# https://askubuntu.com/a/1005724

cat > /tmp/fonts.html << __HEADER
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Sample of local fonts</title>
    <style>
        * {
            color: beige;
            background-color: black;
        }
    </style>
</head>
<body>
__HEADER
for default_kind in monospace sans serif
do
    default_font=$(fc-match -f '%{family}' ${default_kind} | awk -F, '{print $1}')
    echo "${default_kind} default: <span style='font-family: ${default_font}'>${default_font}</span><br/>"
done

fc-list --format='%{family}\n' $1 | awk -F, '{print $1}' | sort -u | while IFS='' read -r fontfamily
do
    cat >> /tmp/fonts.html  << __BODY
    <hr/>
    <div style="font-family: '${fontfamily}'">
        <h1>${fontfamily}</h1>
        <p>
            The quick brown fox jumped over the lazy brown dog<br/>
            0123456789,.:;?/<>'"[]{}|\-=\`~!@#$%^&*()-=\\
        </p>
    </div>
__BODY

done

cat >> /tmp/fonts.html << __FOOTER
    <hr/>
</body>
</html>
__FOOTER


echo "/tmp/fonts.html created"
firefox /tmp/fonts.html
