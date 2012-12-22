
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


