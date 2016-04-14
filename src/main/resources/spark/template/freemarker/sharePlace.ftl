<!DOCTYPE html>
<html lang="fr">
<head>
	<#include "header.ftl">
  	<!--link rel="stylesheet" href="/stylesheets/datepicker.css"-->
  	<link href="//cdn.rawgit.com/Eonasdan/bootstrap-datetimepicker/e8bddc60e73c1ec2475f827be36e1957af72e2ea/build/css/bootstrap-datetimepicker.css" rel="stylesheet">
  
  	<!--script src="/js/bootstrap-datepicker.js" charset="UTF-8"></script-->
  	<script src="//cdnjs.cloudflare.com/ajax/libs/moment.js/2.9.0/moment-with-locales.js"></script>
  	<script src="//cdn.rawgit.com/Eonasdan/bootstrap-datetimepicker/e8bddc60e73c1ec2475f827be36e1957af72e2ea/src/js/bootstrap-datetimepicker.js"></script>
	
  	
  	<style>
		.padding120 {
			padding: 120px;
		}  	
		
		.modalColor{
			background: #f3f3f3;
		}

		.footerColor{
			background: #f1ebe3; 
		}

  	</style>
  	
</head>

<body>
  
	<!-- navigation section -->
	<#include "nav.ftl">


    <section class="content-section">
		<div class="container containerAttr">

			<h1 class="titre">Proposer une place de parking</h1>

			<div class="row" style="margin:0px auto;max-width:700px; padding-top:20px;">					
				<form method="post" role="form">
					
					Je lib&egrave;re la place n&deg;<strong>${placeNumber}</strong> <br><br/>
					<div class="text-center"> 
									 
						<div class="col-md-6 col-sm-6">
							<div class="input-group date" id="datepicker1">
								<label>du&nbsp;&nbsp;</labdel>
								<input type="text" class="shareInput" name="dateDebut" required />
								<span class="input-group-addon">
									<i class="fa fa-calendar-o"></i>
								</span>
							</div>
						</div>

						<div class="col-md-6 col-sm-6">
							<div class="input-group date" id="datepicker2">
								<label>au&nbsp;&nbsp;</labdel>
								<input type="text" class="shareInput" name="dateFin" required/>
								<span class="input-group-addon">
									<i class="fa fa-calendar-o"></i>
								</span>
							</div>
						</div>
					<div/>

					<br clear="both"/>
					<br clear="both"/>
					<input type="submit" class="btn btn-primary btn-lg" value="Valider"/>

					<!--=============================== liste des dates de partage ============================-->

					<div class="row table-responsive" style="margin:0px auto;max-width:550px; padding-top:30px;">
						<#if datesPartages??>
							<table class="table table-bordered table-striped table-condensed padding20">
								<tr style="background-color: #337ab7; color: white;">
									<th style="text-align:center;">Date de partage</th> 
									<th style="text-align:center;">Annuler</th>
								</tr>
								<#list datesPartages as place>
									<!tr> 
						  	    		<td>${place.occupationDate}</td>
							  	     	<td>
							  	     		<#assign show = place.usedBy>
							  	     	 	<#if show == "" || show == " ">
							  	     			<a href="/protected/share?unshareDate=${place.occupationDate}" data-confirm='Annuler le partage de votre place du <strong> ${place.occupationDate} </strong> ?' ><img src="/images/cancel.png"/></a>
							  	     		</#if>
							  	     	</td>
									</tr>
								</#list>
							</table>
						</#if>
					</div>

					
				</form>
			</div>	

		</div>

	</section>
	

	<script type="text/javascript">
	    $( document ).ready(function() {
	        $('#datepicker1').datetimepicker({
	        	locale: 'FR',
	        	daysOfWeekDisabled: [0, 6],
	               format: 'DD/MM/YYYY'
	        });
	        $('#datepicker2').datetimepicker({
	        	daysOfWeekDisabled: [0, 6],
	            useCurrent: true,
	            format: 'DD/MM/YYYY',
	            locale: 'FR' //Important!
	        });
	        $("#datepicker1").on("dp.change", function (e) {
	            $('#datepicker2').data("DateTimePicker").minDate(e.date);
	        });
	        $("#datepicker2").on("dp.change", function (e) {
	            $('#datepicker1').data("DateTimePicker").maxDate(e.date);
	        });
	    });
	</script>	
	
	<script type="text/javascript">
		$(function() {
			$('a[data-confirm]').click(function(ev) {
				var href = $(this).attr('href');
				
				if (!$('#dataConfirmModal').length) {
					$('body').append('<div id="dataConfirmModal" class="modal padding120" role="dialog" aria-labelledby="dataConfirmLabel" aria-hidden="true"><div class="modal-dialog"><div class="modal-content modalColor"><div class="modal-header"><button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button><h3 id="dataConfirmLabel"><strong>Confirmation d\'annulation</strong></h3></div><div class="modal-body"></div><div class="modal-footer footerColor"><button class="btn btn-danger" data-dismiss="modal" aria-hidden="true">Non</button><a class="btn btn-primary" id="dataConfirmOK">Oui</a></div></div></div></div>');
				}
				$('#dataConfirmModal').find('.modal-body').html($(this).attr('data-confirm'));
				$('#dataConfirmOK').attr('href', href);
				$('#dataConfirmModal').modal({show:true});
				
				return false;
			});
		});		
	</script>

</body>
</html>
