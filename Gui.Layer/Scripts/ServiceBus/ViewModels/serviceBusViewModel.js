/// <reference path="../../jquery-1.8.2.intellisense.js" />
/// <reference path="../../toastr.js" />
/// <reference path="../../knockout-2.2.0.debug.js" />
/// <reference path="MessagePropertyViewModel.js" />

function ServiceBusViewModel(data) {
    var self = this;

    self.sendMessage = submitMessage;
    self.selectedMessageId = ko.observable();

    self.messages = ko.observableArray([]);
    self.messageProperties = ko.observableArray([]);

    self.messageTypeSelected = ko.computed(function () {
        return self.selectedMessageId() != undefined;
    });

    for (var i = 0; i < data.Messages.length; i++) {
        self.messages.push(data.Messages[i]);
    }

    self.selectedMessageId.subscribe(function (messageId) {
        getMessageProperties(messageId);
    });

    function setPropertyInputs(propertyList) {
        for (var j = 0; j < propertyList.Properties.length; j++) {
            self.messageProperties.push(new MessagePropertyViewModel(propertyList.Properties[j]));
        }
    }

    function getMessageProperties(messageId) {

        self.messageProperties.removeAll();

        var dataToSend = { 'selectedMessage': messageId };

        $.ajax({
            cache: true,
            async: true,
            type: "POST",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            data: JSON.stringify(dataToSend),
            url: 'GetProperties/'
        }).done(function (response) {
            try {
                setPropertyInputs(response);
            } catch (e) {
                console.log(e.message);
                toastr.error('An unexpected error occured please try again!');
            }
        }).fail(function (xhr) {
            console.log(xhr.responseText);
            toastr.error("An unexpected error occured please try again!");
        }).complete(function () {
        });
    }

    function submitMessage() {

        var dataToSend = {
            typeName: self.selectedMessageId(),
            propertiesForMessage: self.messageProperties()
        };

        $.ajax({
            cache: true,
            async: true,
            type: "POST",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            data: ko.toJSON(dataToSend),
            url: 'SendMessage'
        })
            .done(function (response) {
                try {
                    toastr.success(response.Message);
                } catch (e) {
                    console.log(e.message + ' ' + response);
                    toastr.error('An unexpected error occured please try again!');
                }
            })
            .fail(function (xhr) {
                console.log(xhr.responseText);
                toastr.error("An unexpected error occured please try again!");
            }).complete(function () {
            });
    }
}