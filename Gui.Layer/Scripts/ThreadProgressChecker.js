    var updateTimer;
    var progressText = $('#infoDiv');
    var progressBar = $('#progress-bar');
    var progressDiv = $('#progressDiv');
    var progressLabel = $('#updateLabel');

    updateTimer = setInterval(function () {
        pollSqlUpdate();
    }, 1000);

    function startPolling() {
        updateTimer;
    }

    function stopPolling() {
        clearInterval(updateTimer);
    }

    function pollSqlUpdate() {
        var form = $('#UpdateForm');
        var data = form.serialize();

        $.ajax({
            url: '/SqlAgentUIRunner/Update/PollProgress/',
            data: data,
            type: 'POST'
        })
            .success(function (response) {
                if (!response.inProgress) {
                    stopPolling();
                    progressDiv.hide(2000);
                    return;
                }

                progressDiv.show();
                if (response.inProgress) {
                    progressBar.show();
                    progressText.html(response.progressInfo);
                }
            }).error(function () {
            }).complete(function () {
            });
    }
    startPolling();