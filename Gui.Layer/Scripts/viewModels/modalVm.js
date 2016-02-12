var ModalVm = function (controlName) {
    var self = this;
    self.controlToDisplay = $(controlName);

    self.showModal = function () {
        self.controlToDisplay.modal("show");
    };

    self.hideModal = function () {
        self.controlToDisplay.modal("show");
    };
}