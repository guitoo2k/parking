<script src="/js/md5.js"></script>
<script>
$(document).ready(function() {

  $('form').submit(function(e) {
	fieldPwd = $('#pwd');
    strVal = fieldPwd.val();
    strMD5 = CryptoJS.MD5(strVal).toString();
    fieldPwd.val( strMD5 );
    fieldPwd = $('#pwdConfirmation');
    strVal = fieldPwd.val();
    strMD5 = CryptoJS.MD5(strVal).toString();
    fieldPwd.val( strMD5 );
    return true;
  });
});
</script>