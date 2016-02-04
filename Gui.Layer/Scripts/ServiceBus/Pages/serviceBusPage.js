/// <reference path="../../jquery-1.8.2.intellisense.js" />
/// <reference path="../../toastr.js" />
/// <reference path="../../knockout-2.2.0.debug.js" />
/// <reference path="../ViewModels/serviceBusViewModel.js" />
$(function () {

    var messageViewModel;

    (function getData() {
        $.ajax({
                cache: true,
                async: true,
                type: "POST",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                url: "MessageBus/GetMessages/"
            })
            .done(function(response) {
                try {
                    messageViewModel = new ServiceBusViewModel(response);
                    ko.applyBindings(messageViewModel);
                } catch (e) {
                    console.log(e.message);
                    toastr.error("An unexpected error occured please try again!");
                }
            })
            .fail(function(xhr) {
                console.log(xhr.responseText);
                toastr.error("An unexpected error occured please try again!");
            }).complete(function() {
            });
    })

    ();
});