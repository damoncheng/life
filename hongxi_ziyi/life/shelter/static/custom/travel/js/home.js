function update_img_area(obj){
     IMG_RATE = 0.3
     window_size = $(window.body).width()
     show_size = IMG_RATE * window_size
     $(obj).css("width", (show_size - 1) + "px")
     $(obj).css("height", (show_size - 1) + "px")
     $("#photo_del_one_img_modal .modal-content").css("width", show_size + "px")
     $("#photo_del_one_img_modal .modal-body").css("width", show_size + "px")
     $("#photo_del_one_img_modal .modal-body").css("height", show_size + "px")
 
}

function update_shade_area(){
     IMG_RATE = 0.4
     window_height = $(window.body).height()
     window_width = $(window.body).width()
     $(".photo_shade").css("width", window_width + "px")
     $(".photo_shade").css("height", window_height + "px")
     $("#photo_shade_show_img").children("img").css("width", IMG_RATE*window_width + "px")
     $("#photo_shade_show_img").children("img").css("height", IMG_RATE*window_width + "px")
     $("#photo_shade_show_arrow_left").css("width", ((1-IMG_RATE)/2*window_width - 1) + "px")
     $("#photo_shade_show_arrow_right").css("width", ((1-IMG_RATE)/2*window_width - 1) + "px")
     $("#photo_shade_show_arrow_left").css("height", IMG_RATE*window_width + "px")
     $("#photo_shade_show_arrow_right").css("height", IMG_RATE*window_width + "px")

     $("#photo_shade_show").css("top", ($(window).scrollTop() + PHOTO_SHADE_SHOW_TOP)  + "px")
     $("#photo_shade_show_arrow_menu_left").css("top", ((1-IMG_RATE)/2*window_width - 1)/2 + "px")
     $("#photo_shade_show_arrow_menu_right").css("top", ((1-IMG_RATE)/2*window_width - 1)/2 + "px")
}

function update_shade_index(index){
     left_index = index - 1
     right_index = CONTENT_IMG_LEN - index
     $("span#photo_shade_show_arrow_img_left").html(left_index)
     $("span#photo_shade_show_arrow_img_right").html(right_index)

     if(left_index == 0)
     {
         $("#photo_shade_show_arrow_menu_left span.glyphicon").css("color", "grey")
         $("span#photo_shade_show_arrow_img_left").css("color", "grey")
     }
     else
     {
         $("#photo_shade_show_arrow_menu_left span.glyphicon").css("color", "#77a3f2")
         $("span#photo_shade_show_arrow_img_left").css("color", "#77a3f2")
     
     }

     if(right_index == 0)
     {
         $("#photo_shade_show_arrow_menu_right span.glyphicon").css("color", "grey")
         $("span#photo_shade_show_arrow_img_right").css("color", "grey")
     }
     else
     {
         $("#photo_shade_show_arrow_menu_right span.glyphicon").css("color", "#77a3f2")
         $("span#photo_shade_show_arrow_img_right").css("color", "#77a3f2")
     
     }
}

function hide_shade_area(){
     $(".photo_shade").hide()
}

function hide_upload_shade_area(){
     $(".upload_shade").hide()
}

function show_upload_shade_area(){
     $(".upload_shade").show()
}

