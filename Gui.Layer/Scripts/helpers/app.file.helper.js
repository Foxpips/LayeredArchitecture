var FileHelper = function () {
    var self = this;

    self.isOverMaxSize = function(size) {
        var sizeMb = size / 1024 / 1024;
        return sizeMb > appSettings.maxFileSizeMB;
    };

    self.deleteDocument = function(name, submitType) {
        return $.ajax({
            url: appSettings.urls.PostApplyForDeleteDocument +  "?name=" + name + "&submitType=" + submitType,
            type: "POST",
            processData: false,
            contentType: false
        });
    };

    self.UploadDocument = function(name, requireType) {
        var fd = new FormData();
        fd.append("fileToUpload",name);

        return $.ajax({
            url: appSettings.urls.PostApplyForUploadDocument +  "?requiredType=" + requireType,
            type: "POST",
            data: fd,
            processData: false,
            contentType: false
        });
    };

    self.offlineDelivery = function (type, submitType) {
        return $.ajax({
            url: appSettings.urls.PostApplyForOfflineDelivery +  "?type=" + type + "&submitType=" + submitType,
            type: "POST",
            processData: false,
            contentType: false
        });
    };
};