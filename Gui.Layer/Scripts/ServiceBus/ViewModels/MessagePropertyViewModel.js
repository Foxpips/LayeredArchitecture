/// <reference path="../../knockout-2.2.0.debug.js" />
function MessagePropertyViewModel(data) {
    var self = this;

    self.name = data.Name;
    self.id = data.id;
    self.value = ko.observable();
}