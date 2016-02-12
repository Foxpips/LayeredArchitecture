
var ajaxGetRequest = function (url, callback) {
    ajaxRequest("GET", url, null, callback);
}

var ajaxPostRequest = function (url, data, callback) {
    ajaxRequest("POST", url, data, callback);
}

var ajaxRequest = function (requestType, url, dataToSend, callback) {
    
    if (dataToSend != null) {
        dataToSend.__RequestVerificationToken = $("[name=__RequestVerificationToken]").val();
    }

    $.ajax({
        async: true,
        type: requestType,
        data: dataToSend,
        url: url
    })
        .done(function (response) {
            try {
                if (callback != null || callback != undefined) {
                    if (response != null || response !== undefined) {
                        callback(response);
                    } else {
                        callback();
                    }
                }
            } catch (e) {
                console.error("An unexpected error occured please try again! \n" + e.message);
            }
            return response;
        })
        .fail(function (xhr, status, error) {
            console.log(xhr.responseText);
            console.error("An unexpected error occured please try again! \n" + error);
        }).complete(function () {
        });
}