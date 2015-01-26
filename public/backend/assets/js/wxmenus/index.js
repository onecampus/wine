$(document).ready(function() {
  showMenuEdit();
  /*
  表情转换数据
  */
  var emotionData = {
    "0": "/微笑",
    "1": "/撇嘴",
    "2": "/色",
    "3": "/发呆",
    "4": "/得意",
    "5": "/流泪",
    "6": "/害羞",
    "7": "/闭嘴",
    "8": "/睡",
    "9": "/大哭",
    "10": "/尴尬",
    "11": "/发怒",
    "12": "/调皮",
    "13": "/呲牙",
    "14": "/惊讶",
    "15": "/难过",
    "16": "/酷",
    "17": "/冷汗",
    "18": "/抓狂",
    "19": "/吐",
    "20": "/偷笑",
    "21": "/可爱",
    "22": "/白眼",
    "23": "/傲慢",
    "24": "/饥饿",
    "25": "/困",
    "26": "/惊恐",
    "27": "/流汗",
    "28": "/憨笑",
    "29": "/大兵",
    "30": "/奋斗",
    "31": "/咒骂",
    "32": "/疑问",
    "33": "/嘘",
    "34": "/晕",
    "35": "/折磨",
    "36": "/衰",
    "37": "/骷髅",
    "38": "/敲打",
    "39": "/再见",
    "40": "/擦汗",
    "41": "/抠鼻",
    "42": "/鼓掌",
    "43": "/糗大了",
    "44": "/坏笑",
    "45": "/左哼哼",
    "46": "/右哼哼",
    "47": "/哈欠",
    "48": "/鄙视",
    "49": "/委屈",
    "50": "/快哭了",
    "51": "/阴险",
    "52": "/亲亲",
    "53": "/吓",
    "54": "/可怜",
    "55": "/菜刀",
    "56": "/西瓜",
    "57": "/啤酒",
    "58": "/篮球",
    "59": "/乒乓",
    "60": "/咖啡",
    "61": "/饭",
    "62": "/猪头",
    "63": "/玫瑰",
    "64": "/凋谢",
    "65": "/示爱",
    "66": "/爱心",
    "67": "/心碎",
    "68": "/蛋糕",
    "69": "/闪电",
    "70": "/炸弹",
    "71": "/刀",
    "72": "/足球",
    "73": "/瓢虫",
    "74": "/便便",
    "75": "/月亮",
    "76": "/太阳",
    "77": "/礼物",
    "78": "/拥抱",
    "79": "/强",
    "80": "/弱",
    "81": "/握手",
    "82": "/胜利",
    "83": "/抱拳",
    "84": "/勾引",
    "85": "/拳头",
    "86": "/差劲",
    "87": "/爱你",
    "88": "/NO",
    "89": "/OK",
    "90": "/爱情",
    "91": "/飞吻",
    "92": "/跳跳",
    "93": "/发抖",
    "94": "/怄火",
    "95": "/转圈",
    "96": "/磕头",
    "97": "/回头",
    "98": "/跳绳",
    "99": "/挥手",
    "100": "/激动",
    "101": "/街舞",
    "102": "/献吻",
    "103": "/左太极",
    "104": "/右太极"
  };
  /*
  添加一级菜单
  */

  $(".add-menu").click(function(){
    var length = $(".menu").length;
    if(length >= 3) {
      alert("一级菜单最多只能3个");
      return false;
    }
  })
  $(".menu-add").click(function() {
    var menuName = $("#menu-name").val();
    if (menuName == "") {
      $(".menu-mesg").text("菜单名字不能为空");
      $(".menu-name-mesg").hide();
      $(".menu-mesg").show();
      return false;
    }
    var length = 0;
    for (var i = 0; i < menuName.length; i++) {
      var menuNameLength = menuName.charCodeAt(i);
      if (menuNameLength >= 0 && menuNameLength <= 128) {
        length += 1;
      }
      else {
        length += 2;
      }
    }
    if(length > 8) {
      $(".menu-mesg").text("超出字数范围");
      $(".menu-name-mesg").hide();
      $(".menu-mesg").show();
      return false;
    }
    /*
    添加菜单对于一级二级菜单通用
    */
    else {
      var parentId = 0;
      var level = 1;
      $.ajax({
        type: "POST",
        url: "/admin/wx_menus/name/create/json",
        dataType: "json",
        data: {
          name: menuName,
          parent_id: parentId,
          level: level
        },
        success: function(data) {
          if (data.status == 'success') {
            alert("菜单创建成功");
            _href = window.location.href;
            window.location.href = _href;
          } else {
            alert("菜单创建失败");
          }
        },
        complete: function(XMLHttpRequest, textStatus) {
          // code
        },
        error: function() {
          // code
        }
      });
    }
  });

  $("#menu-name").focus(function() {
    $(".menu-name-mesg").show();
    $(".menu-mesg").hide();
  });

  /*
  修改菜单名称
  */

  /*
  增加二级菜单
  */
  $(".menu-edit-add").click(function(){
    var length = $(this).parents(".menu").find(".menu-drop-list").length;
    if(length >= 5) {
      alert("二级菜单最多只能5个");
      return false;
    }
    else {
      var parentId = $(this).parents(".menu").find(".wx-menu-editable").data("pk");
      $("#submenu-parentId").attr("value",parentId);
    }
  });
  $(".submenu-add").click(function() {
    var menuName = $("#submenu-name").val();
    var parentId = $("#submenu-parentId").val();
    if (menuName == "") {
      $(".submenu-mesg").text("菜单名字不能为空");
      $(".submenu-name-mesg").hide();
      $(".submenu-mesg").show();
      return false;
    }
    var length = 0;
    for (var i = 0; i < menuName.length; i++) {
      var menuNameLength = menuName.charCodeAt(i);
      if (menuNameLength >= 0 && menuNameLength <= 128) {
        length += 1;
      } else {
        length += 2;
      }
    }
    if (length > 16) {
      $(".submenu-mesg").text("超出字数范围");
      $(".submenu-name-mesg").hide();
      $(".submenu-mesg").show();
      return false;
    }

    /*
    添加菜单对于一级二级菜单通用
    */
    else {
      var level = 2;
      $.ajax({
        type: "POST",
        url: "/admin/wx_menus/name/create/json",
        dataType: "json",
        data: {
          name: menuName,
          parent_id: parentId,
          level: level
        },
        success: function(data) {
          if (data.status == 'success') {
            alert("菜单创建成功");
            _href = window.location.href;
            window.location.href = _href;
          } else {
            alert("菜单创建失败");
          }
        },
        complete: function(XMLHttpRequest, textStatus) {
          // code
        },
        error: function() {
          // code
        }
      });
    }
  });

  $("#submenu-name").focus(function() {
    $(".submenu-name-mesg").show();
    $(".submenu-mesg").hide();
  });

  /*
  一级菜单没有二级菜单时动作按钮显示
  */
  function showMenuEdit() {
    $(".menu").each(function(){
      var length = $(this).find(".menu-drop-list").length;
      if(length < 0 || length == 0) {
        $(this).find(".menu-edit-edit").show();
      }
      else {
        $(this).find(".menu-edit-edit").hide();
      }
    });
  }

  /*
  二级菜单动作编辑
  */
  $(".edit-submenu-btn").click(function(){
    var $this = $(this);
    var type = $this.data("submenutype");
    var menuId = $this.data("id");
    var url = $this.data("url");
    var title = $this.data("title");
    var description = $(this).data("description");
    var msgType = $this.data("msgtype");
    var img = $this.data("img");
    $(".menu-id").attr("value",menuId);
    $(".mesg-menu-id").attr("value",menuId);
    if (type == "none") {
      $(".edit-url").hide();
      $(".edit-mesg").hide();
      $(".select-action").show();
      $(".url-value").attr("value","");
      $(".url-save").text("保存");
      $(".pre-graphic-title").text("");
      $(".graphic-des").text("");
      $(".graphic-url").text("");
      $(".text3").hide();
      $(".graphic-add").text("保存");
      $(".mesg-panel-text").html("");
      $(".mesg-save").text("保存");
    }
    if (type == "view") {
      $(".select-action").hide();
      $(".edit-mesg").hide();
      $(".edit-url").show();
      if(url == "") {
        $(".url-value").attr("value","");
      }
      else {
        $(".url-value").attr("value",url);
        $(".url-save").text("修改");
      }
    }
    if (type == "click") {
      $(".select-action").hide();
      $(".edit-url").hide();
      $(".edit-mesg").show();
      if(msgType == "news") {
        $(".edit-graphic").click();
        $(".pre-graphic-title").text(title);
        $(".graphic-des").text(description);
        $(".graphic-url").text(url);
        $(".text3").show();
        $(".preview-graphic-pic").attr("src",img);
        $(".preview-graphic-pic").show();
        $(".graphic-add").text("修改");
        cleanText();
        cleanImage();
      }
      else if(msgType == "image") {
        $(".edit-picture").click();
        $('.image-preview').attr("src",img);
        $('.image-preview').show();
        $(".pic-save").text("修改");
        cleanText();
        cleanGraphic();
      }
      else if(msgType == "text") {
        $(".edit-word").click();
        var htmlText = changeEmotion(description);
        $(".mesg-panel-text").html(htmlText);
        $(".mesg-save").text("修改");
        cleanGraphic();
        cleanImage();
      }
      else {

      }
    }
  });

  /*
  二级菜单删除
  */

  // 对于一级菜单删除通用.
  $('.delete-submenu-btn').on('click', function() {
    if(confirm("你确定要删除该菜单吗？")) {
      var id = $(this).data("id");
      $.ajax({
        type: "GET",
        url: "/admin/wx_menus/" + id + "/del/json",
        dataType: "json",
        success: function(data) {
          if (data.status == 'success') {
            alert("菜单已删除");
            _href = window.location.href;
            window.location.href = _href;
          } else {
            alert("菜单删除失败");
          }
        },
        complete: function(XMLHttpRequest, textStatus) {
          // code
        },
        error: function() {
          // code
        }
      });
    }
    else {
      return false;
    }
  });

  /*
  微信动作选择
  */
  $(".add-mesg").click(function() {
    $(".select-action").hide();
    $(".edit-mesg").show();
  });

  $(".add-url").click(function() {
    $(".select-action").hide();
    $(".edit-url").show();
  });

  /*
  菜单设置跳转网页功能
  */
  $("#new-url").validate({
    rules: {
      url: {
        required: true,
        url: true
      }
    },
    messages: {
      url: {
        required: "请输入url地址!!!",
        url: "请输入正确的url地址!!!"
      }
    },
    submitHandler:function(){
      var url = $(".url-save").parents(".edit-url").find(".url-value").val();
      var id =  $(".url-save").parents(".edit-url").find(".menu-id").val();
      var buttonType ="view";
      $.ajax({
        type: "POST",
        url: "/admin/wx_menus/"+id+"/action/set",
        dataType: "json",
        data: {
          button_type: buttonType,
          url: url
        },
        success: function(data) {
          if (data.status == 'success') {
            alert("地址设置成功");
            $(".url-value").attr("value",url);
            $("#menu"+id).data("url",url);
            // 菜单id，动作（none，view，click），消息类型（text,image,news）,标题，描述，链接，图片
            updataMenuInf(id,buttonType,"","","",url,"");
          } else {
            alert("地址设置失败");
          }
        },
        complete: function(XMLHttpRequest, textStatus) {
          // code
        },
        error: function() {
          // code
        }
      });
    }
  });

  $(".url-value").focus(function(){
    $(".url-mesg").hide();
  });

  /*
  文字
  */
  sendMessage();
  (function(bool) {
    //兼容FF一些方法
    var html;
    if (bool) {
      window.__defineGetter__("event", function() {
        //兼容Event对象
        var o = arguments.callee;
        do {
          if (o.arguments[0] instanceof Event) return o.arguments[0];
        } while (o = o.caller);
        return null;
      });

    }
  })(/Firefox/.test(window.navigator.userAgent));
  $(".icon_emotion").click(function() {
    $(".expression").fadeIn("500");
    (function(e) {
      var e = window.event || e;
      if (e.stopPropagation) e.stopPropagation();
      else e.cancelBubble = true;
    })(event)
  });
  $(".icon-emotion").click(function() {
    var imgPath = $(this).find(".expression-img").attr("src");
    var img = $("<img>").attr("src", imgPath).addClass("expression-img");
    $(".mesg-panel-text").append(img);
    (function(e) {
      var e = window.event || e;
      if (e.stopPropagation) e.stopPropagation();
      else e.cancelBubble = true;
    })(event)
  });
  $("body").click(function() {
    $(".expression").fadeOut("500");
  });


  /*
  设置动作导航
  */
  $(".edit-word").click(function() {
    $(this).css("background", "#fff");
    $(this).css("borderTop", "2px solid #5CA849");
    $(".edit-pic-body").hide();
    $(".edit-graphic-body").hide();
    $(".edit-picture").css("borderTop", "0");
    $(".edit-picture").css("background", "#ececec");
    $(".edit-graphic").css("borderTop", "0");
    $(".edit-graphic").css("background", "#ececec");
    $(".edit-mesg-body").show();
  });

  $(".edit-picture").click(function() {
    $(this).css("background", "#fff");
    $(this).css("borderTop", "2px solid #5CA849");
    $(".edit-word").css("borderTop", "0");
    $(".edit-word").css("background", "#ececec");
    $(".edit-graphic").css("borderTop", "0");
    $(".edit-graphic").css("background", "#ececec");;
    $(".edit-mesg-body").hide();
    $(".edit-graphic-body").hide();
    $(".edit-pic-body").show();
  });

  $(".edit-graphic").click(function() {
    $(this).css("background", "#fff");
    $(this).css("borderTop", "2px solid #5CA849");
    $(".edit-word").css("borderTop", "0");
    $(".edit-word").css("background", "#ececec");
    $(".edit-picture").css("borderTop", "0");
    $(".edit-picture").css("background", "#ececec");
    $(".edit-mesg-body").hide();
    $(".edit-pic-body").hide();
    $(".edit-graphic-body").show();
  });


  /*
  上传图片
  */
  $(".upload-pic-btn").click(function() {
    var msgType = "image";
    $("#fileupload").trigger("click");
    $("#fileupload").fileupload({
      url: "/admin/wx_menus/images/upload",
      formData: {
        msg_type: msgType
      },
      dataType: 'json',
      done: function(e, result) {
        if (result.result.status == "success") {
          alert("上传图片成功");
          var imgUrl = result.result.url;
          var mediaId = result.result.media_id;
          $(".media-id").attr("value",mediaId);
          $(".picture-url").attr("value",imgUrl);
          $(".image-preview").attr("src",imgUrl);
          $(".image-preview").show();
        }
        else if (result.result.status == "weixin_failed") {
          alert("上传微信失败");
        }
        else {
          alert("上传失败");
        }
      }
    });
  });

  /*
  设置发送图片动作
  */
  $(".pic-save").click(function(){
    var buttonType = "click";
    var msgType = "image";
    var id = $(".mesg-menu-id").val();
    var mediaId = $(".media-id").val();
    var imgUrl = $(".picture-url").val();
    $.ajax({
      type: "POST",
      url: "/admin/wx_menus/"+id+"/action/set",
      dataType: "json",
      data: {
        button_type: buttonType,
        msg_type: msgType,
        media_id: mediaId,
        img: imgUrl
      },
      success: function(data) {
        alert("发送成功");
        // 菜单id，动作（none，view，click），消息类型（text,image,news）,标题，描述，链接，图片
        updataMenuInf(id,buttonType,msgType,"","","",imgUrl);
        cleanGraphic();
        cleanText();
      },
      complete: function(XMLHttpRequest,textStatus) {

      },
      error: function() {

      }
    });
  });

  /*
  上传图文图片
  */
  $("#graphic_picture").click(function(){
    $(".graphic-picture-preview").empty();
    var msgType = "news";
    $("#graphic_picture").fileupload({
      url: "/admin/wx_menus/images/upload",
      formData: {
        msg_type: msgType
      },
      dataType: 'json',
      done: function(e, result) {
        if (result.result.status == "success") {
          alert("上传成功");
          var imgUrl = result.result.url;
          var img = $("<img></img>").attr("src",imgUrl);
          $(".graphic-picture-preview").append(img);
          $(".graphic-pic-pre-url").attr("value",imgUrl);
        }
        else {
          alert("上传失败");
        }
      }
    });
  });

  /*
  发送图文

  $(".save-graphic").click(function(){
    var title = $("#graphic_title").val();
    var description = $("#graphic_des").val();
    var url = $("#url").val();
    var img = $(".graphic-pic-pre-url").val();
    if(title == "") {
      alert("请输入标题");
      return false;
    }
    else if(description == "") {
      alert("请输入描述");
      return false;
    }
    else if(url == "") {
      alert("请输入链接");
      return false;
    }
    else if(img == "") {
      alert("请上传图片");
      return false;
    }
    else {
      var buttonType = "click";
      var msgType = "news";
      var id = $(".mesg-menu-id").val();
      $.ajax({
        type: "POST",
        url: "/admin/wx_menus/"+id+"/action/set",
        dataType: "json",
        data: {
          button_type: buttonType,
          msg_type: msgType,
          title: title,
          description: description,
          img: img,
          url: url
        },
        success: function(data) {
          alert("发送成功");
          $(".pre-graphic-title").text(title);
          $(".graphic-des").text(description);
          $(".graphic-url").text(url);
          $(".preview-graphic-pic").attr("src",img);
          $(".preview-graphic-pic").show();
          // 菜单id，动作（none，view，click），消息类型（text,image,news）,标题，描述，链接，图片
          updataMenuInf(id,buttonType,msgType,title,description,url,img);
          $(".text3").show();
          cleanText();
          cleanImage();
          $("#graphic_title").attr("value","");
          $("#graphic_des").attr("value","");
          $("#url").attr("value","");
          $(".graphic-pic-pre-url").attr("value","");
        },
        complete: function(XMLHttpRequest,textStatus) {

        },
        error: function() {

        }
      });
    }

  });
  */
$(".save-graphic").click(function(){
 $("#new-graphic").validate({
    rules: {
      url: {
        required: true,
        url: true,
      },
      graphic_title: {
        required: true
      }
    },
    messages: {
      url: {
        required: "请输入url地址",
        url: "请输入正确的url地址"
      },
      graphic_title: {
        required: "请输入标题"
      }
    }
  });
  var value = $("#new-graphic").valid();
});


  /*
  选择图文
  */
  $(".select-graphic").click(function() {
    var selectGraphicFlag = $(this).find(".selectGraphicFlag").attr("value");
    if (selectGraphicFlag == "true") {
      $(this).children(".graphic-item").addClass("graphic-item-ba");
      $(this).find(".graphic-select-ico").show();
      $(this).find(".selectGraphicFlag").attr("value", "false");
      $(this).siblings(".select-graphic").children(".graphic-item").removeClass("graphic-item-ba");
      $(this).siblings(".select-graphic").find(".graphic-select-ico").hide();
      $(this).siblings(".select-graphic").find(".selectGraphicFlag").attr("value", "true");
    } else {
      $(this).children(".graphic-item").removeClass("graphic-item-ba");
      $(this).find(".graphic-select-ico").hide();
      $(this).find(".selectGraphicFlag").attr("value", "true");
    }
  });

  /*
  文字输入回车事件
  */
  $(".mesg-panel-text").keydown(function(e){
    if(e.keyCode == 13) {
      $(".mesg-save").click();
    }
  });
/*
编辑器
*/
  $.fn.editable.defaults.mode = 'popup';
  $('.wx-menu-editable').editable({
    validate: function(value) {
      var length = 0;
      for (var i = 0; i < value.length; i++) {
        var menuNameLength = value.charCodeAt(i);
        if (menuNameLength >= 0 && menuNameLength <= 128) {
          length += 1;
        }
        else {
          length += 2;
        }
      }
      if(value == "") {
        return '菜单名字不能为空';
      }
      if(length > 8) {
        return '菜单名称不能超过4个汉字或8个字母';
      }
    }
  });

  $('.submenu').editable({
    validate: function(value) {
      var length = 0;
      for (var i = 0; i < value.length; i++) {
        var menuNameLength = value.charCodeAt(i);
        if (menuNameLength >= 0 && menuNameLength <= 128) {
          length += 1;
        }
        else {
          length += 2;
        }
      }
      if(value == "") {
        return '菜单名字不能为空';
      }
      if(length > 16) {
        return '菜单名称不能超过8个汉字或16个字母';
      }
    }
  });

  /*
  菜单发布
  */
  $(".menu-publish").click(function(){
    $.ajax({
      type: 'GET',
      url: 'weixin/menus/create/json',
      dataType: 'json',
      success: function(data) {
        if(data.status == 'success') {
          alert('菜单发布成功');
        }
        else {
          alert('菜单发布失败');
        }
      },
      complete: function(XMLHttpRequest,textStatus) {

      },
      error: function() {

      }
    });
  });

  /*
  文字发送
  */
  function sendMessage() {
    $(".mesg-save").on('click', function() {
      var replyContent = $(".mesg-panel-text").html();
      if(replyContent.length <= 0) {
        alert("请输入内容");
        return false;
      }
      for (i = 0; i < 105; i++) {
        var code = "" + i + ".gif\">";
        var re = new RegExp("<img class=\"expression-img\" src=\"https://res.wx.qq.com/mpres/htmledition/images/icon/emotion/" + code, "g");
        replyContent = replyContent.replace(re, emotionData[i]);
      }
      var buttonType = "click";
      var msgType = "text";
      var id = $(".mesg-menu-id").val();
      $.ajax({
        type: "POST",
        url: "/admin/wx_menus/"+id+"/action/set",
        dataType: "json",
        data: {
          button_type: buttonType,
          msg_type: msgType,
          content: replyContent
        },
        success: function(data) {
          alert("发送成功");
          // 菜单id，动作（none，view，click），消息类型（text,image,news）,标题，描述，链接，图片
          updataMenuInf(id,buttonType,msgType,"",replyContent,"","");
          cleanGraphic();
          cleanImage();
        },
        complete: function(XMLHttpRequest,textStatus) {

        },
        error: function() {

        }
      });
    });
  }



  /*
  表情编码转换为表情
  */
  function changeEmotion(emotionCode) {
    for (i = 0; i < 105; i++) {
      var data = new RegExp(emotionData[i], "g");
      var re = "<img class='expression-img' src='https://res.wx.qq.com/mpres/htmledition/images/icon/emotion/"+i+".gif'>";
      emotionCode = emotionCode.replace(data, re);
    }
    return emotionCode;
  }

  function updataMenuInf(id,submenutype,msgtype,title,description,url,img) {
    $("#menu"+id).data("submenutype",submenutype);
    $("#menu"+id).data("msgtype",msgtype);
    $("#menu"+id).data("title",title);
    $("#menu"+id).data("description",description);
    $("#menu"+id).data("url",url);
    $("#menu"+id).data("img",img);
  }

  function cleanGraphic() {
    $(".pre-graphic-title").text("");
    $(".graphic-des").text("");
    $(".graphic-url").text("url");
    $(".text3").hide();
    $(".preview-graphic-pic").attr("src","");
    $(".preview-graphic-pic").hide();
  }
  function cleanText() {
    $(".mesg-panel-text").html("");
  }
  function cleanImage() {
    $(".image-preview").attr("src","");
    $(".image-preview").hide();
  }
});
