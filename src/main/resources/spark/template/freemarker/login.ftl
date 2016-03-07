<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <#include "header.ftl">
</head>

<body>
   
  <#if error??>
	  <div class="alert alert-danger">
	  	<strong>Erreur : </strong>${error}
	  </div>
  </#if>
  
  <div class="jumbotron">
    <div class="container">
      <div class="row">
	      <form method="post" role="form">
	        <div class="form-group">
		        <label for="email">Email</label>
		        <#if email??>
  		          <input type="email" class="form-control" name="email" placeholder="adresse@email.fr" value="${email}"/>
		        <#else>
		          <input type="email" class="form-control" name="email" placeholder="adresse@email.fr"/>
                </#if>
	        </div>
	        <div class="form-group">
		        <label for="pwd">Mot de passe</label>
		        <input type="password" class="form-control" name="pwd" id="pwd" placeholder="********"/>
	        </div>
	        <div class="form-group">
				<input type="submit" class="btn btn-success" value="Se connecter"/>
				<a href="/user/forget">Mot de passe perdu ?</a>
				<a class="btn btn-primary pull-right" href="/user/new">Cr&eacute;er un compte</a>
	        </div>
	      </form>
      </div>
    </div>
  </div>
  
</body>
</html>
