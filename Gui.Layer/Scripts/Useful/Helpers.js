


//Place the following on your csthml page 

/*<script type="text/javascript">
    var employmentTrainingModel = @(Html.Raw(Json.Encode(@Model)));
</script>*/

//and then you can access it like so
model = window.employmentTrainingModel || {};