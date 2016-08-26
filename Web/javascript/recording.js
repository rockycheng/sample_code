var isPlay = false;
var blink;
var filterRecordings = [];

//hack for safari to get session from platform
function getSession() {
    var newWindow = window.open(config.platformApiAddress, '_blank', 'toolbar=no,status=no,menubar=no,scrollbars=no,resizable=no,left=10000, top=10000, width=10, height=10, visible=none', '');
    $(newWindow.document).ready(function () {
        setTimeout(function () {
            newWindow.close();
        }, 200);
    });
}

liveService.agent.main = {
//Status Handler
};

$(function () {

    $("#userBtn").on('click', function () {
        if($("#spanUserId").text().match("@@")) {
            $("#btnUpdatePassword").hide();
        }
    });

    $("#btnSavePassword").on('click', function () {

        var formData = new FormData();
        formData.append("curPassword", $("#curPassword").val())
        formData.append("password", $("#password").val())
        formData.append("cpassword", $("#cpassword").val())
        $.ajax({
            url: '/user/password',
            data: formData,
            cache: false,
            contentType: false,
            processData: false,
            type: 'POST',
            beforeSend: function (e) {
                if ($("#password").val().length < 6) {
                    alert(i18n.t("passwordNeedLonger"));
                    e.preventDefault();
                }
            },
            statusCode: {
                401: function (e) {
                    //password mismatch
                    showError(e);
                },
                400: function (e) {
                    //wrong cur password
                    showError(e);
                },
                200: function (msg) {
                    $("#divUpdateError").hide();
                    $("#divUpdateSuccess").text(msg);
                    $("#divUpdateSuccess").show();
                    document.getElementById("frmUpdatePassword").reset();
                }
            }
        });

        function showError(e) {
            $("#divUpdateSuccess").hide();
            $("#divUpdateError").text(e.responseText);
            $("#divUpdateError").show();
        }
    });

    $("#btnOverMaximumParticipantsInfo").on('click', function() {
        liveService.agent.meetingPanel.quitMeeting();
    });

    $(".receiveNewMsg").on('click', function() {
        clearInterval(blink);
        liveService.agent.changeTitle(false);
    });

    $(".backToMeeting").on('click', function() {
        clearInterval(blink);
        liveService.agent.changeTitle(false);
    });

    //Tab
    $("#tabRecording").on('click',function(){
        $.ajax({
            "type": "POST",
            "url": "/agent/recordings",
            success: function(data) {
                if(data) {
                    filterRecordings = data;
                    $("#recordingList").bindTemplate("/templates/recordingList.hbs", {'video': data.video});

                    //TODO: better to use promise
                    setTimeout(function(){
                        $("form[id*='recordingForm']").attr("action", data.url);

                    },1000);


                } else {
                    console.error("No recording data");
                }
            },
            error: function() {
                console.error("Error getting Recordings");
            }
        });
    });

    //Refresh
    $("#tabRecordingRefresh").on('click',function(){
        //call API_recording
        $.ajax({
            "type": "POST",
            "url": "/agent/recordings",
            success: function(data) {
                if(data) {
                    filterRecordings = data;
                    $("#recordingList").bindTemplate("/templates/recordingList.hbs", {'video': data.video});
                    $("form[id*='recordingForm']").attr("action", data.url);

                } else {
                    console.error("No recording data");
                }
            },
            error: function() {
                console.error("Error getting Recordings");
            }
        });
    });

    //Search
    $("#searchRecordings").on("keyup input", function(event){
        if(event.originalEvent.type == "keyup"){
            if(event.keyCode == 13){
                return false;
            }
        }
        var keyVal = $(this).val();
        if(event.originalEvent.type == "input") {
            console.log("roading filter recording info *********");
            console.log(filterRecordings);
            if($.trim(keyVal) != "") {
                /* reference : http://kiro.me/exp/fuse.html */
                var options = {
                    caseSensitive: false,
                    includeScore: false,
                    shouldSort: true,
                    threshold: 0.0,/*0.0 requires a perfect match (of both letters and location), a threshold of 1.0 would match anything*/
                    location: 0,
                    distance: 100,
                    //maxPatternLength: 32,
                    keys: ["name","createTime"] // keys to search in
                };
                var fuse = new Fuse(filterRecordings.video, options); //filter recording.video
                var result = fuse.search(keyVal);
                console.log("after filter")
                console.log(result);
                $("#recordingList").bindTemplate("/templates/recordingList.hbs", {'video': result});
            }else
            {
                console.log("Dont filter recording file.");
                $("#recordingList").bindTemplate("/templates/recordingList.hbs", {'video': filterRecordings.video});
            }
            console.log(filterRecordings.url);
            $("form[id*='recordingForm']").attr("action", filterRecordings.url);//player URL
        }

    });

    $.fn.downloadVideo = function(meetingId){
        console.log("Calling Download Video...");

        $.ajax({
            "type": "GET",
            "url": "/agent/downloadVideo?meetingid="+meetingId,
            success: function(data) {
                console.log("!!!!! downloadVideo url= "+data.videourl+'(expires:'+data.expires+')');
                // Open new window with url and download.
            },
            error: function() {
                console.error("Error calling downloadVideo");
            }
        });

    }

    liveService.agent.setUpLanguage()
        .done(function () {
            liveService.agent.main.init();
            liveService.agent.infoPanel.init();
            liveService.agent.videoListPanel.init();
        });

    liveService.agent.registerI18nHelper();

    $(window).on('beforeunload', function () {
        liveService.liveCall.disconnect();
    });

    //manually get session because Safari doesn't allow getting session from IFRAME
    if (navigator.userAgent.indexOf('Safari') != -1 && navigator.userAgent.indexOf('Chrome') < 1) {
        getSession();
    }
});