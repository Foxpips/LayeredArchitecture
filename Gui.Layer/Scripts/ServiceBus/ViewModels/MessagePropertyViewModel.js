/// <reference path="../../knockout-2.2.0.debug.js" />
var MessagePropertyViewModel = function messagePropertyViewModel(data) {
    var self = this;

    self.name = data.Name;
    self.description = data.Description;
    self.value = ko.observable();
}