$(function(){
    $("#img_upload").attr("data-url", IMG_UPLOAD_URL)
    update_shade_area()
    $(".photo_shade").hide()
    hide_upload_shade_area()
    $("#content-img img.normal_img").click(function(){
         var img_index = $(this).attr("index")
         var img_len = $("#photo_shade_show_img img[index=" + img_index + "]").length
         $("#photo_shade_show_img img").hide()
         if(img_len == 0)
         {
             obj = $(this).clone()
             $(obj).click(function(){
                 $(".photo_shade").hide()
             })
             $("#photo_shade_show_img").append(obj)
         }
         update_shade_area()
         update_shade_index(img_index)
         $("#photo_shade_show_img img[index=" + img_index + "]").show()
         var img_tag = $(".content-img-one-name-tag[index=" + img_index + "]").html()
         if(!img_tag)
             img_tag = $(".content-img-one-name-tag[index=" + img_index + "]").val()
         $("#photo_shade_show_img_tag span").empty()
         $("#photo_shade_show_img_tag span").html(img_tag)
         $(".photo_shade").show()
     })

    $("#content-img img.add_img").click(function(){
        $("#img_upload").click()
    })

    $("#content-img img.del_img").click(function(){
        $("#photo_del_img_modal").modal()
    })

    $("#photo_del_img_modal_sure").click(function(){
        ret = get_html_ajax(TEMPLATE_ID, "normal", "Administrator", "clear_img", 
            {
                "photo_year" : YEAR,
                "photo_area" : IMAGE_AREA,
                "photo_city" : IMAGE_CITY,
            })
        window.location.reload()
    })

    IMG_UPLOAD_SUCCESS = 0
    IMG_UPLOAD_FAIL = 0
    IMG_UPLOAD_DESC = ""
    $("#img_upload").fileupload({
        dataType : "json",
        start : function(e) {
            IMG_UPLOAD_SUCCESS = 0
            IMG_UPLOAD_FAIL = 0
            IMG_UPLOAD_DESC =""
            show_upload_shade_area()
        },
        progressall : function(e, data) {
            var progress = parseInt(data.loaded/data.total * 100, 10)
            $("#progress .progress-bar").css("width", progress + "%")
            $("#progress .progress-bar").html(progress + "%")
        },
        done : function(e, data){
            if(data.result["ret"] == 0)
            {
                IMG_UPLOAD_SUCCESS += 1
            }
            else
            {
                IMG_UPLOAD_FAIL += 1
                IMG_UPLOAD_DESC += data.result["data"]["name"]
                IMG_UPLOAD_DESC += ";"
            }

        },
        fail : function(e, data){
            IMG_UPLOAD_FAIL += 1
        },
        always : function(e, data){
        },
        stop : function(e){
           if(IMG_UPLOAD_FAIL > 0)
           {
               alert(IMG_UPLOAD_FAIL + " files upload fail, please upload " + IMG_UPLOAD_DESC + " again!")
           }
           $("#progress .progress-bar").css("width", "0%")
           $("#progress .progress-bar").html("0%")
           hide_upload_shade_area()
           window.location.reload()
        },
    })

    //$("#photo_shade_show_arrow_menu_right span.glyphicon").click(function(){
    $("#photo_shade_show_arrow_right").click(function(){
         var right_index = $("span#photo_shade_show_arrow_img_right").html()
         if(right_index == 0)
             return
         var img_index = CONTENT_IMG_LEN - right_index + 1
         var img_len = $("#photo_shade_show_img img[index=" + img_index + "]").length
         $("#photo_shade_show_img img").hide()
         if(img_len == 0)
         {
             obj = $("#content-img img[index=" + img_index + "]").clone()
             $(obj).click(function(){
                 $(".photo_shade").hide()
             })
             $("#photo_shade_show_img").append(obj)
         }
         update_shade_area()
         update_shade_index(img_index)
         var img_tag = $(".content-img-one-name-tag[index=" + img_index + "]").html()
         if(!img_tag)
             img_tag = $(".content-img-one-name-tag[index=" + img_index + "]").val()
         $("#photo_shade_show_img_tag span").empty()
         $("#photo_shade_show_img_tag span").html(img_tag)
         $("#photo_shade_show_img img[index=" + img_index + "]").show()
         
    })

    //$("#photo_shade_show_arrow_menu_left span.glyphicon").click(function(){
    $("#photo_shade_show_arrow_left").click(function(){
         left_index = $("span#photo_shade_show_arrow_img_left").html()
         if(left_index == 0)
             return
         img_index = left_index
         var img_len = $("#photo_shade_show_img img[index=" + img_index + "]").length
         $("#photo_shade_show_img img").hide()
         if(img_len == 0)
         {
             $("#photo_shade_show_img").empty()   
             obj = $("#content-img img[index=" + img_index + "]").clone()
             $(obj).click(function(){
                 $(".photo_shade").hide()
             })
             $("#photo_shade_show_img").append(obj)
         }
         update_shade_area()
         update_shade_index(img_index)
         var img_tag = $(".content-img-one-name-tag[index=" + img_index + "]").html()
         if(!img_tag)
             img_tag = $(".content-img-one-name-tag[index=" + img_index + "]").val()
         $("#photo_shade_show_img_tag span").empty()
         $("#photo_shade_show_img_tag span").html(img_tag)
         $("#photo_shade_show_img img[index=" + img_index + "]").show()
    })

    $(window).resize(
        function(){
            if($("#photo_shade_show").is(':visible'))
                update_shade_area()

            if($("#photo_del_one_img_modal").is(':visible'))
                update_img_area($("#photo_del_one_img_modal img"))
        }
    )

    $(window).scroll(
        function(){
            $("#photo_shade_show").css("top", ($(window).scrollTop() + PHOTO_SHADE_SHOW_TOP) + "px")
        }        
    )


    if(LOGINED)
    {
        $("#" + PSENDWORD_ID + "_textarea").htmlarea({
            toolbar : [
                ["bold", "italic", "underline", "|", "forecolor"],
                ["p", "h1", "h2", "h3", "h4", "h5", "h6"],
                ["link", "unlink", "|", "image", "|", "horizontalrule"],
                ["increasefontsize", "decreasefontsize"],
                ["indent", "outdent"],
                ["justifyleft", "justifycenter", "justifyright"],
                ["orderedlist", "unorderedlist"],
                [{
                    css : "custom_add_height",
                    text : "add height",
                    action : function(btn) {
                        height = $("div.jHtmlArea div iframe").height()
                        if(height >= 700)
                        {
                           alert("the height have been max!")
                           return
                        }
                        height = height + 100
                        $("div.jHtmlArea div iframe").css("height", height + "px")
                    }
                 },
                 {
                    css : "custom_del_height",
                    text : "del height",
                    action : function(btn) {
                        height = $("div.jHtmlArea div iframe").height()
                        if(height <= 100)
                        {
                           alert("the height have been min!")
                           return
                        }
                        height = height - 100
                        $("div.jHtmlArea div iframe").css("height", height + "px")
                    }
                }],
                [{
                    css : "custom_disk_button",
                    text : "Save",
                    action : function(btn) {
                        //'this' = jHtmlArea object
                        //'btn' = JQuery Object that presents the '<A>' "anchor" tag for the Toolbar Button
                        ret = get_html_ajax_post(TEMPLATE_ID, "normal", "Administrator", "update_sendword",
                              {
                                 "word_id" : PSENDWORD_ID,
                                 "word" : this.toHtmlString(),
                              })
                        if(ret["ret"] == 0)
                        {
                            alert("save success!")
                        }
                        else
                        {
                        
                            alert("save fail : " + ret["msg"] + "!" )
                        }
                    }
                }]
            ]} 
        )
        $("div.jHtmlArea").css("width", "100%")
        $("div.jHtmlArea div").css("width", "100%")
        $("div.jHtmlArea div iframe").css("width", "100%")
        $("div.jHtmlArea div iframe").css("height", "200px")

        $("#content-img img.normal_img").mouseenter(function(){
            $(".del_one_img").attr("index", $(this).attr("index"))
            var img_top = $(this).offset().top
            var img_left = $(this).offset().left
            newPos = new Object()
            newPos.top = img_top
            newPos.left = img_left
            img_top = newPos.top + $(this).height() - $("#photo_shade_del_img_one").height() - 1
            img_left = newPos.left + $(this).width() - $("#photo_shade_del_img_one").width() -1
            $("#photo_shade_del_img_one").css("top", img_top)
            $("#photo_shade_del_img_one").css("left", img_left)
            $("#photo_shade_del_img_one").show()
        })

        $("#content-img img.normal_img").mouseout(function(){
            $("#photo_shade_del_img_one").hide()
        })

        $(".del_one_img").mouseenter(function(){
            $("#photo_shade_del_img_one").show()
        })

        $(".del_one_img").click(function(){
            $("#photo_del_one_img_modal .modal-body").empty()
            img_index = $(this).attr("index")
            obj = $("#content-img img[index=" + img_index + "]").clone()
            $("#photo_del_one_img_modal .modal-body").html(obj)
            update_img_area(obj)
            $("#photo_del_one_img_modal").modal()
        })

        $("#photo_del_one_img_modal_sure").click(function(){
            src_path = $("#photo_del_one_img_modal img").attr("src")
            img_index = $("#photo_del_one_img_modal img").attr("index")
            $("div.content-img-one img.normal_img[index=" + img_index + "]").parents("div.content-img-one").remove()
            get_html_location(TEMPLATE_ID, "normal", "Administrator", "del_img", {
                "img_src" : src_path
            })
        })

        //$("input.content-img-one-name-tag").attr("maxlength", "11")
        $("input.content-img-one-name-tag").change(function(){
            photo_img = $(this).attr("file_name")
            photo_tag = $(this).val()
            ret = get_html_ajax_async(TEMPLATE_ID, "normal", "Administrator", "update_img_tag", {
                "photo_id" :    PHOTO_ID,
                "photo_img"  :  photo_img,
                "photo_tag" :   photo_tag,
            })
        })
   }
});

