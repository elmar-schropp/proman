
// es_helper.js
// alert("es_helper.js")

window.replaceAll=function(oldStr,findStr,repStr,maxCount) {
  if (!oldStr || oldStr=="")return ""
  var srchNdx = 0;
  var newStr = "";
  var loopCounter=1
  if (!maxCount) maxCount=9999999;
  while (oldStr.indexOf(findStr,srchNdx) != -1){ 
    newStr += oldStr.substring(srchNdx,oldStr.indexOf(findStr,srchNdx));
    newStr += repStr;
    srchNdx = (oldStr.indexOf(findStr,srchNdx) + findStr.length);
    loopCounter=loopCounter+1;
    if(loopCounter>maxCount) break
  }
  newStr += oldStr.substring(srchNdx,oldStr.length);
  return newStr;
}//endFunction


window.insertUrlParam=function(key, value) {
  key = escape(key); value = escape(value);
  var kvp = document.location.search.substr(1).split('&');
  if (kvp == '') {
    window.location.hash = '#?' + key + '=' + value;
  } else {
    var i = kvp.length; var x;
    while (i--) {
      x = kvp[i].split('=');
      if (x[0] == key) {
        x[1] = value;
        kvp[i] = x.join('=');
        break;
      }
    }
    if (i < 0) { kvp[kvp.length] = [key, value].join('='); }
    // this will reload the page, it's likely better to store this until finished
    window.location.hash = kvp.join('&');
  }
  }