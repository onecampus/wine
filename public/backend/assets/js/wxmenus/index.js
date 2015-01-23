$(document).ready(function() {
  showMenuEdit();
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
            alert(data.msg);
            _href = window.location.href;
            window.location.href = _href;
          } else {
            alert(data.msg);
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
  一级菜单动作设置
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
            alert(data.msg);
            _href = window.location.href;
            window.location.href = _href;
          } else {
            alert(data.msg);
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
    var type = $(this).data("submenutype");
    var menuId = $(this).data("id");
    $(".menu-id").attr("value",menuId);
    $(".mesg-menu-id").attr("value",menuId);
    if (type == "none") {
      $(".edit-url").hide();
      $(".edit-mesg").hide();
      $(".select-action").show();
    }
    if (type == "view") {
      $(".select-action").hide();
      $(".edit-mesg").hide();
      $(".edit-url").show();
    }
    if (type == "click") {
      $(".select-action").hide();
      $(".edit-url").hide();
      $(".edit-mesg").show();
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
            alert(data.msg);
            _href = window.location.href;
            window.location.href = _href;
          } else {
            alert(data.msg);
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

  $(".url-save").click(function(){
    var url = $(this).parents(".edit-url").find(".url-value").val();
    var id =  $(this).parents(".edit-url").find(".menu-id").val();
    var buttonType ="view";
    if(url == "") {
      $(".url-mesg").show();
      return false;
    }
    else {
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
            alert(data.msg);
            _href = window.location.href;
            window.location.href = _href;
          } else {
            alert(data.msg);
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
    $(".preview-pic").empty();
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
          var imgUrl = result.result.data;
        }
        else if (result.result.status == "weixin_failed") {
          alert("上传微信失败")
          var imgUrl = result.result.url;
          var img = $("<img></img>").attr("src",imgUrl);
          $(".preview-pic").append(img);
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
    $.ajax({
      type: "POST",
      url: "/admin/wx_menus/"+id+"/action/set",
      dataType: "json",
      data: {
        button_type: buttonType,
        msg_type: msgType,
      },
      success: function(data) {
        alert("发送成功");
        _href = window.location.href;
        window.location.href = _href;
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
  */
  $(".save-graphic").click(function(){
    $(".preview-graphic").empty();
    var title = $("#graphic_title").val();
    var description = $("#graphic_des").val();
    var url = $("#graphic_url").val();
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
          var previewimg = $("<img></img>").attr("src",img);
          $(".preview-graphic").append(previewimg);
        },
        complete: function(XMLHttpRequest,textStatus) {

        },
        error: function() {

        }
      });
    }

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
  文字发送
  */
  function sendMessage() {
    $(".mesg-save").on('click', function() {
      var data = {
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
      var replyContent = $(".mesg-panel-text").html();
      if(replyContent.length <= 0) {
        alert("请输入内容");
        return false;
      }
      for (i = 0; i < 105; i++) {
        var code = "" + i + ".gif\">";
        var re = new RegExp("<img class=\"expression-img\" src=\"https://res.wx.qq.com/mpres/htmledition/images/icon/emotion/" + code, "g");
        replyContent = replyContent.replace(re, data[i]);
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
          $(".mesg-panel-text").empty();
        },
        complete: function(XMLHttpRequest,textStatus) {

        },
        error: function() {

        }
      });
    });
  }
});



(function() {
  $(document).on('ready page:load', function() {
    $.fn.editable.defaults.mode = 'popup';
    $('.wx-menu-editable').editable();
    $('.publish-menu').on('click', function() {
      $.ajax({
        type: "GET",
        url: "/admin/weixin/menus/create/json",
        dataType: "json",
        success: function(data) {
          alert(data.msg);
        },
        complete: function(XMLHttpRequest, textStatus) {
          // code
        },
        error: function() {
          // code
        }
      });
      return false;
    });
    /*
    $('.sub-menu-add').on('click', function() {
      parent_id = $(this).data("id");
      $("input[name=parent_id]").val(parent_id);
    });
    */
    /*
    $('.menu-add').on('click', function() {
      _name = $("input[name=name]").val();
      _url = $("input[name=url]").val();
      _p_id = $("input[name=parent_id]").val();
      if (_name === '' || _url === '' || _p_id === '') {
        alert("请填写完整");
      } else {
        $.ajax({
          type: "POST",
          url: "/admin/wx_menus/create/json",
          dataType: "json",
          data: {
            name: _name,
            url: _url,
            parent_id: _p_id,
            level: 2
          },
          success: function(data) {
            if (data.status == 'success') {
              alert(data.msg);
              _href = window.location.href;
              window.location.href = _href;
            } else {
              alert(data.msg);
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
      return false;
    });
    */
  });
}).call(this);
