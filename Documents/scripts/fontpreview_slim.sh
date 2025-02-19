# https://askubuntu.com/a/1534544
# https://askubuntu.com/a/1005724
# (This one can take as an argument some sample text!)

cat > /tmp/fonts.html << __HEADER
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Sample of local fonts matching '$1'</title>
    <style>
        * {
            color: beige;
            background-color: black;
        }
    </style>
</head>
<body>
<table>
__HEADER
for default_kind in monospace sans serif
do
    default_font=$(fc-match -f '%{family}' ${default_kind} | awk -F, '{print $1}')
    echo "${default_kind} default: <span style='font-family: ${default_font}'>${default_font}</span><br/>"
done

fc-list --format='%{family}\n' $1 | awk -F, '{print $1}' | sort -u | while IFS='' read -r fontfamily
do
    cat >> /tmp/fonts.html << __BODY
                <tr>
        <td>${fontfamily}</td>
                <td  style="font-family: '${fontfamily}', 'sans'">$1</td>
                <td  style="font-family: '${fontfamily}', 'sans'">The quick brown fox jumped over the lazy dog  0123456789,.:;?/<>'"[]{}|\-=\`~!@#$%^&*()-=\\</td>
                </tr>
__BODY

done

cat >> /tmp/fonts.html << __FOOTER
</table>
</body>
</html>
__FOOTER

echo "/tmp/fonts.html created"
sensible-browser /tmp/fonts.html
